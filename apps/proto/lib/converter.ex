defmodule Converter do
  @moduledoc """
  Simple JSON to Protobuf converter (and back).
  """

  @doc """
  Convert the given json to (an encoded) protobuf.
  """
  def j2p(jstring, pobject, pencode) do
    jlist = Jason.decode!(jstring) |> Map.to_list()
    mapj2p = fn {k, v}, acc ->
      case Integer.parse(v) do
        {n, ""} -> Map.put(acc, String.to_atom(k), n)
        _ -> Map.put(acc, String.to_atom(k), v)
      end
    end
    pmap = List.foldl(jlist, pobject, mapj2p)
    pencode.(pmap)
  end

  @doc """
  Convert the given (encoded) protobuf to json.
  """
  def p2j(pbuf, pdecode) do
    plist = pdecode.(pbuf) |> Map.to_list()
    mapp2j = fn
      {:__struct__, _}, acc -> acc
      {_, :nil}, acc -> acc
      {k, v}, acc when is_integer(v) -> Map.put(acc, Atom.to_string(k), ~s(#{v}))
      {k, v}, acc -> Map.put(acc, Atom.to_string(k), ~s(#{v}))
    end
    jmap = List.foldl(plist, Map.new(), mapp2j)
    Jason.encode!(jmap)
  end
end
