
defmodule Day12Test do
  use ExUnit.Case, async: true
  doctest AdventOfCode.Day12

  alias AdventOfCode.Day12

  test "rotating points clockwise" do
    Day12.rotate_waypoint({1, 1}, 0) == {1, 1}
    Day12.rotate_waypoint({1, 1}, 1) == {-1, 1}
    Day12.rotate_waypoint({1, 1}, 2) == {-1, -1}
    Day12.rotate_waypoint({1, 1}, 3) == {1, -1}
    Day12.rotate_waypoint({1, 1}, 4) == {1, 1}
  end

  test "rotating points anti-clockwise" do
    Day12.rotate_waypoint({1, 1}, 0) == {1, 1}
    Day12.rotate_waypoint({1, 1}, -1) == {1, -1}
    Day12.rotate_waypoint({1, 1}, 2) == {-1, -1}
    Day12.rotate_waypoint({1, 1}, 3) == {-1, 1}
    Day12.rotate_waypoint({1, 1}, 4) == {1, 1}
  end


end
