defmodule AdventOfCode.Day11 do
  alias AdventOfCode.Util

  @day_number 11

  @type chair() :: :floor | :empty | :occupied
  @type chair_map() :: [[chair()]]

  defmodule Chair do
    use Agent

    @directions for v <- -1..1, h <- -1..1, {h, v} != {0, 0}, do: {h, v}

    def start_link(location, state, map_size, map_id) do
      Agent.start_link(fn -> {location, [state], map_size, map_id} end,
        name: {:global, {__MODULE__, map_id, location}}
      )
    end

    def get_state(chair, step \\ :latest)

    def get_state(location, step) do
      case location do
        {map_id, {x, y}} when is_integer(x) and is_integer(y) ->
          {:global, {__MODULE__, map_id, {x, y}}}

        val ->
          val
      end
      |> Agent.get(fn {_, history, _, _} ->
        case step do
          :latest ->
            Enum.at(history, 0)

          _ ->
            Enum.reverse(history)
            |> Enum.at(step)
        end
      end)
    end

    def get_location(pid) do
      Agent.get(pid, fn {location, _, _, _} -> location end)
    end

    defp get_neighbour(map_id, location, size, step_no)
    defp get_neighbour(_, {-1, _}, _, _), do: :undefined
    defp get_neighbour(_, {_, -1}, _, _), do: :undefined
    defp get_neighbour(_, {x, _}, {x, _}, _), do: :undefined
    defp get_neighbour(_, {_, y}, {_, y}, _), do: :undefined
    defp get_neighbour(map_id, {x, y}, _size, step_no), do: get_state({map_id, {x, y}}, step_no)

    defp walk_to_seat(map_id, {x, y}, {h, v}, size, step_no) do
      case get_neighbour(map_id, {x + h, y + v}, size, step_no) do
        :floor -> walk_to_seat(map_id, {x + h, y + v}, {h, v}, size, step_no)
        :undefined -> :undefined
        :empty -> :empty
        :occupied -> :occupied
      end
    end

    defp calculate_state(_, :floor, _), do: :floor

    defp calculate_state(surrounding, :empty, _) do
      if :occupied in surrounding do
        :empty
      else
        :occupied
      end
    end

    defp calculate_state(surrounding, :occupied, occupied_threshold) do
      if Enum.count(surrounding, fn x -> x == :occupied end) >= occupied_threshold do
        :empty
      else
        :occupied
      end
    end

    def step_immidiate(pid) do
      Agent.get_and_update(pid, fn {{x, y}, [state | _] = history, {width, height}, map_id} ->
        step_no = length(history)

        new_state =
          for {h, v} <- @directions do
            get_neighbour(map_id, {x + v, y + h}, {width, height}, step_no - 1)
          end
          |> calculate_state(state, 4)

        {{state, new_state}, {{x, y}, [new_state | history], {width, height}, map_id}}
      end)
    end

    def step_visible(pid) do
      Agent.get_and_update(pid, fn {{x, y}, [state | _] = history, size, map_id} ->
        step_no = length(history)

        new_state =
          for {h, v} <- @directions do
            walk_to_seat(map_id, {x, y}, {h, v}, size, step_no - 1)
          end
          |> calculate_state(state, 5)

        {{state, new_state}, {{x, y}, [new_state | history], size, map_id}}
      end)
    end
  end

  def process() do
    map = load_data()

    IO.puts("Part 1: #{part1(map)}, Part 2: #{part2(map)}")
  end

  def start_chairs(map, map_id) do
    map_size = size(map)

    Enum.map(map, &Enum.with_index/1)
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, y} ->
      Enum.map(row, fn {seat, x} -> {{x, y}, seat} end)
    end)
    |> Enum.map(fn {location, state} -> Chair.start_link(location, state, map_size, map_id) end)
    |> Enum.map(fn {:ok, pid} -> pid end)
  end

  @spec part1(chair_map()) :: integer()
  def part1(map) do
    start_chairs(map, :part1)
    |> simulate(&Chair.step_immidiate/1)
  end

  @spec part2(chair_map()) :: integer()
  def part2(map) do
    start_chairs(map, :part2)
    |> simulate(&Chair.step_visible/1)
  end

  def count_occupied(chairs) do
    chairs
    |> Enum.map(&Chair.get_state/1)
    |> Enum.filter(fn val -> val == :occupied end)
    |> Enum.count()
  end

  def run_step(chairs, step) do
    chairs
    |> Enum.map(step)
    |> Enum.filter(fn {new, old} -> new != old end)
    |> Enum.count()
  end

  def simulate(chairs, step) do
    case run_step(chairs, step) do
      0 -> count_occupied(chairs)
      _ -> simulate(chairs, step)
    end
  end

  def build_map(map_id, width, height) do
    for x <- Range.new(0, width - 1) do
      for y <- Range.new(1, height - 1) do
        Chair.get_state({map_id, {x, y}})
      end
    end
  end

  @spec parse_line(String.t()) :: [chair()]
  defp parse_line(line) do
    String.codepoints(line)
    |> Enum.map(fn
      "L" -> :empty
      "#" -> :occupied
      "." -> :floor
    end)
  end

  def print_map(map) do
    Enum.each(map, fn row ->
      Enum.map_join(row, fn
        :empty -> "L"
        :occupied -> "#"
        :floor -> "."
      end)
      |> IO.puts()
    end)
  end

  @spec load_data() :: chair_map()
  def load_data() do
    Util.find_input(@day_number)
    |> Util.load_line_delimited_input()
    |> Enum.map(&parse_line/1)
  end

  def size(map) do
    width = length(Enum.at(map, 0))
    height = length(map)
    {width, height}
  end
end
