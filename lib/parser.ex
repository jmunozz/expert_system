defmodule Parser do
  defexception message: "Parsing error"

  def parse(str) do
    ops = ["<=>", "=>", "^", "|", "+"]
    regex = ~r/^([a-z]|\().*([a-z]|\))$/i

    strNoWhite = String.replace(str, ~r/[\s\t\n]/, "")
    strNoPar = remove_parentheses(strNoWhite)

    if Regex.match?(regex, strNoPar) do
      case String.next_grapheme(strNoPar) do
        {a, b} -> parse("", b, a, ops)
        _ -> raise Parser, "Empty string"
      end
    else
      raise Parser, "Syntax error: #{str}"
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
    if index == String.length(str) do
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

  def parse(first, rest, current, []) when rest == "" do
    first <> current
  end

  def parse(first, rest, current, [_ | opsRest]) when rest == "" do
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

  def parse(first, rest, current, [ops1 | _]) when current == ops1 do
    left =
      if String.match?(first, ~r/^\(?[a-z]\)?$/i) do
        first |> remove_parentheses |> Tree.leaf()
      else
        parse(first)
      end

    right =
      if String.match?(rest, ~r/^\(?[a-z]\)?$/i) do
        rest |> remove_parentheses |> Tree.leaf()
      else
        parse(rest)
      end

    Tree.branch(current, left, right)
  end

  def parse(first, rest, current, ops) do
    {a, b} = String.next_grapheme(rest)
    parse(first <> current, b, a, ops)
  end

  def parse(first, _, _, _, depth) when depth < 0 do
    raise Parser, "Opening parenthese is missing: #{first}"
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

      {a, b} ->
        parse(first, b, current <> a, ops, depth)

      nil ->
        raise Parser, "Closing parenthese is missing: #{first}"
    end
  end
end
