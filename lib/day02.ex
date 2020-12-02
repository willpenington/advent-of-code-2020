defmodule AdventOfCode.Day02 do
  alias AdventOfCode.Util

  def process() do
    values = Util.load_input(["priv", "day02", "input"])
    |> Enum.to_list()

    part_1 = Enum.count(values, &password_matches_1(&1))
    part_2 = Enum.count(values, &password_matches_2(&1))

    IO.puts("Part 1: #{part_1}, Part 2: #{part_2}")
  end

  def extract_rule(value) do
    [counts, <<char, ": ", password::binary>>] = String.split(value, " ", parts: 2)
    [min_str, max_str] = String.split(counts, "-")

    min = String.to_integer(min_str)
    max = String.to_integer(max_str)

    {min, max, << char >>, password}
  end

  def password_matches_1(value) do
    {min, max, << char >>, password} = extract_rule(value)

    char_count = String.to_charlist(password)
    |> Enum.count(fn x -> x == char end)

    min <= char_count and char_count <= max
  end

  def password_matches_2(value) do
    {first, last, char, password} = extract_rule(value)

    first_matches = String.at(password, first - 1) == char
    last_matches = String.at(password, last - 1) == char

    (first_matches or last_matches) and not (first_matches and last_matches)
  end

end
