defmodule Day08Test do
  use ExUnit.Case, async: true

  doctest AdventOfCode.Day08

  alias AdventOfCode.Day08

  @example_program [
    {:nop, 0},
    {:acc, 1},
    {:jmp, 4},
    {:acc, 3},
    {:jmp, -3},
    {:acc, -99},
    {:acc, 1},
    {:jmp, -4},
    {:acc, 6}
  ]

  test "part 1 example" do
    assert Day08.part1(@example_program) == 5
  end

  test "part 2 example" do
    assert Day08.part2(@example_program) == 8
  end

  test "parse instruction" do
    assert Day08.parse_line("jmp +12") == {:jmp, 12}
    assert Day08.parse_line("jmp -7") == {:jmp, -7}
    assert Day08.parse_line("acc +123") == {:acc, 123}
    assert Day08.parse_line("acc -32") == {:acc, -32}
    assert Day08.parse_line("nop +4") == {:nop, 4}
    assert Day08.parse_line("nop -534") == {:nop, -534}
  end
end
