defmodule AdventOfCode.Day03 do
  alias AdventOfCode.Util

  @routes [
    {1, 1},
    {3, 1},
    {5, 1},
    {7, 1},
    {1, 2}
  ]

  def process() do
    map = Util.load_input(["priv", "day03", "input"])
    |> Stream.map(&parse_row/1)
    |> Enum.to_list()

    totals = for {right, down} <- @routes do
      total = calculate_route(map, right, down)
      IO.puts("Right: #{right}, Down: #{down}, Total: #{total}")
      total
    end

    {_, grand_total} = Enum.map_reduce(totals, 1, fn x, acc -> {x * acc, x * acc} end)

    IO.puts("Grand Total #{grand_total}")
  end

  def parse_symbol('.'), do: :open
  def parse_symbol('#'), do: :tree

  def parse_row(row) do
    String.to_charlist(row)
    |> Enum.map(&parse_symbol([&1]))
  end

  def lookup_pos(row, offset) do
    Enum.at(row, rem(offset, length(row)))
  end

  def calculate_route(map, right, down) do
    acc = fn row, {offset, total} ->
      total = case lookup_pos(row, offset) do
        :open -> total
        :tree -> total + 1
      end
      {total, {offset + right, total}}
    end


    {_, {_, total}} = Enum.take_every(map, down)
    |> Enum.map_reduce({0, 0}, acc)

    total
  end

end
