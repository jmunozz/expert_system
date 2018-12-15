defmodule ExpertSystemTest do
  use ExUnit.Case
  doctest ExpertSystem

  test "Simple test with only one rule" do
    rules = [{:branch, "=>", {:branch, "+", {:leaf, "A"}, {:leaf, "B"}}, {:leaf, "C"}}]
    facts = %{"A" => true, "B" => true}
    goals = ["C"]

    assert ExpertSystem.resolve(rules, facts, goals) ==
             {:ok, %{"A" => true, "B" => true, "C" => true}}
  end

  test "Simple test with two rules" do
    rules = [
      {:branch, "=>", {:branch, "+", {:leaf, "A"}, {:leaf, "B"}}, {:leaf, "C"}},
      {:branch, "=>", {:branch, "+", {:leaf, "D"}, {:leaf, "E"}}, {:leaf, "F"}}
    ]

    facts = %{"D" => true, "E" => true}
    goals = ["F"]

    assert ExpertSystem.resolve(rules, facts, goals) ==
             {:ok, %{"D" => true, "E" => true, "F" => true}}
  end

  # test "Simple test with two rules more complex" do
  #   rules = [
  #     {:branch, "=>", {:branch, "+", {:leaf, "A"}, {:leaf, "B"}}, {:leaf, "C"}},
  #     {:branch, "=>", {:branch, "+", {:leaf, "C"}, {:leaf, "E"}}, {:leaf, "F"}}
  #   ]
  #
  #   facts = %{"A" => true, "B" => true, "E" => true}
  #   goals = ["F"]
  #
  #   assert ExpertSystem.resolve(rules, facts, goals) ==
  #            {:ok, %{"A" => true, "B" => true, "F" => true}}
  # end
end
