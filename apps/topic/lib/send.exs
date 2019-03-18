defmodule Topic.Send do
  @moduledoc """
  Implementing the `Topic` RabbitMQ example.
  """

  @exchange "gossip-topic"

  @doc """
  Send message (n times, with a/the given delay).
  """
  def send(_, _, _, 0, _), do: :ok
  def send(channel, topic, message, iterations, delay) do
    AMQP.Basic.publish(channel, @exchange, topic, ~s(#{message}-#{iterations}))
    Process.sleep(delay)
    send(channel, topic, message, iterations - 1, delay)
  end

  @doc """
  Parse the args, connect to RabbitMQ and start to send the messages.
  """
  def start(args) do
    topic = args |> Enum.at(0)
    message = args |> Enum.at(0)
    {iterations, _} = args |> Enum.at(1) |> Integer.parse()
    {delay, _} = args |> Enum.at(2) |> Integer.parse()

    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)

    AMQP.Exchange.declare(channel, @exchange, :topic)

    send(channel, topic, message, iterations, delay)

    AMQP.Channel.close(channel)
    AMQP.Connection.close(connection)
  end
end

System.argv() |> Topic.Send.start()
