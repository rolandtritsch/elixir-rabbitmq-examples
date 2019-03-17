defmodule Hello.Receive do
  @moduledoc """
  Implementing the Hello World RabbitMQ example.
  """

  @queue "hello"

  @doc """
  Wait for messages from a queue.
  """
  def wait_for_messages do
    receive do
      {:basic_deliver, payload, _meta} ->
        IO.puts payload
        wait_for_messages()
    after
      5000 -> :ok
    end
  end

  def receive do
    {:ok, connection} = AMQP.Connection.open
    {:ok, channel} = AMQP.Channel.open(connection)

    AMQP.Queue.declare(channel, @queue)
    AMQP.Basic.consume(channel, @queue, nil, no_ack: true)

    wait_for_messages()

    AMQP.Channel.close(channel)
    AMQP.Connection.close(connection)
  end
end

Hello.Receive.receive()
