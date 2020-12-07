defmodule AdventOfCode.Day02 do
  alias AdventOfCode.Util

  defmodule Record do
    defstruct from: nil, to: nil, char: nil, password: ""
  end

  @path ["priv", "day02", "input"]

  def process() do
    part_1 = part1()
    part_2 = part2()

    IO.puts("Part 1: #{part_1}, Part 2: #{part_2}")
  end

  def part1() do
    Util.load_line_delimited_input(@path)
    |> Stream.map(&extract_record/1)
    |> Enum.count(&password_matches_by_count/1)
  end

  def part2() do
    Util.load_line_delimited_input(@path)
    |> Stream.map(&extract_record/1)
    |> Enum.count(&password_matches_by_position/1)
  end

  def extract_record(value) do
    [counts, <<char, ": ", password::binary>>] = String.split(value, " ", parts: 2)
    [min_str, max_str] = String.split(counts, "-")

    min = String.to_integer(min_str)
    max = String.to_integer(max_str)

    {min, max, << char >>, password}
    %Record{from: min, to: max, char: <<char>>, password: password}
  end

  def password_matches_by_count(%Record{from: min, to: max, char: <<char>>, password: password}) do
    char_count = String.to_charlist(password)
    |> Enum.count(fn x -> x == char end)

    min <= char_count and char_count <= max
  end

  def password_matches_by_position(%Record{from: first, to: last, char: char, password: password}) do
    first_matches = String.at(password, first - 1) == char
    last_matches = String.at(password, last - 1) == char

    (first_matches or last_matches) and not (first_matches and last_matches)
  end

end
