defmodule Day12 do

  def load(file) do
    {:ok, inputfile} = File.open file, [:read]
    {:ok, txt}       = File.read file
    txt
  end

  def main do
    input = load("input.txt")
    strs = Enum.map(parse(String.codepoints(input)), fn x -> List.to_string(x) end)
    ints = Enum.map(strs, fn x -> parse_int(x) end)
    Enum.sum(ints)
  end

  def parse([]) do
    []
  end

  def parse(x) do

    result = x |> Enum.take_while fn x -> not is_trash(x) end
    tail = x |> Enum.drop_while fn x -> not is_trash(x) end
    [result|parse(tail |> Enum.drop_while fn x -> is_trash(x) end)]

  end

  def is_trash(x) do
    String.contains?(x, ["[", "]", "{", "}", ",", ":"])
  end

  def parse_int(str) do

    try do
      String.to_integer(str)
    catch
      _, _ -> 0
    end
  end

end
