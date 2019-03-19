defmodule RPC.Send do
  @moduledoc """
  Implementing the `RPC` RabbitMQ example.
  """

  @queue "reverser"

  @doc """
  Wait for replay to arrive.
  """
  def wait_for_reply(cid) do
    receive do
      {:basic_deliver, payload, %{correlation_id: ^cid}} ->
        payload
    end
  end

  @doc """
  Send a message (and wait for a/the result). .
  """
  def reverse(channel, qreply, message) do
   cid =
      :erlang.unique_integer
      |> :erlang.integer_to_binary
      |> Base.encode64

    AMQP.Basic.publish(
      channel,
      "",
      @queue,
      message,
      reply_to: qreply,
      correlation_id: cid
    )

    wait_for_reply(cid)
  end

  @doc """
  Parse the args, connect to RabbitMQ and start to send the messages.
  """
  def start(args) do
    message = args |> Enum.at(0)

    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)
    {:ok, %{queue: qreply}} = AMQP.Queue.declare(
      channel, "", exclusive: true
    )
    AMQP.Basic.consume(channel, qreply, nil, no_ack: true)

    reverse(channel, qreply, message) |> IO.puts

    AMQP.Channel.close(channel)
    AMQP.Connection.close(connection)
  end
end

System.argv() |> RPC.Send.start()
