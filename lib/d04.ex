defmodule D04 do
  def part1(input) do
    String.split(input, "\n")
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(0, fn [elf1, elf2], acc -> if overlaps_whole?(elf1, elf2) do acc + 1 else acc end end)
  end

  def part2(input) do
    String.split(input, "\n")
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(0, fn [elf1, elf2], acc -> if overlaps_part?(elf1, elf2) do acc + 1 else acc end end)
  end

  defp parse_line(line) do
    String.split(line, ",")
    |> Enum.map(&parse_range/1)
  end

  defp parse_range(str_range) do
    [from, to] = String.split(str_range, "-")
    MapSet.new(String.to_integer(from)..String.to_integer(to))
  end

  defp overlaps_whole?(s1, s2) do MapSet.subset?(s1, s2) || MapSet.subset?(s2, s1) end
  defp overlaps_part?(s1, s2) do !MapSet.disjoint?(s1, s2) end
end
