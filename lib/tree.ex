defmodule Tree do
  def leaf(prop), do: {:leaf, prop}
  def branch(op, left, right), do: {:branch, op, left, right}

  def is_conclusion?({:branch, op, left, {:leaf, conclusion}}, goal), do: goal == conclusion
end
