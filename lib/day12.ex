defmodule AdventOfCode.Day12 do
  alias AdventOfCode.Util

  @daynumber 12

  @type action :: :north | :south | :east | :west | :left | :right | :forward
  @type instruction :: {action(), integer()}
  @type directions :: [instruction()]
  @type location :: {integer(), integer()}

  @spec process :: :ok
  def process() do
    directions = load_data()

    IO.puts("Part 1: #{part1(directions)}, Part 2: #{part2(directions)}")
  end

  @spec part1(directions()) :: integer()
  def part1(directions) do
    directions
    |> Enum.reduce({{0, 0}, 90}, &follow_instruction/2)
    |> strip_state()
    |> manhattan_distance()
  end

  @spec part2(directions()) :: integer()
  def part2(directions) do
    directions
    |> Enum.reduce({{0, 0}, {1, 10}}, &follow_waypoint_instruction/2)
    |> strip_state()
    |> manhattan_distance()
  end

  @spec follow_instruction(instruction(), {location(), integer()}) :: {location(), integer()}
  def follow_instruction(instruction, state)

  def follow_instruction({:north, value}, {{northing, easting}, heading}) do
    {{northing + value, easting}, heading}
  end

  def follow_instruction({:south, value}, {{northing, easting}, heading}) do
    {{northing - value, easting}, heading}
  end

  def follow_instruction({:east, value}, {{northing, easting}, heading}) do
    {{northing, easting + value}, heading}
  end

  def follow_instruction({:west, value}, {{northing, easting}, heading}) do
    {{northing, easting - value}, heading}
  end

  def follow_instruction({:left, value}, {location, heading}) do
    {location, rem(heading + 360 - value, 360)}
  end

  def follow_instruction({:right, value}, {location, heading}) do
    {location, rem(heading + value, 360)}
  end

  def follow_instruction({:forward, value}, {{northing, easting}, 0}) do
    {{northing + value, easting}, 0}
  end

  def follow_instruction({:forward, value}, {{northing, easting}, 90}) do
    {{northing, easting + value}, 90}
  end

  def follow_instruction({:forward, value}, {{northing, easting}, 180}) do
    {{northing - value, easting}, 180}
  end

  def follow_instruction({:forward, value}, {{northing, easting}, 270}) do
    {{northing, easting - value}, 270}
  end

  @spec rotate_waypoint(location(), number()) :: location()
  def rotate_waypoint(location, count)

  def rotate_waypoint({northing, easting}, n) when n == 0 do
    {northing, easting}
  end

  def rotate_waypoint({northing, easting}, n) when n > 0 do
    rotate_waypoint({easting, -1 * northing}, n - 1)
  end

  def rotate_waypoint({northing, easting}, n) when n < 0 do
    rotate_waypoint({-1 * easting, northing}, n + 1)
  end

  @spec follow_waypoint_instruction(instruction(), {location(), location()}) ::
          {location(), location()}
  def follow_waypoint_instruction(instruction, locations)

  def follow_waypoint_instruction({:north, value}, {ship_loc, {northing, easting}}) do
    {ship_loc, {northing + value, easting}}
  end

  def follow_waypoint_instruction({:east, value}, {ship_loc, {northing, easting}}) do
    {ship_loc, {northing, easting + value}}
  end

  def follow_waypoint_instruction({:south, value}, {ship_loc, {northing, easting}}) do
    {ship_loc, {northing - value, easting}}
  end

  def follow_waypoint_instruction({:west, value}, {ship_loc, {northing, easting}}) do
    {ship_loc, {northing, easting - value}}
  end

  def follow_waypoint_instruction({:left, value}, {ship_loc, waypoint_loc}) do
    {ship_loc, rotate_waypoint(waypoint_loc, value / 90)}
  end

  def follow_waypoint_instruction({:right, value}, {ship_loc, waypoint_loc}) do
    {ship_loc, rotate_waypoint(waypoint_loc, -1 * (value / 90))}
  end

  def follow_waypoint_instruction(
        {:forward, value},
        {{ship_northing, ship_easting}, {wp_northing, wp_easting}}
      ) do
    {{ship_northing + value * wp_northing, ship_easting + value * wp_easting},
     {wp_northing, wp_easting}}
  end

  @spec strip_state({location(), any()}) :: location()
  def strip_state({location, _heading}) do
    location
  end

  @spec manhattan_distance(location()) :: integer()
  def manhattan_distance({northing, easting}) do
    abs(northing) + abs(easting)
  end

  @spec parse_instruction(String.t()) :: instruction()
  def parse_instruction(<<code::size(8), value::binary()>>) do
    value = String.to_integer(value)

    code =
      case <<code>> do
        "N" -> :north
        "S" -> :south
        "E" -> :east
        "W" -> :west
        "L" -> :left
        "R" -> :right
        "F" -> :forward
      end

    {code, value}
  end

  @spec load_data() :: directions()
  def load_data() do
    Util.find_input(@daynumber)
    |> Util.load_line_delimited_input()
    |> Enum.map(&parse_instruction/1)
  end
end
