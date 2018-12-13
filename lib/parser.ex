defmodule Parser do

  def parse(str) do
	  {a, b} = String.next_grapheme(str)
	  parse(a, b, "")
  end

  def parse(first, rest, current) when current in ["+", "^", "|"] do
 	 [first, rest]
  end

  def parse(first, rest, current) when current in ["+", "^", "|"] do
 	 [first, rest]
  end

  def parse(first, rest, current) do
	  {a, b} = String.next_grapheme(rest)
	  parse(first <> current, b, a)
  end



end
