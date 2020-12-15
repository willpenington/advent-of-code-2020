defmodule Day15Test do
  use ExUnit.Case, async: true
  doctest AdventOfCode.Day15

  alias AdventOfCode.Day15

  @examples [
    {[1, 3, 2], 2020, 1},
    {[2, 1, 3], 2020, 10},
    {[1, 2, 3], 2020, 27},
    {[2, 3, 1], 2020, 78},
    {[3, 2, 1], 2020, 438},
    {[3, 1, 2], 2020, 1836}
  ]

  test "example inputs" do
    for {input, turn_count, result} <- @examples do
      assert Day15.play(input, turn_count) == result
    end
  end

end
