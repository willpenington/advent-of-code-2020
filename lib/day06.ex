defmodule AdventOfCode.Day06 do
  @moduledoc ~S"""
  Advent of Code Day 6: Counting Answers

  Processes answers recorded in the form of letters in groups to calculate
  the total number of unique and unanimous answers across the input.
  """

  alias AdventOfCode.Util

  @day_number 6

  @type record() :: [[<<_::8>>]]

  @doc ~S"""
  Calculate and print the answers to both parts of the question
  """
  def process() do
    records = load_data()
    IO.puts("Part 1: #{part1(records)}, Part 2: #{part2(records)}")
  end

  @doc ~S"""
  Calculate the sum of the number of unique letters that appear in each group's answers
  """
  @spec part1([record()]) :: integer()
  def part1(records) do
    records
    |> Enum.map(&count_unique_answers/1)
    |> Enum.sum()
  end

  @doc ~S"""
  Calculate the sum of the number of letters that appear in all of a groups answers
  """
  @spec part2([record()]) :: integer()
  def part2(records) do
    records
    |> Enum.map(&count_unanimous_answers/1)
    |> Enum.sum()
  end

  @doc ~S"""
  Load and parse the input file
  """
  @spec load_data() :: [record()]
  def load_data() do
    Util.find_input(@day_number)
    |> Util.load_blank_line_delimited_input()
    |> Enum.map(&parse_record/1)
  end

  @doc ~S"""
  Parse a string record into Elixir terms
  """
  @spec parse_record(String.t()) :: record()
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
  @spec count_unique_answers(record()) :: integer()
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
  @spec count_unanimous_answers(record()) :: integer()
  def count_unanimous_answers(record) do
    Enum.map(record, &MapSet.new/1)
    |> Enum.reduce(&MapSet.intersection/2)
    |> MapSet.size()
  end
end
