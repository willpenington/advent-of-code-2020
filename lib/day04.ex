defmodule AdventOfCode.Day04 do
  alias AdventOfCode.Util

  @required_fields [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid]

  def process() do
    passports_with_all_fields =
      load_data(["priv", "day04", "input"])
      |> Enum.filter(&check_fields_exist/1)

    IO.puts("Number of Passports with Required Fields: #{length(passports_with_all_fields)}")

    valid_passports = Enum.count(passports_with_all_fields, &validate_passport/1)
    IO.puts("Number of Valid Passports: #{valid_passports}")
  end

  @doc ~S"""
  Parse a passport field into a tuple.

  Parses a passport field encoded in a batch file into a tuple with an atom identifying the field

  ## Examples

      iex> AdventOfCode.Day04.parse_field("byr:1980")
      {:byr, "1980"}
  """
  def parse_field(<<"byr:", year::binary>>), do: {:byr, year}
  def parse_field(<<"iyr:", year::binary>>), do: {:iyr, year}
  def parse_field(<<"eyr:", year::binary>>), do: {:eyr, year}
  def parse_field(<<"hgt:", height::binary>>), do: {:hgt, height}
  def parse_field(<<"hcl:", colour::binary>>), do: {:hcl, colour}
  def parse_field(<<"ecl:", colour::binary>>), do: {:ecl, colour}
  def parse_field(<<"pid:", number::binary>>), do: {:pid, number}
  def parse_field(<<"cid:", number::binary>>), do: {:cid, number}

  @doc ~S"""
  Parse a passport record from a batch input file.

  Parse a record from a password input file into a erlang terms

  ## Examples

      iex> AdventOfCode.Day04.parse_record("ecl:gry pid:860033327 eyr:2020 hcl:#fffffd\nbyr:1937 iyr:2017 cid:147 hgt:183cm")
      %{ecl: "gry", pid: "860033327", eyr: "2020", hcl: "#fffffd", byr: "1937", iyr: "2017", cid: "147", hgt: "183cm"}

  """
  def parse_record(record) do
    String.split(record)
    |> Enum.map(&parse_field/1)
    |> Map.new()
  end

  defp load_data(path) do
    Util.load_blank_line_delimited_input(path)
    |> Enum.map(&parse_record/1)
  end

  defp validate_year(value, min_year, max_year) do
    case Integer.parse(value) do
      {year, ""} when year >= min_year and year <= max_year -> true
      _ -> false
    end
  end

  @doc ~S"""
  Validate that a field contains valid data depending on the type.

  Check if the value matches the specific rule for the type of record.

  ## Example

      iex> AdventOfCode.Day04.validate_field(:byr, "1963")
      true
      iex> AdventOfCode.Day04.validate_field(:hcl, "blu")
      false
  """
  def validate_field(:byr, value), do: validate_year(value, 1920, 2002)
  def validate_field(:iyr, value), do: validate_year(value, 2010, 2020)
  def validate_field(:eyr, value), do: validate_year(value, 2020, 2030)

  def validate_field(:hgt, value) do
    case Integer.parse(value) do
      {height, "cm"} when height >= 150 and height <= 193 -> true
      {height, "in"} when height >= 59 and height <= 76 -> true
      _ -> false
    end
  end

  def validate_field(:hcl, colour), do: colour =~ ~r/^#[0-9a-f]{6}$/

  def validate_field(:ecl, color) when color in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"],
    do: true

  def validate_field(:pid, <<number::binary-size(9)>>) do
    {_, tail} = Integer.parse(number)
    tail == ""
  end

  def validate_field(:cid, _), do: true
  def validate_field(_, _), do: false

  @doc ~S"""
  Check that all required fields for a passport exist.

  Passports must have every defined field (except CID) to be valid

  ## Examples

      iex>

  """
  def check_fields_exist(passport) do
    Enum.all?(@required_fields, &Map.has_key?(passport, &1))
  end

  def validate_passport(passport) do
    Enum.all?(passport, fn {key, val} -> validate_field(key, val) end)
  end
end
