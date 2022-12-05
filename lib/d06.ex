defmodule D06 do
  def part1(input) do
    find_marker(input, 4)
  end

  def part2(input) do
    find_marker(input, 14)
  end

  defp find_marker(input, marker_size) do
    String.codepoints(input)
    |> Enum.with_index(1)
    |> Enum.chunk_every(marker_size, 1, :discard)
    |> Enum.drop_while(fn item -> !is_marker?(item) end)
    |> hd()
    |> find_marker_position()
  end

  defp is_marker?(candidate) do
    MapSet.size(MapSet.new(Enum.map(candidate, fn {char, _} -> char end))) == length(candidate)
  end

  defp find_marker_position(marker) do
    {_, index} = List.last(marker)
    index
  end
end
