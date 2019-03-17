defmodule Work.Receive do
  @moduledoc """
  Implementing the `Work Queue` RabbitMQ example.
  """

  @queue "work"

  @doc """
  Wait for messages from a queue (with a given delay/timeout).
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

    AMQP.Queue.declare(channel, @queue)
    AMQP.Basic.consume(channel, @queue, nil, no_ack: true)

    wait_for_messages(delay, timeout)

    AMQP.Channel.close(channel)
    AMQP.Connection.close(connection)
  end
end

System.argv() |>  Work.Receive.start()
