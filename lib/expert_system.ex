defmodule ExpertSystem do
  # Resolve when there is no more goals
  # It's done, good job
  def resolve(rules, facts, []) do
    {:ok, facts}
  end

  # No more rules, no more goals
  def resolve({passedRules, []}, facts, {passedGoals, []}) do
    {:undefined, facts}
  end

  # No more rules -> Test next goal
  def resolve({passedRules, []}, facts, {passedGoals, [currentGoal | comingGoals]}) do
    resolve({[], passedRules}, facts, {passedGoals ++ [currentGoal], comingGoals})
  end

  # No more goals -> Test next goal
  def resolve(rules, facts, {passedGoals, []}) do
    resolve(rules, facts, {[], passedGoals})
  end

  # Resolver running
  def resolve(
        {passedRules, [currentRule | comingRules]},
        facts,
        {passedGoals, [currentGoal | comingGoals]}
      ) do
    case findGoal(currentRule, currentGoal, facts) do
      # We got something, new facts or new goals (or both)
      # Let's launch it again from the begining with those new goals and facts
      [newGoals: newGoals, newFacts: newFacts] ->
        resolve(
          {[], passedRules ++ [currentRule] ++ comingRules},
          Map.merge(facts, newFacts),
          (passedGoals ++ [currentGoal] ++ comingGoals ++ newGoals) -- Map.keys(newFacts)
        )

      # We cannot conclued anything from this rule
      # Let's try the next one
      :nothing ->
        resolve(
          {passedRules ++ [currentRule], comingRules},
          facts,
          {passedGoals, [currentGoal] ++ comingGoals}
        )
    end
  end

  # This should be the first call of resolve
  # List of rules => [ { :branch, o, l,r }, ... ]
  # List of facts => %{ "A" => true, "B" => false, ... }
  # List of goals => [ "A", "B", "C", ...]
  def resolve([rule | rRests], facts, [goal | rGoals]) do
    resolve(
      {[], [rule | rRests]},
      facts,
      {[], [goal | rGoals]}
    )
  end

  # When the conclusion is the goal
  def findGoal({:branch, "=>", left, {:leaf, right}}, goal, facts) when goal == right do
    case left do
      {:branch, "+", {:leaf, left}, {:leaf, right}} ->
        cond do
          Map.has_key?(facts, left) and Map.has_key?(facts, right) ->
            [newGoals: [], newFacts: %{goal => facts[left] and facts[right]}]

          true ->
            :nothing
        end

      _ ->
        :nothing
    end
  end

  # When the conclusion is not the goal
  def findGoal(_, _, _) do
    :nothing
  end

  def is_a_fact(goal, facts)
end
