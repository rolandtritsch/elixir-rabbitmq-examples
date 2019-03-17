defmodule PubSub.Receive do
  @moduledoc """
  Implementing the `Publish/Subscribe` RabbitMQ example.
  """

  @exchange "gossip"

  @doc """
  Wait for messages (with a given delay/timeout).
  """
  def wait_for_messages(delay, timeout) do
    receive do
      {:basic_deliver, payload, _meta} ->
        IO.puts(payload)
        Process.sleep(delay)
        wait_for_messages(delay, timeout)
    after
      timeout -> :ok
    end
  end

  @doc """
  Parse the args, connect to RabbitMQ and start to process messages.
  """
  def start(args) do
    {delay, _} = args |> Enum.at(0) |> Integer.parse()
    {timeout, _} = args |> Enum.at(1) |> Integer.parse()

    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)
    {:ok, %{queue: qname}} = AMQP.Queue.declare(channel, "", exclusive: true)

    AMQP.Exchange.declare(channel, @exchange, :fanout)
    AMQP.Queue.bind(channel, qname, @exchange)
    AMQP.Basic.consume(channel, qname, nil, no_ack: true)

    wait_for_messages(delay, timeout)

    AMQP.Channel.close(channel)
    AMQP.Connection.close(connection)
  end
end

System.argv() |>  PubSub.Receive.start()
