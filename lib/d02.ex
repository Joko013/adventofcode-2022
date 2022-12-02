defmodule D02 do
  def part1(input) do
    parse_rounds(input)
    |> Enum.map(&convert_choice/1)
    |> Enum.map(&calculate_score/1)
    |> Enum.sum()
  end

  def part2(input) do
    parse_rounds(input)
    |> Enum.map(&convert_result/1)
    |> Enum.map(&calculate_score/1)
    |> Enum.sum()
  end

  defp parse_rounds(input) do
    String.split(input, "\n")
    |> Enum.map(&String.split/1)
  end

  defp calculate_score([them, me]) do get_choice_score(me) + get_result_score(me, them) end

  defp get_choice_score("A") do 1 end
  defp get_choice_score("B") do 2 end
  defp get_choice_score("C") do 3 end

  defp get_result_score(me, them) do
    result_map = %{win: 6, draw: 3, lose: 0}
    result = get_result(me, them)
    result_map[result]
  end

  defp get_result(me, them) when me == them do :draw end
  defp get_result("A", "C") do :win end
  defp get_result("B", "A") do :win end
  defp get_result("C", "B") do :win end
  defp get_result(_, _) do :lose end

  defp convert_choice([them, me]) do [them, map_shape(me)] end

  defp map_shape("X") do "A" end
  defp map_shape("Y") do "B" end
  defp map_shape("Z") do "C" end

  defp convert_result(pair) do
    [them, result_code] = pair
    result = map_result(result_code)
    [them, map_choice(them, result)]
  end

  defp map_choice(them, :draw) do them end
  defp map_choice("A", :lose) do "C" end
  defp map_choice("B", :lose) do "A" end
  defp map_choice("C", :lose) do "B" end
  defp map_choice("A", :win) do "B" end
  defp map_choice("B", :win) do "C" end
  defp map_choice("C", :win) do "A" end

  defp map_result("X") do :lose end
  defp map_result("Y") do :draw end
  defp map_result("Z") do :win end
end
