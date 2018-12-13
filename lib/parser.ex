defmodule Parser do

  def parse(str) do
	  case String.next_grapheme(str) do
		  {a, b} -> parse("", b, a)
		  _ -> IO.puts "Error"
	  end
  end

  def parse(first, rest, current) when rest == "" do
	  first <> current
  end

  def parse(first, rest, current) when current == "(" do
 	 parse(first, rest, "", 0)
  end

  def parse(first, rest, current) when current in ["=", "<", "<="] do
	 {a, b} = String.next_grapheme(rest)
 	 parse(first, b, current <> a)
  end

  def parse(first, rest, current) when current in ["<=>", "=>", "+", "^", "|"] do
	  left =
		if String.match?(first, ~r/^[a-z]$/i) do
		  	Tree.leaf(first)
		else
			parse(first)
		end
	  right =
		  if String.match?(rest, ~r/^[a-z]$/i) do
			  Tree.leaf(rest)
		  else
			  parse(rest)
		  end
 	  Tree.branch(current, left, right)
  end

  def parse(first, rest, current) do
	  {a, b} = String.next_grapheme(rest)
	  parse(first <> current, b, a)
  end

  def parse(first, rest, current, depth) do
	  case String.next_grapheme(rest) do
		  {"(", b} ->
			  parse(first, b, current <> "(", depth + 1)
     	  {")", b} ->
			  	if depth == 0 do
			  		parse(first, b, current)
				else
					parse(first, b, current <> ")", depth - 1)
				end
		  {a, b} -> parse(first, b, current <> a, depth)
      end
  end

end
