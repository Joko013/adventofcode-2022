defmodule D10 do
  def part1(input) do
    create_repository_values(input)
    |> sum_signal_strengths()
  end

  def part2(input) do
    create_repository_values(input)
    |> Enum.chunk_every(40, 40, :discard)
    |> Enum.map(&draw_line/1)
    |> Enum.reduce("", fn line, acc -> acc <> "\n" <> line end)
  end

  defp create_repository_values(input) do
    String.split(input, "\n")
    |> Enum.reduce([1], fn line, acc -> run_line(line, acc) end)
  end

  defp draw_line(values) do
    Enum.with_index(values)
    |> Enum.reduce("", fn {repository, index}, acc -> acc <> draw(repository, index) end)
  end

  defp run_line(line, acc) do
    last_value = List.last(acc)
    case String.split(line) do
      [_] -> acc ++ [last_value]
      [_, str_value] -> acc ++ [last_value, last_value + String.to_integer(str_value)]
    end
  end

  defp sum_signal_strengths(repository_values) do
    Enum.reduce([20, 60, 100, 140, 180, 220], 0, fn cycle, acc ->
      acc + calculate_signal_strength(cycle, repository_values)
    end)
  end

  defp calculate_signal_strength(cycle, repository_values) do
    Enum.at(repository_values, cycle - 1) * cycle
  end

  defp draw(repository, index) do
    if (index >= repository - 1) && (index <= repository + 1) do
      "#"
    else
      "."
    end
  end
end
