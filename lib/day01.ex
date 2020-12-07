defmodule AdventOfCode.Day01 do
  alias AdventOfCode.Util

  @path ["priv", "day01", "input"]

  @target 2020

  def process() do
    IO.puts("Part 1: #{part1()}, Part 2: #{part2()}")
  end

  def part1() do
    Util.load_line_delimited_input(@path)
    |> Enum.map(&String.to_integer/1)
    |> find_two_entries(@target)
  end

  def part2() do
    Util.load_line_delimited_input(@path)
    |> Enum.map(&String.to_integer/1)
    |> find_three_entries(@target)
  end

  @doc ~S"""
  Find the product of two items in the list that sum to the target.

  Finds two numbers in a list of integers that sum to the target and returns the product.

  If there aren't two numbers that sum to the target nil is returned instead.

  ## Examples

      iex> AdventOfCode.Day01.find_two_entries([1721, 979, 336, 299, 675, 1456], 2020)
      514579

  """
  def find_two_entries(values, target) do
    (for x <- values, y <- values, x + y == target, do: x * y)
    |> List.first
  end

  @doc ~S"""
  Find the product of three items in the list that sum to the target.

  Finds three numbers in a list of integers that sum to the target and returns the product.

  If there aren't three numbers that sum to the target nil is returned instead.

  ## Examples

      iex> AdventOfCode.Day01.find_three_entries([1721, 979, 366, 299, 675, 1456], 2020)
      241861950

  """
  def find_three_entries(values, target) do
    (for x <- values, y <- values, z <- values, x + y + z == target, do: x * y * z)
    |> List.first
  end
end
