defmodule Day18Test do
  use ExUnit.Case, async: true
  doctest AdventOfCode.Day18

  alias AdventOfCode.Day18
  import AdventOfCode.Day18.Sigil

  describe "parsing" do

    test "parse a simple expression" do
      assert Day18.parse_equation("3 * 9 + 2") == [3, "*", 9, "+", 2]
    end

  end

  describe "calculating with simple precedence" do

    test "calculate simple expressions" do
      assert Day18.calculate_simple([3, "+", 7, "*", 5]) == 50
    end

    test "calculate complex expression" do
      assert Day18.calculate_simple([3, "+", [4, "+", 3], "*", 5]) == 50
    end

  end

  describe "calculating with advanced order of precedence" do
    test "calculate examples" do
      assert Day18.calculate_advanced([1, "+", 2, "*", 3, "+", 4, "*", 5, "+", 6]) == 231
      assert Day18.calculate_advanced(~e"1 + (2 * 3) + (4 * (5 + 6))") == 51
      assert Day18.calculate_advanced(~e"2 * 3 + (4 * 5)") == 46
      assert Day18.calculate_advanced(~e"5 + (8 * 3 + 9 + 3 * 4 * 3)") == 1445
      assert Day18.calculate_advanced(~e"5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))") == 669060
      assert Day18.calculate_advanced(~e"((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2") == 23340
    end

  end


end
