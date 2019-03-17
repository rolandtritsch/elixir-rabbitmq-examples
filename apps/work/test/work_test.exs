defmodule WorkTest do
  use ExUnit.Case
  doctest Work

  test "greets the world" do
    assert Work.hello() == :world
  end
end
