defmodule AdventOfCode.Day19 do

  alias AdventOfCode.Util

  @day_numer 19

  def process() do
    data = load_data()
    IO.puts("Part 1: #{part1(data)}, Part 2: #{part2(data)}")
  end

  def build_regex_helper(rule_number, rules) do
    rule = rules[rule_number]

    case rule do
      {:literal, x} -> x
      {:compound, [[x], [x, ^rule_number]]} ->
        IO.puts("Repeating rule")
        "(" <> build_regex_helper(x, rules) <> ")+"
      {:compound, [[x, y], [x, ^rule_number, y]]} ->
        expr_left = build_regex_helper(x, rules)
        expr_right = build_regex_helper(y, rules)
        # Hooray for PCREs not actually being Regular Expressions!
        # http://erlang.org/doc/man/re.html#recursive-patterns
        "(?<rec>" <> expr_left <> "(?&rec)*" <> expr_right <> ")"
      {:compound, [single_list]} ->
        Enum.map(single_list, fn inner_rule_number ->
          build_regex_helper(inner_rule_number, rules)
        end)
        |> Enum.join()
      {:compound, multiple_list} ->
        body = Enum.map(multiple_list, fn inner_rule ->
          Enum.map(inner_rule, &build_regex_helper(&1, rules))
          |> Enum.join()
        end)
        |> Enum.join("|")
        "(" <> body <> ")"
    end
  end

  def compile_to_regex(rule_number, rules) do
    ("^" <> build_regex_helper(rule_number, rules) <> "$")
    |> Regex.compile!()
  end

  def part1({rules, messages}) do
    regex = compile_to_regex(0, rules)
    Enum.count(messages, fn message -> message =~ regex end)
  end

  def part2({rules, messages}) do
    rules = Map.put(rules, 8, {:compound, [[42], [42, 8]]})
    |> Map.put(11, {:compound, [[42, 31], [42, 11, 31]]})

    regex = compile_to_regex(0, rules)
    Enum.count(messages, fn message -> message =~ regex end)
  end

  def parse_rule(line) do
    [rule_number, body] = String.split(line, ":")

    rule_number = String.to_integer(rule_number)

    body = String.trim(body)

    rule = if String.starts_with?(body, "\"") do
      <<"\"", x, "\"">> = body
      {:literal, <<x>>}
    else
        x = String.split(body, "|")
        |> Enum.map(&String.split/1)
        |> Enum.map(fn values ->
          Enum.map(values, &String.to_integer/1)
        end)
        {:compound, x}
    end

    {rule_number, rule}
  end

  def load_data() do
    [raw_rules, raw_messages] = Util.find_input(@day_numer)
    |> Util.load_blank_line_delimited_input()

    rules = String.split(raw_rules, "\n")
    |> Enum.map(&parse_rule/1)
    |> Map.new()

    messages = String.split(raw_messages, "\n")

    {rules, messages}
  end

end
