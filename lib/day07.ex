defmodule AdventOfCode.Day07 do
  alias AdventOfCode.Util

  @day_number 7

  def process() do
    IO.puts("Part 1: #{part1()}, Part 2: #{part2()}")
  end

  def part1() do
    load_data()
    |> Enum.map(&invert_rule/1)
    |> List.flatten()
    |> Enum.group_by(fn {name, _} -> name end, fn {_, val} -> val end)
    |> find_containing({"shiny", "gold"})
    |> Enum.count()
    |> IO.inspect()
  end

  def part2() do
    load_data()
    |> Map.new()
    |> count_contained({"shiny", "gold"})
    |> IO.inspect()
  end

  defp invert_rule({name, rules}) do
    Enum.map(rules, fn {_, adjective, colour} ->
      {{adjective, colour}, name}
    end)
  end

  def get_containing_bags(rules, name) do
    case rules[name] do
      nil -> []
      val -> val
    end
  end

  defp find_containing_helper(rules, name, seen) do
    new_bags =
      get_containing_bags(rules, name)
      |> Enum.filter(fn x -> x not in seen end)

    case new_bags do
      [] ->
        MapSet.new(new_bags)

      val ->
        # seen = MapSet.union(seen, new_bags)
        Enum.reduce(val, seen, fn bag, new_seen ->
          new_seen = MapSet.put(new_seen, bag)

          find_containing_helper(rules, bag, new_seen)
          |> MapSet.union(new_seen)
        end)
    end
  end

  def find_containing(rules, name) do
    find_containing_helper(rules, name, MapSet.new())
  end

  def count_contained(rules, name) do
    Map.get(rules, name)
    |> Enum.map(fn {count, adjective, colour} ->
      count * (count_contained(rules, {adjective, colour}) + 1)
    end)
    |> Enum.sum()
  end

  def load_data() do
    Util.find_input(@day_number)
    |> Util.load_line_delimited_input()
    |> Enum.map(&parse_rule/1)
  end

  def parse_colour(name) do
    %{"adjective" => adjective, "colour" => colour} =
      Regex.named_captures(~r/^(?<adjective>[a-z]+) (?<colour>[a-z]+)/, name)

    {adjective, colour}
  end

  def parse_contents("no other bags.") do
    []
  end

  def parse_contents(contents) do
    String.split(contents, ", ")
    |> Enum.map(fn val ->
      %{"count" => count, "adjective" => adjective, "colour" => colour} =
        Regex.named_captures(~r/^(?<count>[0-9]+) (?<adjective>[a-z]+) (?<colour>[a-z]+)/, val)

      {String.to_integer(count), adjective, colour}
    end)
  end

  def parse_rule(rule) do
    [bag, contents] = String.split(rule, " contain ")
    {parse_colour(bag), parse_contents(contents)}
  end
end
