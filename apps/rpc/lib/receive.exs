defmodule RPC.Receive do
  @moduledoc """
  Implementing the `RPC` RabbitMQ example.
  """

  @exchange "gossip-rpc"

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
    key = args |> Enum.at(0)
    {delay, _} = args |> Enum.at(1) |> Integer.parse()
    {timeout, _} = args |> Enum.at(2) |> Integer.parse()

    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)

    {:ok, %{queue: qname}} = AMQP.Queue.declare(channel, "", exclusive: true)
    # {:ok, %{queue: qname}} = AMQP.Queue.declare(channel, celebrity)
    AMQP.Exchange.declare(channel, @exchange, :topic)
    AMQP.Queue.bind(channel, qname, @exchange, routing_key: key)
    AMQP.Basic.consume(channel, qname, nil, no_ack: true)

    wait_for_messages(delay, timeout)

    AMQP.Channel.close(channel)
    AMQP.Connection.close(connection)
  end
end

System.argv() |>  RPC.Receive.start()
