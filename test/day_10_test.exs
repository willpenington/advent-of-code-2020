defmodule Day10Test do
  use ExUnit.Case, async: true

  doctest AdventOfCode.Day10

  alias AdventOfCode.Day10

  @example_input [
    28,
    33,
    18,
    42,
    31,
    14,
    46,
    20,
    48,
    47,
    24,
    23,
    49,
    45,
    19,
    38,
    39,
    11,
    1,
    32,
    25,
    35,
    8,
    17,
    7,
    9,
    4,
    2,
    34,
    10,
    3
  ]

  test "part 1 example" do
    assert AdventOfCode.Day10.part1(@example_input) == 220
  end

  test "part 2 example" do
    assert AdventOfCode.Day10.part2(@example_input) == 19208
  end
end
