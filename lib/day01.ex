defmodule AdventOfCode.Day01 do
  @moduledoc """
  Advent of Code Day 1: Report Repair
  """

  alias AdventOfCode.Util

  @path ["priv", "day01", "input"]

  @target 2020

  @doc ~S"""
  Calculate and print the answers to both parts of the question
  """
  @spec process() :: :ok
  def process() do
    data = load_data()

    IO.puts("Part 1: #{part1(data)}, Part 2: #{part2(data)}")
  end

  @doc ~S"""
  Find the product of two entries that sum to 2020
  """
  @spec part1([integer()]) :: integer()
  def part1(data) do
    find_two_entries(data, @target)
  end

  @doc ~S"""
  Find the product of three entries that sum to 2020
  """
  @spec part2([integer()]) :: integer()
  def part2(data) do
    find_three_entries(data, @target)
  end

  @spec load_data() :: [integer()]
  def load_data() do
    Util.load_line_delimited_input(@path)
    |> Enum.map(&String.to_integer/1)
  end

  @doc ~S"""
  Find the product of two items in the list that sum to the target.

  Finds two numbers in a list of integers that sum to the target and returns the product.

  If there aren't two numbers that sum to the target nil is returned instead.

  ## Examples

      iex> AdventOfCode.Day01.find_two_entries([1721, 979, 336, 299, 675, 1456], 2020)
      514579

  """
  @spec find_two_entries([integer()], integer()) :: integer()
  def find_two_entries(values, target) do
    for(x <- values, y <- values, x + y == target, do: x * y)
    |> List.first()
  end

  @doc ~S"""
  Find the product of three items in the list that sum to the target.

  Finds three numbers in a list of integers that sum to the target and returns the product.

  If there aren't three numbers that sum to the target nil is returned instead.

  ## Examples

      iex> AdventOfCode.Day01.find_three_entries([1721, 979, 366, 299, 675, 1456], 2020)
      241861950

  """
  @spec find_three_entries([integer()], integer()) :: integer()
  def find_three_entries(values, target) do
    for(x <- values, y <- values, z <- values, x + y + z == target, do: x * y * z)
    |> List.first()
  end
end
