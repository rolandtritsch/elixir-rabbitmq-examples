defmodule Hello do
  @moduledoc """
  Implementing the Hello World RabbitMQ example.
  """

  @doc """
  Sending a message.
  """
  @spec send() :: none()
  def send() do
    {:ok, connection} = AMQP.Connection.open
    {:ok, channel} = AMQP.Channel.open(connection)

    AMQP.Queue.declare(channel, "hello")
    AMQP.Basic.publish(channel, "", "hello", "Hello World!")
    IO.puts " [x] Sent 'Hello World!'"
    AMQP.Connection.close(connection)
  end
end
