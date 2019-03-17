defmodule Hello.Send do
  @moduledoc """
  Implementing the Hello World RabbitMQ example.
  """

  @queue "hello"

  @doc """
  Send message to a queue.
  """
  def send(message) do
    {:ok, connection} = AMQP.Connection.open
    {:ok, channel} = AMQP.Channel.open(connection)

    AMQP.Queue.declare(channel, @queue)
    AMQP.Basic.publish(channel, "", @queue, message)

    AMQP.Channel.close(channel)
    AMQP.Connection.close(connection)
  end
end

System.argv() |> hd |> Hello.Send.send
