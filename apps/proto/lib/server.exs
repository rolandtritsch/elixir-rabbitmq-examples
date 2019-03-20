defmodule Proto.Server do
  @moduledoc """
  Implementing a `Protobuf` RabbitMQ example.
  """

  use Protobuf, from: Path.expand("../proto/messages.proto", __DIR__)
  alias Proto.Server.Person

  @exchange "proto"

  @doc """
  Wait for messages (with a given delay/timeout).
  """
  def wait_for_messages(timeout) do
    receive do
      {:basic_deliver, payload, _meta} ->
        Converter.p2j(payload, &Person.decode/1) |> IO.puts
        wait_for_messages(timeout)
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
    {:ok, %{queue: qname}} = AMQP.Queue.declare(channel, "", exclusive: true)

    AMQP.Exchange.declare(channel, @exchange, :fanout)
    AMQP.Queue.bind(channel, qname, @exchange)
    AMQP.Basic.consume(channel, qname, nil, no_ack: true)

    wait_for_messages(timeout)

    AMQP.Channel.close(channel)
    AMQP.Connection.close(connection)
  end
end

System.argv() |>  Proto.Server.start()
