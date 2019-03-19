defmodule RPC.Server do
  @moduledoc """
  Implementing the `RPC` RabbitMQ example.
  """

  @queue "reverser"

  @doc """
  Wait for messages (and time out when no more messages arrive).
  """
  def wait_for_messages(channel, timeout) do
    receive do
      {:basic_deliver, payload, meta} ->
        AMQP.Basic.publish(
          channel,
          "",
          meta.reply_to,
          "#{String.reverse(payload)}",
          correlation_id: meta.correlation_id
        )
        AMQP.Basic.ack(channel, meta.delivery_tag)

        wait_for_messages(channel, timeout)
    after
      timeout -> :ok
    end
  end

  @doc """
  Parse the args, connect to RabbitMQ and start to process messages.
  """
  def start(args) do
    {timeout, _} = args |> Enum.at(0) |> Integer.parse()

    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)

    AMQP.Queue.declare(channel, @queue)
    AMQP.Basic.qos(channel, prefetch_count: 1)
    AMQP.Basic.consume(channel, @queue)

    wait_for_messages(channel, timeout)

    AMQP.Channel.close(channel)
    AMQP.Connection.close(connection)
  end
end

System.argv() |>  RPC.Server.start()
