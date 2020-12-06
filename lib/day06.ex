defmodule AdventOfCode.Day06 do

  @path ["priv", "day06", "input"]

  def process() do
    IO.puts("Part 1: #{part1()}, Part 2: #{part2()}")
  end

  def part1() do
    load_data(@path)
    |> Enum.map(&parse_record/1)
    |> Enum.map(&count_unique_answers/1)
    |> Enum.sum()
  end

  def part2() do
    load_data(@path)
    |> Enum.map(&parse_record/1)
    |> Enum.map(&count_unanimous_answers/1)
    |> Enum.sum()
  end

  def load_data(path) do
    Path.join(path)
    |> File.read!
    |> String.split("\n\n")
  end

  def parse_record(val) do
    String.split(val)
    |> Enum.map(&String.codepoints/1)
  end

  def count_unique_answers(record) do
    List.flatten(record)
    |> Enum.uniq()
    |> length()
  end

  def count_unanimous_answers(record) do
    Enum.map(record, &MapSet.new/1)
    |> Enum.reduce(&MapSet.intersection/2)
    |> MapSet.size()
  end

end
