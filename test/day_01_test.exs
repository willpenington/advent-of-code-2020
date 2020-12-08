defmodule Day01Test do
  use ExUnit.Case, async: true
  doctest AdventOfCode.Day01

  alias AdventOfCode.Day01

  @example_list [1721, 979, 366, 299, 675, 1456]

  test "find the product of two entries that sum to a target" do
    assert Day01.find_two_entries(@example_list, 2020) == 514_579
  end

  test "find the product of three entries that sum to a target" do
    assert Day01.find_three_entries(@example_list, 2020) == 241_861_950
  end
end
