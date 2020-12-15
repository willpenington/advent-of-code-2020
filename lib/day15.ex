defmodule AdventOfCode.Day15 do
  @moduledoc """
  Advent of Code Day 15: Rambunctious Recitation

  Implement the rules of a memory game.

  Each turn depends on the number spoken during the previous turn. If
  it was the first time the number has been spoken, the player says 0.
  If it has been spoken before the player says the number of turns between
  the last time it was spoken and the previous turn.
  """

  @input [2, 1, 10, 11, 0, 6]

  @doc ~S"""
  Calculate and print the answers to both parts of the question
  """
  @spec process :: :ok
  def process() do
    IO.puts("Part 1: #{part1(@input)}, Part 2: #{part2(@input)}")
  end

  # First arguments are in a tupple to make piping easier
  @spec play_helper({integer(), %{integer() => integer()}}, integer(), integer()) :: integer()
  defp play_helper({number, _}, turn_count, turn_count), do: number
  defp play_helper({number, values}, turn, turn_count) do
    Map.get_and_update(values, number, fn
      nil -> {0, turn}
      last_seen -> {turn - last_seen, turn}
    end)
    |> play_helper(turn + 1, turn_count)
  end

  defp play_prelude(_, [number | _], turn_count, turn_count), do: number
  defp play_prelude(values, [number], turn, turn_count) do
    play_helper({number, values}, turn, turn_count)
  end
  defp play_prelude(values, [number | tail], turn, turn_count) do
    Map.put(values, number, turn)
    |> play_prelude(tail, turn + 1, turn_count)
  end

  @moduledoc ~S"""
  Run the memory game for `turn_count` turns.

  The initial numbers are provided as `input` and the game will be run until the
  turn number reaches `turn_count`. The return value is the last number spoken.

  ## Examples

      iex> AdventOfCode.Day15.play([0,3,6], 9)
      4

      iex> AdventOfCode.Day15.play([0,3,6], 10)
      0
  """
  @spec play([integer()], integer()) :: integer()
  def play(input, turn_count) do
    play_prelude(Map.new(), input, 1, turn_count)
  end

  @doc """
  Calculate the 2020th number spoken
  """
  @spec part1([integer]) :: integer
  def part1(input) do
    play(input, 2020)
  end

  @doc """
  Calculate the 30000000th number spoken
  """
  @spec part2([integer]) :: integer
  def part2(input) do
    play(input, 30000000)
  end

end
