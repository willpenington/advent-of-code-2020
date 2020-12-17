defmodule AdventOfCode.Day17 do
  alias AdventOfCode.Util

  @day_number 17

  @type world :: [{integer(), integer(), integer(), integer()}]

  def process() do
    data = load_data()

    IO.puts("Part 1: #{part1(data)}, Part 2: #{part2(data)}")
  end

  def neighbours(x, y, z, w, 3) do
    for i <- -1..1, j <- -1..1, k <- -1..1, {i, j, k} != {0, 0, 0} do
      {x + i, y + j, z + k, w}
    end
  end

  def neighbours(x, y, z, w, 4) do
    for i <- -1..1, j <- -1..1, k <- -1..1, l <- -1..1, {i, j, k, l} != {0, 0, 0, 0} do
      {x + i, y + j, z + k, w + l}
    end
  end


  defp step(world, _, step_count, step_count), do: world
  defp step(world, dimensions, step_count, step_number) do
    # Converting the state of the world into a set makes for a more than order
    # of magnitude speedup because of all the lookups
    world = MapSet.new(world)

    Enum.flat_map(world, fn {x, y, z, w} ->
      [{x, y, z, w} | neighbours(x, y, z, w, dimensions)]
    end)
    |> Enum.uniq()
    |> Enum.filter(fn {x, y, z, w} ->
      active = neighbours(x, y, z, w, dimensions)
      |> Enum.count(&(&1 in world))

      active == 3 or (active == 2 and {x, y, z, w} in world)
    end)
    |> step(dimensions, step_count, step_number + 1)

  end

  def run(world, dimensions, step_count) do
    step(world, dimensions, step_count, 0)
  end

  def part1(world) do
    run(world, 3, 6)
    |> Enum.count()
  end

  def part2(world) do
    run(world, 4, 6)
    |> Enum.count()
  end

  @spec parse_line({String.t(), integer}) :: [{integer(), integer(), integer()}]
  defp parse_line({line, y}) do
    String.trim(line)
    |> String.codepoints()
    |> Enum.with_index()
    |> Enum.filter(fn {val, _} -> val == "#" end)
    |> Enum.map(fn {_, x} -> {x, y, 0, 0} end)
  end

  @spec load_data() :: world()
  def load_data() do
    Util.find_input(@day_number)
    |> Util.load_line_delimited_input()
    |> Enum.with_index()
    |> Enum.flat_map(&parse_line/1)
  end
end
