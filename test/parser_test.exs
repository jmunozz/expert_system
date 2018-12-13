defmodule ParserTest do
  use ExUnit.Case

  test "greets the world" do
    assert Parser.parse("A+B+C") == ["A", "B+C"]
  end
end
