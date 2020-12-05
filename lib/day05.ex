defmodule AdventOfCode.Day05 do

  alias AdventOfCode.Util

  def process() do
    seat_ids = Util.load_input(["priv", "day05", "input"])
    |> Enum.map(&parse_boarding_pass/1)
    |> Enum.map(&get_seat_id/1)
    |> Enum.to_list()

    max_seat_id = Enum.max(seat_ids)

    IO.puts("Maximum Seat ID: #{max_seat_id}")

    IO.puts("My Seat ID: #{find_missing(seat_ids)}")
  end

  def parse_value(value, true_char, false_char) do
    {result, ""} =  String.replace(value, true_char, "1")
    |> String.replace(false_char, "0")
    |> Integer.parse(2)
    result
  end

  def parse_boarding_pass(<<row::binary-size(7), column::binary-size(3)>>) do
    {parse_value(row, "B", "F"), parse_value(column, "R", "L")}
  end

  def get_seat_id({row, column}), do: row * 8 + column

  defp find_missing_helper([first, second | _]) when first == second - 2 do
    first + 1
  end
  defp find_missing_helper([_ | tail]), do: find_missing(tail)
  defp find_missing_helper([]), do: nil

  def find_missing(seat_ids) do
    Enum.sort(seat_ids)
    |> find_missing_helper()
  end


end
