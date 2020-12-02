defmodule AdventOfCode.Util do

  def load_input(path) when is_list(path) do
    Path.join(path)
    |> load_input()
  end

  def load_input(path) do
    File.stream!(path, [], :line)
    |> Enum.map(&String.trim(&1))
  end

end
