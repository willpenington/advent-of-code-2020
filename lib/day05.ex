defmodule AdventOfCode.Day05 do

  alias AdventOfCode.Util

  @doc ~S"""
  Run the Advent of Code tasks for Day 5
  """
  def process() do
    seat_ids = Util.load_line_delimited_input(["priv", "day05", "input"])
    |> Enum.map(&parse_boarding_pass/1)
    |> Enum.map(&get_seat_id/1)
    |> Enum.to_list()

    IO.puts("Maximum Seat ID: #{Enum.max(seat_ids)}")
    IO.puts("My Seat ID: #{find_missing(seat_ids)}")
  end

  @doc ~S"""
  Parse a binary number encoded with non-standard characters.

  ## Examples

      iex> AdventOfCode.Day05.parse_value("FBFBBFF", "B", "F")
      44
  """
  def parse_value(value, true_char, false_char) do
    {result, ""} =  String.replace(value, true_char, "1")
    |> String.replace(false_char, "0")
    |> Integer.parse(2)
    result
  end

  @doc ~S"""
  Parse a Binary Boarding Pass

  Parse a binary boarding pass into a row and column value. Binary boarding
  passes are encoded as a 7 digit row number encoded with "B" and "F" as 1 and
  0 respectively and a 3 digit column number encoded with "R" and "L" as 1 and
  0. The result is returned as a tuple of row and column numbers as integers
  (i.e. {row, column}).

  ## Examples

      iex> AdventOfCode.Day05.parse_boarding_pass("FBFBBFFRLR")
      {44, 5}

  """
  def parse_boarding_pass(<<row::binary-size(7), column::binary-size(3)>>) do
    {parse_value(row, "B", "F"), parse_value(column, "R", "L")}
  end

  @doc ~S"""
  Calculate the ID for a seat

  ## Examples

      iex> AdventOfCode.Day05.get_seat_id({44, 5})
      357

  """
  def get_seat_id({row, column}), do: row * 8 + column

  defp find_missing_helper([first, second | _]) when first == second - 2 do
    first + 1
  end
  defp find_missing_helper([_ | tail]), do: find_missing(tail)
  defp find_missing_helper([]), do: nil

  @doc ~S"""
  Find a number missing in a list.

  Finds the (first) missing number in a list of integers. If there aren't any
  numbers missing between the lowest and highest number it returns nil.

  ## Examples

      iex> AdventOfCode.Day05.find_missing([5, 8, 7, 12, 6, 11, 10])
      9

      iex> AdventOfCode.Day05.find_missing([5, 8, 7, 12, 6, 10])
      9

      iex> AdventOfCode.Day05.find_missing([5, 8, 7, 12, 9, 6, 11, 10])
      nil

  """
  def find_missing(seat_ids) do
    Enum.sort(seat_ids)
    |> find_missing_helper()
  end

end
