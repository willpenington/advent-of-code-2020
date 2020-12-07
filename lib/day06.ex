defmodule AdventOfCode.Day06 do

  alias AdventOfCode.Util

  @day_number 6

  def process() do
    IO.puts("Part 1: #{part1()}, Part 2: #{part2()}")
  end

  def part1() do
    load_data()
    |> Enum.map(&count_unique_answers/1)
    |> Enum.sum()
  end

  def part2() do
    load_data()
    |> Enum.map(&count_unanimous_answers/1)
    |> Enum.sum()
  end

  def load_data() do
    Util.find_input(@day_number)
    |> Util.load_blank_line_delimited_input()
    |> Enum.map(&parse_record/1)
  end

  def parse_record(val) do
    String.split(val)
    |> Enum.map(&String.codepoints/1)
  end

  @doc ~S"""
  Count the number of unique answers in a record.

  Counts the number of letters that appear at least once in any answer in a record.

  ## Examples

      iex> AdventOfCode.Day06.count_unique_answers([["a", "b"], ["a", "c"]])
      3

      iex> AdventOfCode.Day06.count_unique_answers([["a", "b", "c"]])
      3

  """
  def count_unique_answers(record) do
    List.flatten(record)
    |> Enum.uniq()
    |> length()
  end

  @doc ~S"""
  Count the number of letters that appear in every answer in a record.

  ## Examples

      iex> AdventOfCode.Day06.count_unanimous_answers([["a", "b", "c"]])
      3

      iex> AdventOfCode.Day06.count_unanimous_answers([["a"], ["b"], ["c"]])
      0

      iex> AdventOfCode.Day06.count_unanimous_answers([["a", "b"], ["a", "c"]])
      1

  """
  def count_unanimous_answers(record) do
    Enum.map(record, &MapSet.new/1)
    |> Enum.reduce(&MapSet.intersection/2)
    |> MapSet.size()
  end

end
