defmodule AdventOfCode.Util do
  @moduledoc ~S"""
  Common functions for loading data
  """

  @spec load_line_delimited_input([String.t()] | String.t()) :: [String.t()]
  def load_line_delimited_input(path)

  def load_line_delimited_input(path) when is_list(path) do
    Path.join(path)
    |> load_line_delimited_input()
  end

  def load_line_delimited_input(path) do
    File.stream!(path, [], :line)
    |> Enum.map(&String.trim(&1))
    |> Enum.to_list()
  end

  @spec load_blank_line_delimited_input([String.t()] | String.t()) :: [String.t()]
  def load_blank_line_delimited_input(path)

  def load_blank_line_delimited_input(path) when is_list(path) do
    Path.join(path)
    |> load_blank_line_delimited_input()
  end

  def load_blank_line_delimited_input(path) do
    File.read!(path)
    |> String.split("\n\n")
  end

  @doc ~S"""

  """
  @spec find_input(integer(), String.t()) :: [String.t()]
  def find_input(day, filename \\ "input") do
    day_str =
      Integer.to_string(day)
      |> String.pad_leading(2, "0")

    ["priv", "day#{day_str}", filename]
  end
end
