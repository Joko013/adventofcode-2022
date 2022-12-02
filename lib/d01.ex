defmodule D01 do
  def part1(input) do
    parse_calories(input) |> Enum.max()
  end

  def part2(input) do
    parse_calories(input) |> Enum.sort(:desc) |> Enum.take(3) |> Enum.sum()
  end

  defp parse_calories(input) do
    String.split(input, "\n\n") |> Enum.map(&convert_to_ints/1) |> Enum.map(&Enum.sum/1)
  end

  defp convert_to_ints(str_list) do
    String.split(str_list, "\n") |> Enum.map(&String.to_integer/1)
  end
end
