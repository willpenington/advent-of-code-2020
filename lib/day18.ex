
defmodule AdventOfCode.Day18 do
  alias AdventOfCode.Util

  @day_number 18

  def process() do
    data = load_data()

    IO.puts("Part 1: #{part1(data)}, Part 2: #{part2(data)}")
  end

  def calculate_simple(expr) when is_integer(expr) do
    expr
  end

  def calculate_simple([x, "+", y | tail]) do
    calculate_simple([calculate_simple(x) + calculate_simple(y) | tail])
  end

  def calculate_simple([x, "*", y | tail]) do
    calculate_simple([calculate_simple(x) * calculate_simple(y) | tail])
  end

  def calculate_simple([x]) do
    calculate_simple(x)
  end

  def part1(data) do
    Enum.map(data, &calculate_simple/1)
    |> Enum.sum()
  end

  def calculate_advanced(expr) when is_integer(expr) do
    expr
  end

  def calculate_advanced(expr) do
    if "*" in expr do
      {sub_expr, ["*" | tail]} = Enum.split_while(expr, fn x -> x != "*" end)
      calculate_advanced(sub_expr) * calculate_advanced(tail)
    else
      Enum.reject(expr, fn x -> x == "+" end)
      |> Enum.map(&calculate_advanced/1)
      |> Enum.sum()
    end
  end

  def part2(data) do
    Enum.map(data, &calculate_advanced/1)
    |> Enum.sum()
  end


  defp add_at_depth(val, list, 0) do
    [val | list]
  end
  defp add_at_depth(val, [first | list], depth) do
    [add_at_depth(val, first, depth - 1) | list]
  end

  def reverse_helper(expr) when not is_list(expr) do
    expr
  end
  def reverse_helper(expr) do
    Enum.map(expr, &reverse_helper/1)
    |> Enum.reverse()
  end

  def parse_group_helper(<<>>, state) do
    state
  end

  def parse_group_helper(<<" ", tail::binary()>>, state) do
    parse_group_helper(tail, state)
  end

  def parse_group_helper(<<"(", tail::binary()>>, {expr, depth}) do
    #Open new active group
    state = {add_at_depth([], expr, depth), depth + 1}
    parse_group_helper(tail, state)
  end

  def parse_group_helper(<<")", tail::binary()>>, {expr, depth}) do
    # Close current group
    parse_group_helper(tail, {expr, depth - 1})
  end

  def parse_group_helper(<<c::binary-size(1), tail::binary()>>, {expr, depth}) do
    x = case Integer.parse(c) do
      {val, ""} -> val
      _ -> c
    end

    state = {add_at_depth(x, expr, depth), depth}
    parse_group_helper(tail, state)
  end

  def parse_equation(line) do
    {expr, 0} = parse_group_helper(line, {[], 0})

    reverse_helper(expr)
  end

  defmodule Sigil do
  def sigil_e(equation, []) do
    AdventOfCode.Day18.parse_equation(equation)
  end

  end

  def load_data() do
    Util.find_input(@day_number)
    |> Util.load_line_delimited_input()
    |> Enum.map(&parse_equation/1)
  end

end
