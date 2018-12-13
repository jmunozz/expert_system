defmodule ParserTest do
  use ExUnit.Case

  test "A+B" do
	assert Parser.parse("A+B") == {:branch, "+", {:leaf, "A"}, {:leaf, "B"}}
  end

  test "((A+B)|C)^B" do
	assert Parser.parse("((A+B)|C)^B") == {:branch, "^", {:branch, "|", {:branch, "+", {:leaf, "A"}, {:leaf, "B"}}, {:leaf, "C"}}, {:leaf, "B"}}
  end

end
