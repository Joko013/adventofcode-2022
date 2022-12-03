defmodule D03 do
  @alphabet (for n <- ?a..?z, do: << n :: utf8 >>) |> Enum.with_index()

  def part1(input) do
    String.split(input, "\n")
    |> Enum.map(&find_common_item/1)
    |> Enum.reduce(0, fn item, sum -> calculate_priority(item) + sum end)
  end

  def part2(input) do
    String.split(input, "\n")
    |> Enum.chunk_every(3)
    |> Enum.map(&find_common_letter/1)
    |> Enum.reduce(0, fn item, sum -> calculate_priority(item) + sum end)
  end

  defp find_common_item(line) do
    String.split_at(line, div(String.length(line), 2))
    |> Tuple.to_list()
    |> find_common_letter()
  end

  defp find_common_letter(lists) do
    lists
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(fn set, common -> MapSet.intersection(set, common) end)
    |> MapSet.to_list
    |> List.to_string
  end

  defp calculate_priority(letter) do
    priority = Enum.find_index(@alphabet, fn {item, _} -> item == String.downcase(letter) end) + 1
    if String.upcase(letter) == letter do
      priority + 26
    else
      priority
    end
  end
end
