defmodule AdventOfCode.Day02 do
  @moduledoc """
  Advent of Code Day 2: Password Philosophy
  """

  alias AdventOfCode.Util

  defmodule Record do
    @moduledoc nil
    defstruct from: nil, to: nil, char: nil, password: ""
  end

  @type record() :: %Record{from: integer(), to: integer(), char: <<_::8>>, password: String.t()}

  @path ["priv", "day02", "input"]

  @doc ~S"""
  Calculate and print the answers to both parts of the question
  """
  @spec process() :: nil
  def process() do
    data = load_data()

    IO.puts("Part 1: #{part1(data)}, Part 2: #{part2(data)}")
  end

  @spec part1([record()]) :: integer()
  def part1(data) do
     Enum.count(data, &password_matches_by_count/1)
  end

  @spec part2([record()]) :: integer()
  def part2(data) do
    Enum.count(data, &password_matches_by_position/1)
  end

  @spec extract_record(String.t()) :: record()
  def extract_record(value) do
    [counts, <<char, ": ", password::binary>>] = String.split(value, " ", parts: 2)
    [min_str, max_str] = String.split(counts, "-")

    min = String.to_integer(min_str)
    max = String.to_integer(max_str)

    {min, max, <<char>>, password}
    %Record{from: min, to: max, char: <<char>>, password: password}
  end

  @spec password_matches_by_count(record()) :: boolean()
  def password_matches_by_count(%Record{from: min, to: max, char: <<char>>, password: password}) do
    char_count =
      String.to_charlist(password)
      |> Enum.count(fn x -> x == char end)

    min <= char_count and char_count <= max
  end

  @spec password_matches_by_position(record()) :: boolean()
  def password_matches_by_position(%Record{from: first, to: last, char: char, password: password}) do
    first_matches = String.at(password, first - 1) == char
    last_matches = String.at(password, last - 1) == char

    (first_matches or last_matches) and not (first_matches and last_matches)
  end

  @spec load_data() :: [record()]
  def load_data() do
    Util.load_line_delimited_input(@path)
    |> Stream.map(&extract_record/1)
  end
end
