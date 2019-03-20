# RabbitMQ Protobuf example

The client reads a JSON message from stdin, puts into a protobuf message
and sends it to the server. The server turns the protobuf message into
JSON and writes it to stdout.

* mix run lib/server.exs 30000
* echo '{"name":"roland", "birthday":"27-Jun-1965"}' | mix run lib/send.exs
* echo '{"name":"james", "birthday":"22-Mar-2233", "wealth":"100"}' | mix run lib/send.exs

Note: Please ignore the warning ...

```
warning: the Protobuf.Serializable protocol has already been consolidated, an implementation for Proto.Client.Person has no effect. If you want to implement protocols after compilation or during tests, check the "Consolidation" section in the documentation for Kernel.defprotocol/2
```