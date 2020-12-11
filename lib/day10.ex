defmodule AdventOfCode.Day10 do
  @moduledoc ~S"""
  Advent of Code Day 10: Adapter Array
  """

  alias AdventOfCode.Util

  @day_number 10

  @doc ~S"""
  Calculate and print the answers to both parts of the question
  """
  def process() do
    adapters = load_data()

    IO.puts("Part 1: #{part1(adapters)}, Part 2: #{part2(adapters)}")
  end

  @doc ~S"""
  Calculate the answer to part 1

  Calculate the product of the number of three jolt gaps and one jolt gaps when connecting every adapter
  """
  def part1(adapters) do
    sorted = Enum.sort(adapters)
    [first | _] = sorted

    gaps =
      count_gaps(sorted)
      |> Map.update(3, 1, fn x -> x + 1 end)
      |> Map.update(first, 1, fn x -> x + 1 end)

    gaps[1] * gaps[3]
  end

  @doc ~S"""
  Calculate the answer to part 2

  Calculate the total number of ways the adapters can be combined to reach the target voltage of the laptop
  (3 jolts higher than the highest rated adapter joltage).
  """
  def part2(adapters) do
    count_combinations(adapters, get_target(adapters))
  end

  defp count_gaps_helper([_], acc), do: acc

  defp count_gaps_helper([current, next | tail], acc) do
    count_gaps_helper([next | tail], Map.update(acc, next - current, 1, fn x -> x + 1 end))
  end

  @doc """
  Count the different sizes of gaps between numbers.

  Gaps are based on the difference between items and the values are retuned as a map.

  ## Examples
  Values for a sorted list (as used in part 1):

      iex> AdventOfCode.Day10.count_gaps([1, 2, 5, 6, 8, 11, 12, 14, 17])
      %{1 => 3, 2 => 2, 3 => 3}

  Out of order values:

      iex> AdventOfCode.Day10.count_gaps([10, 4, 5, 5, 9, 8, 12, 11])
      %{-6 => 1, -1 => 2, 0 => 1, 1 => 1, 4 => 2}

  """
  def count_gaps(adapters) do
    count_gaps_helper(adapters, Map.new())
  end

  @doc ~S"""
  Calculate the laptop joltage value for a list of adapters.

  The laptop joltage is 3 larger than the highest rated joltage adapter.
  """
  def get_target(adapters) do
    Enum.max(adapters) + 3
  end

  defp count_combinations_helper(_, target, value, previous) when value > target, do: previous

  defp count_combinations_helper(adapters, target, value, previous) do
    total =
      1..3
      |> Enum.map(fn difference ->
        cond do
          difference > value -> 0
          difference == value and difference in adapters -> 1
          (value - difference) in adapters -> Enum.at(previous, difference - 1)
          true -> 0
        end
      end)
      |> Enum.sum()

    # Slightly awkward but ordered to make tail call optimisation easier
    count_combinations_helper(adapters, target, value + 1, [total | previous])
  end

  @doc ~S"""
  Count the number of combinations of adapters that can reach the target joltage.

  The combinations are calculated by sequentially calculating the number of combinations
  for each value up to the target to avoid exponential run time.

  ## Examples

      iex> AdventOfCode.Day10.count_combinations([16, 10, 15, 5, 1, 11, 7, 19, 6, 12, 4], 21)
      8
  """
  def count_combinations(adapters, target) do
    count_combinations_helper(MapSet.new(adapters), target, 1, [])
    |> Enum.at(0)
  end

  @doc ~S"""
  Load and parse joltage adapter ratings
  """
  def load_data() do
    Util.find_input(@day_number)
    |> Util.load_line_delimited_input()
    |> Enum.map(&String.to_integer/1)
  end
end
