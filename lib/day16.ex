defmodule AdventOfCode.Day16 do
  alias AdventOfCode.Util

  @day_number 16

  def process() do
    notes = load_data()

    IO.puts("Part 1: #{part1(notes)}, Part 2: #{part2(notes)}")
  end

  def ranges(rules) do
    Enum.flat_map(rules, fn {_, range1, range2} -> [range1, range2] end)
  end

  def part1({rules, _, nearby}) do
    rule_ranges = ranges(rules)

    List.flatten(nearby)
    |> Enum.filter(fn x ->
      not Enum.any?(rule_ranges, fn range ->
        x in range
      end)
    end)
    |> Enum.sum()
  end

  def valid_for_rule(val, {_, range1, range2}) do
    in_range_1 = val in range1
    in_range_2 = val in range2

    in_range_1 or in_range_2
  end

  def is_valid(ticket, rules) do
    Enum.all?(ticket, fn value ->
      Enum.any?(rules, &valid_for_rule(value, &1))
    end)
  end

  def part2({rules, ticket, nearby}) do
    possible_labels =
      Enum.filter(nearby, &is_valid(&1, rules))
      |> Enum.map(fn nearby_ticket ->
        Enum.map(nearby_ticket, fn value ->
          Enum.filter(rules, &valid_for_rule(value, &1))
          |> Enum.map(fn {name, _, _} -> name end)
        end)
      end)

    Enum.with_index(ticket)
    |> Enum.map(fn {ticket_val, col_index} ->
      [first_result | col_vals] = Enum.map(possible_labels, &Enum.at(&1, col_index))

      labels =
        Enum.filter(first_result, fn label ->
          Enum.all?(col_vals, &(label in &1))
        end)

      {ticket_val, labels}
    end)
    |> Enum.sort_by(fn {_, labels} -> length(labels) end)
    |> Enum.reduce(%{}, fn {ticket_value, labels}, acc ->
      label = Enum.find(labels, fn label -> not Map.has_key?(acc, label) end)
      Map.put(acc, label, ticket_value)
    end)
    |> Enum.filter(fn {label, _} -> String.starts_with?(label, "departure ") end)
    |> Enum.map(fn {_, value} -> value end)
    |> Enum.reduce(&*/2)
  end

  def parse_rules(rules) do
    String.split(rules, "\n")
    |> Enum.map(fn rule ->
      [_, name, from1, to1, from2, to2] =
        Regex.run(~r/^([a-z ]+): ([0-9]+)-([0-9]+) or ([0-9]+)-([0-9]+)/, rule)

      {
        name,
        Range.new(String.to_integer(from1), String.to_integer(to1)),
        Range.new(String.to_integer(from2), String.to_integer(to2))
      }
    end)
  end

  def parse_ticket(ticket) do
    [_, ticket_line] = String.split(ticket, "\n")

    String.split(ticket_line, ",")
    |> Enum.map(&String.to_integer/1)
  end

  def parse_nearby(nearby) do
    String.trim(nearby)
    |> String.split("\n")
    |> Enum.drop(1)
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn v ->
      Enum.map(v, &String.to_integer/1)
    end)
  end

  def load_data() do
    [rules, ticket, nearby | _] =
      Util.find_input(@day_number)
      |> Util.load_blank_line_delimited_input()

    {parse_rules(rules), parse_ticket(ticket), parse_nearby(nearby)}
  end
end
