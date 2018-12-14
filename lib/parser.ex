defmodule Parser do

  def parse(str) do
	  ops = ["<=>", "=>", "^", "|", "+"]
	  case str |> remove_parentheses |> String.next_grapheme do
		  {a, b} -> parse("", b, a, ops)
		  _ -> IO.puts "Error"
	  end
  end

  def remove_parentheses(str) do
	  if String.first(str) == "(" and String.last(str) == ")" do
	  	remove_parentheses(str, 1, 1)
	  else
		str
	end
  end

  def remove_parentheses(str, index, depth) when depth == 0 do
	  newStr =
	  if index == String.length(str) do
	  	 String.slice(str, 1..-2)
	  else
		 str
	  end
	  newStr
  end

  def remove_parentheses(str, index, depth) do
	  if (index == String.length str) do
		 str
	  else
		  case String.at(str, index) do
			 "(" ->
				 remove_parentheses(str, index + 1, depth + 1)
			 ")" ->
				 remove_parentheses(str, index + 1, depth - 1)
			 _ ->
			 	remove_parentheses(str, index + 1, depth)
		  end
	  end
  end

  def remove_parentheses(str) do
	  str
  end

  def parse(first, rest, current, []) when rest == "" do
	  first <> current
  end

  def parse(first, rest, current, [ ops1 | opsRest ]) when rest == "" do
	  {a, b} = String.next_grapheme(first <> current)
	   parse("", b, a, opsRest)
  end

  def parse(first, rest, current, ops) when current == "(" do
 	 parse(first, rest, "(", ops, 0)
  end

  def parse(first, rest, current, ops) when current in ["=", "<", "<="] do
	 {a, b} = String.next_grapheme(rest)
 	 parse(first, b, current <> a, ops)
  end

  def parse(first, rest, current, [ ops1 | opsRest ]) when current == ops1 do
	  left =
		if String.match?(first, ~r/^[a-z]$/i) do
			IO.puts "Leaf <: " <> first
		  	Tree.leaf(first)
		else
			IO.puts "Parse left: " <> first
			parse(first)
		end
	  right =
		  if String.match?(rest, ~r/^[a-z]$/i) do
			  IO.puts "Leaf >: " <> rest
			  Tree.leaf(rest)
		  else
			  IO.puts "Parse right: " <> rest
			  parse(rest)
		  end
	IO.puts "Branch: " <> current
 	  Tree.branch(current, left, right)
  end

  def parse(first, rest, current, ops) do
	  {a, b} = String.next_grapheme(rest)
	  parse(first <> current, b, a, ops)
  end

  def parse(first, rest, current, ops, depth) do
	  case String.next_grapheme(rest) do
		  {"(", b} ->
			  parse(first, b, current <> "(", ops, depth + 1)
     	  {")", b} ->
			  	if depth == 0 do
			  		parse(first, b, current <> ")", ops)
				else
					parse(first, b, current <> ")", ops, depth - 1)
				end
		  {a, b} -> parse(first, b, current <> a, ops, depth)
      end
  end

end
