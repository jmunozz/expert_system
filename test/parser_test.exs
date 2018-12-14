defmodule ParserTest do
  use ExUnit.Case

  test "A+B" do
    assert Parser.parse("A+B") == {:branch, "+", {:leaf, "A"}, {:leaf, "B"}}
  end

  test "((A+B)|C)^B" do
    assert Parser.parse("((A+B)|C)^B") ==
             {:branch, "^",
              {:branch, "|", {:branch, "+", {:leaf, "A"}, {:leaf, "B"}}, {:leaf, "C"}},
              {:leaf, "B"}}
  end

  test "A+B|C=>D" do
    assert Parser.parse("A+B|C=>D") ==
             {:branch, "=>",
              {:branch, "|", {:branch, "+", {:leaf, "A"}, {:leaf, "B"}}, {:leaf, "C"}},
              {:leaf, "D"}}
  end

  test "A+B|(C=>D)" do
    assert Parser.parse("A+B|(C=>D)") ==
             {:branch, "|", {:branch, "+", {:leaf, "A"}, {:leaf, "B"}},
              {:branch, "=>", {:leaf, "C"}, {:leaf, "D"}}}
  end

  test "A+(B|S)^(C=>D)" do
    assert Parser.parse("A+(B|S)^(C=>D)") ==
             {:branch, "^",
              {:branch, "+", {:leaf, "A"}, {:branch, "|", {:leaf, "B"}, {:leaf, "S"}}},
              {:branch, "=>", {:leaf, "C"}, {:leaf, "D"}}}
  end

  test "(A)+((B|S)^(C=>D))" do
    assert Parser.parse("(A)+((B|S)^(C=>D))") ==
             {:branch, "+", {:leaf, "A"},
              {:branch, "^", {:branch, "|", {:leaf, "B"}, {:leaf, "S"}},
               {:branch, "=>", {:leaf, "C"}, {:leaf, "D"}}}}
  end

  test "(A) + (( B|S )^     (C	=>D ))     \n" do
    assert Parser.parse("(A) + (( B|S )^     (C	=>D ))     \n") ==
             {:branch, "+", {:leaf, "A"},
              {:branch, "^", {:branch, "|", {:leaf, "B"}, {:leaf, "S"}},
               {:branch, "=>", {:leaf, "C"}, {:leaf, "D"}}}}
  end

  # ERROR
  test "A++B" do
    assert_raise Parser, fn ->
      Parser.parse("A++B")
    end
  end

  test "A+++B" do
    assert_raise Parser, fn ->
      Parser.parse("A+++B")
    end
  end

  test "(A=>B" do
    assert_raise Parser, fn ->
      Parser.parse("(A=>B")
    end
  end
end
