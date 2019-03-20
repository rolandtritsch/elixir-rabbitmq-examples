defmodule Proto.Client do
  @moduledoc """
  Implementing a `Protobuf` RabbitMQ example.
  """

  import Kernel, except: [send: 2]

  use Protobuf, from: Path.expand("../proto/messages.proto", __DIR__)
  alias Proto.Client.Person

  @exchange "proto"

  @doc """
  Convert the JSON message protobuf and send it.
  """
  def send(channel, jmessage) do
    pmessage = Converter.j2p(jmessage, Person.new(name: "", birthday: ""),  &Person.encode/1)
    AMQP.Basic.publish(channel, @exchange, "", pmessage)
  end

  @doc """
  Read the JSON from stdin, connect to RabbitMQ and send the message.
  """
  def start() do
    jmessage = IO.read(:stdio, :all)

    {:ok, connection} = AMQP.Connection.open()
    {:ok, channel} = AMQP.Channel.open(connection)

    AMQP.Exchange.declare(channel, @exchange, :fanout)

    send(channel, jmessage)

    AMQP.Channel.close(channel)
    AMQP.Connection.close(connection)
  end
end

Proto.Client.start()
