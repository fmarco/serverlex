defmodule ServerlexTest do
  use ExUnit.Case
  doctest Serverlex

  test "greets the world" do
    assert Serverlex.hello() == :world
  end
end
