defmodule Tree do
  def leaf(prop), do: {:leaf, prop}
  def branch(op, left, right), do: {:branch, op, left, right}
end
