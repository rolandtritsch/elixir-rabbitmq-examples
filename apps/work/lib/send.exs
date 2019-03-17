defmodule Work.Send do
  @moduledoc """
  Implementing the `Work Queue` RabbitMQ example.
  """

  @queue "work"

  @doc """
  Send message to a queue (n times, with a/the given delay).
  """
  def send(_, _, 0, _), do: :ok
  def send(channel, message, iterations, delay) do
    AMQP.Basic.publish(channel, "", @queue, ~s(#{message}-#{iterations}))
    Process.sleep(delay)
    send(channel, message, iterations - 1, delay)
  end

  @doc """
  Parse the args, connect to RabbitMQ and start to send the messages.
  """
  def start(args) do
    message = args |> Enum.at(0)
    {iterations, _} = args |> Enum.at(1) |> Integer.parse()
    {delay, _} = args |> Enum.at(2) |> Integer.parse()

    {:ok, connection} = AMQP.Connection.open
    {:ok, channel} = AMQP.Channel.open(connection)

    AMQP.Queue.declare(channel, @queue)

    send(channel, message, iterations, delay)

    AMQP.Channel.close(channel)
    AMQP.Connection.close(connection)
  end
end

System.argv() |> Work.Send.start()
