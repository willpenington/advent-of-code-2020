defmodule AdventOfCode.Day14 do
  use Bitwise

  alias AdventOfCode.Util

  @daynumber 14

  @type mem_instruction :: {:mem, integer(), integer()}
  @type mask :: <<_::288>>
  @type mask_instruction :: {:mask, mask()}
  @type instruction :: mem_instruction() | mask_instruction()
  @type state :: %{integer() => integer()}

  @spec process() :: :ok
  def process() do
    instructions = load_data()
    IO.puts("Part 1: #{part1(instructions)}, Part 2: #{part2(instructions)}")
  end

  @spec part1([instruction()]) :: integer()
  def part1(instructions) do
    run1(instructions)
    |> Map.values()
    |> Enum.sum()
  end

  @spec apply_mask(integer(), mask()) :: integer()
  def apply_mask(value, mask) do
    <<abs_mask::size(36)>> = parse_abs_mask(mask)
    <<val_mask::size(36)>> = parse_val_mask(mask)
    (value &&& (~~~abs_mask)) ||| (val_mask &&& abs_mask)
  end

  @spec run1([instruction()], mask() | nil, state()) :: state()
  defp run1(instructions, mask, values)

  defp run1([], _, values), do: values
  defp run1([{:mask, mask} | tail], _, values), do: run1(tail, mask, values)
  defp run1([{:mem, address, value} | tail], mask, values) do

    values = Map.put(values, address, apply_mask(value, mask))
    run1(tail, mask, values)
  end

  @spec run1([instruction()]) :: state()
  def run1(instructions) do
    run1(instructions, nil, Map.new())
  end

  @spec addresses_from_mask_helper(bitstring(), binary()) :: [bitstring()]
  defp addresses_from_mask_helper(<<>>, <<>>), do: [<<>>]
  defp addresses_from_mask_helper(<<a::size(1), address::bitstring()>>, <<"0", mask::binary()>>) do
    addresses_from_mask_helper(address, mask)
    |> Enum.map(fn x ->
      <<a::size(1), x::bitstring()>>
    end)
  end
  defp addresses_from_mask_helper(<<_::size(1), address::bitstring()>>, <<"1", mask::binary()>>) do
    addresses_from_mask_helper(address, mask)
    |> Enum.map(fn x ->
      <<1::size(1), x::bitstring()>>
    end)
  end
  defp addresses_from_mask_helper(<<_::size(1), address::bitstring()>>, <<"X", mask::binary>>) do
    for base_addr <- addresses_from_mask_helper(address, mask), x <- 0..1 do
      <<x::size(1), base_addr::bitstring()>>
    end
  end

  @spec addresses_from_mask(integer(), mask()) :: [integer()]
  def addresses_from_mask(address, mask) do
    addresses_from_mask_helper(<<address::size(36)>>, mask)
    |> Enum.map(fn <<address::size(36)>> -> address end)
  end

  @spec part2([instruction()]) :: integer()
  def part2(instructions) do
    run2(instructions)
    |> Map.values()
    |> Enum.sum()
  end

  @spec run2([instruction()], mask() | nil, state()) :: state()
  defp run2(instructions, mask, values)

  defp run2([], _, values), do: values
  defp run2([{:mask, mask} | tail], _, values), do: run2(tail, mask, values)
  defp run2([{:mem, address, value} | tail], mask, values) do

    values = addresses_from_mask(address, mask)
    |> Enum.reduce(values, fn address, acc ->
      Map.put(acc, address, value)
    end)

    run2(tail, mask, values)
  end

  @spec run2([instruction()]) :: state()
  def run2(instructions) do
    run2(instructions, nil, Map.new())
  end

  @spec parse_abs_mask(binary()) :: bitstring()
  def parse_abs_mask(<<>>), do: <<>>
  def parse_abs_mask(<<"0", tail::binary()>>), do: <<1::size(1), parse_abs_mask(tail)::bitstring()>>
  def parse_abs_mask(<<"1", tail::binary()>>), do: <<1::size(1), parse_abs_mask(tail)::bitstring()>>
  def parse_abs_mask(<<"X", tail::binary()>>), do: <<0::size(1), parse_abs_mask(tail)::bitstring()>>

  @spec parse_val_mask(binary()) :: bitstring
  def parse_val_mask(<<>>), do: <<>>
  def parse_val_mask(<<"0", tail::binary()>>), do: <<0::size(1), parse_val_mask(tail)::bitstring()>>
  def parse_val_mask(<<"1", tail::binary()>>), do: <<1::size(1), parse_val_mask(tail)::bitstring()>>
  def parse_val_mask(<<"X", tail::binary()>>), do: <<0::size(1), parse_val_mask(tail)::bitstring()>>

  @spec parse_mem(String.t()) :: mem_instruction()
  def parse_mem(mem) do
    [_, address, value] = Regex.run(~r/mem\[(\d+)\] = (\d+)/, mem)
    {:mem, String.to_integer(address), String.to_integer(value)}
  end

  @spec parse_instruction(String.t()) :: instruction
  def parse_instruction(<<"mask = ", mask::binary-size(36)>>) do
    {:mask, mask}
  end

  def parse_instruction(<<"mem[", _::binary()>> = mem) do
    parse_mem(mem)
  end

  @spec load_data() :: [instruction()]
  def load_data() do
    Util.find_input(@daynumber)
    |> Util.load_line_delimited_input()
    |> Enum.map(&parse_instruction/1)
  end


end
