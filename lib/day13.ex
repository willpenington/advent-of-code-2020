defmodule AdventOfCode.Day13 do

  alias AdventOfCode.Util

  @day_number 13

  def process() do
    notes = load_data()

    IO.puts("Part 1: #{part1(notes)}, Part 2: #{part2(notes)}")
  end

  def find_first_multiple_gte_helper(value, target, n) do
    product = value * n
    if product >= target do
      {product, n}
    else
      find_first_multiple_gte_helper(value, target, n + 1)
    end
  end

  def find_first_multiple_gte(value, target) do
    find_first_multiple_gte_helper(value, target, 1)
  end

  def part1({time, buses}) do
    IO.inspect(time, label: "time")

    {bus_id, bus_time} = filter_timetable(buses)
    |> IO.inspect(label: "buses")
    |> Enum.map(fn bus_id ->
      {bus_time, _} = find_first_multiple_gte(bus_id, time)
      {bus_id, bus_time}
    end)
    |> Enum.min_by(fn {_, bus_time} -> bus_time end)
    |> IO.inspect(label: "buses")

    wait = bus_time - time

    bus_id * wait
  end

  def time_matches(time, buses) do
    Enum.all?(buses, fn {bus_id, index} ->
      rem(time + index, bus_id) == 0
    end)
  end

  def get_generator(buses) do
    [{bus_id, index} | sorted_buses] = Enum.sort_by(buses, fn {bus_id, _} -> bus_id end, &>=/2)
    |> IO.inspect()

    base_stream = Stream.iterate(-1 * index, &(&1 + bus_id))

    Enum.take(sorted_buses, 3)
    |> Enum.reduce(base_stream, fn {bus_id, index}, generator ->
      Stream.filter(generator, fn x ->
        rem(x + index, bus_id) == 0
      end)
    end)
  end

  def part2({_, buses}) do
    indexed_buses = Enum.with_index(buses)
    |> Enum.filter(fn
      {:out_of_service, _} -> false
      _ -> true
    end)

    # This is a very dumb way of getting the answer and it takes a very long time to run
    # I am aware that there is a correct way of solving this using linear equations but
    # when I started implementing it it felt too much like maths homework so I decided to
    # just leave my computer to brute force it while I enjoyed the weekend.
    get_generator(indexed_buses)
    |> Stream.filter(&time_matches(&1, indexed_buses))
    |> Enum.take(1)
    |> List.first()
  end

  def filter_timetable(buses) do
    Enum.filter(buses, fn
      :out_of_service -> false
      _ -> true
    end)
  end

  def parse_timetable(buses) do
    String.split(buses, ",")
    |> Enum.map(fn
      "x" -> :out_of_service
      time -> String.to_integer(time)
    end)
  end

  def load_data() do
    [time, buses] = Util.find_input(@day_number)
    |> Util.load_line_delimited_input()

    {String.to_integer(time), parse_timetable(buses)}
  end

end
