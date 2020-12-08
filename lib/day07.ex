defmodule AdventOfCode.Day07 do
  @moduledoc ~S"""
  Advent of Code Day 7: Nesting bags

  Uses a set of rules to determine what a given type of bag can contain or is contained by.

  A type a of bag is defined by an adjective and a colour. Some types of bag contain other bags
  according to rules that describe the quantity of each type.

  The rules are described in natural language sentances that follow a set format.
  """

  alias AdventOfCode.Util

  @day_number 7

  @doc ~S"""
  Calculate and print the answers to both parts of the question
  """
  def process() do
    IO.puts("Part 1: #{part1()}, Part 2: #{part2()}")
  end

  @doc ~S"""
  Calculate the number of bags that could contain a shiny gold bag, either directly or indirectly
  """
  def part1() do
    load_data()
    |> Enum.map(&invert_rule/1)
    |> List.flatten()
    |> Enum.group_by(fn {name, _} -> name end, fn {_, val} -> val end)
    |> find_containing({"shiny", "gold"})
    |> Enum.count()
  end

  @doc ~S"""
  Calculate the total number of bags that can be contained inside a shiny gold bag
  """
  def part2() do
    load_data()
    |> Map.new()
    |> count_contained({"shiny", "gold"})
  end

  defp invert_rule({name, rules}) do
    Enum.map(rules, fn {_, adjective, colour} ->
      {{adjective, colour}, name}
    end)
  end

  defp find_containing_helper(rules, name, seen) do
    new_bags = Map.get(rules, name, [])
    |> Enum.filter(fn x -> x not in seen end)

    case new_bags do
      [] -> MapSet.new(new_bags)
      val ->
        #seen = MapSet.union(seen, new_bags)
        Enum.reduce(val, seen, fn bag, new_seen ->
          new_seen = MapSet.put(new_seen, bag)
          find_containing_helper(rules, bag, new_seen)
          |> MapSet.union(new_seen)
        end)
    end
  end

  @doc ~S"""
  List all of the types of bag that can contain the specified type
  """
  def find_containing(rules, name) do
    find_containing_helper(rules, name, MapSet.new())
  end

  @doc ~S"""
  Get the total number of bags that a given type of bag contains
  """
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

  def parse_type(name) do
    %{"adjective" => adjective, "colour" => colour} = Regex.named_captures(~r/^(?<adjective>[a-z]+) (?<colour>[a-z]+)/, name)
    {adjective, colour}
  end

  def parse_contents("no other bags.") do
    []
  end

  def parse_contents(contents) do
    String.split(contents, ", ")
    |> Enum.map(fn val ->
      %{"count" => count, "adjective" => adjective, "colour" => colour} = Regex.named_captures(~r/^(?<count>[0-9]+) (?<adjective>[a-z]+) (?<colour>[a-z]+)/, val)
      {String.to_integer(count), adjective, colour}
    end)
  end

  def parse_rule(rule) do
    [bag, contents] = String.split(rule, " contain ")
    {parse_type(bag), parse_contents(contents)}
  end

end
