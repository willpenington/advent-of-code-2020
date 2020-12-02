defmodule AdventOfCode.Day01 do
  alias AdventOfCode.Util

  def process() do
    values = load_values(["priv", "day01", "input"])

    IO.puts("Part 1: #{part1(values, 2020)}, Part 2: #{part2(values, 2020)}")
  end

  def load_values(path) do
    Util.load_input(path)
    |> Enum.map(&String.to_integer(&1))
    |> Enum.to_list()
  end

  def part1(values, target) do
    (for x <- values, y <- values, x + y == target, do: x * y)
    |> List.first
  end

  def part2(values, target) do
    (for x <- values, y <- values, z <- values, x + y + z == target, do: x * y * z)
    |> List.first
  end
end
