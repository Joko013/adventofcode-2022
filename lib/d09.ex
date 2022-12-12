defmodule D09 do
  def part1(input) do
    {_, _, visited} = String.split(input, "\n")
    |> Enum.reduce({{0, 0}, {0, 0}, MapSet.new([{0, 0}])}, fn command, acc -> do_command(command, acc) end)

    MapSet.size(visited)
  end

  def part2(input) do
    positions = [{0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}]
    {_, visited} = String.split(input, "\n")
    |> Enum.reduce({positions, MapSet.new([{0, 0}])}, fn command, acc -> do_command_10(command, acc) end)

    MapSet.size(visited)
  end

  defp do_command(c, descriptors) do
    {direction, count} = parse_command(c)
    Enum.reduce(1..count, descriptors, fn _, acc -> move(direction, acc) end)
  end

  defp do_command_10(c, descriptors) do
    {direction, count} = parse_command(c)
    Enum.reduce(1..count, descriptors, fn _, acc -> move_10(direction, acc) end)
  end

  defp parse_command(c) do
    [direction, count_str] = String.split(c, " ")
    {direction, String.to_integer(count_str)}
  end

  defp move(direction, {head_position, tail_position, tail_visited}) do
    head_position = move_head(direction, head_position)
    {tail_position, tail_visited} = maybe_move_tail(tail_position, head_position, tail_visited)
    {head_position, tail_position, tail_visited}
  end

  defp move_10(direction, {positions, tail_visited}) do
    head = hd(positions)
    head_position = move_head(direction, head)
    {tail_positions, tail_visited} = move_tails(head_position, tl(positions), tail_visited)
    {[head_position] ++ tail_positions, tail_visited}
  end

  defp move_head(direction, {i, j}) do
    case direction do
      "R" -> {i + 1, j}
      "L" -> {i - 1, j}
      "U" -> {i, j + 1}
      "D" -> {i, j - 1}
    end
  end

  defp move_tails(head_position, [tail_position], tail_visited) do
    {tail_position, tail_visited} = maybe_move_tail(tail_position, head_position, tail_visited)
    {[tail_position], tail_visited}
  end
  defp move_tails(head_position, tails, tail_visited) do
    tail_position = hd(tails)
    {tail_position, _} = maybe_move_tail(tail_position, head_position, tail_visited)
    {tail_positions, tail_visited} = move_tails(tail_position, tl(tails), tail_visited)
    {[tail_position] ++ tail_positions, tail_visited}
  end


  defp maybe_move_tail(tail_position, head_position, tail_visited) do
    if should_move(tail_position, head_position) do
      tail_position = move_tail(tail_position, head_position)
      {tail_position, MapSet.put(tail_visited, tail_position)}
    else
      {tail_position, tail_visited}
    end
  end

  defp should_move({i, j}, {k, l}) do
    abs(i - k) > 1 || abs(j - l) > 1
  end

  defp move_tail({i, j}, {k, l}) do
    horizontal_dif = k - i
    vertical_dif = l - j
    cond do
      i == k && vertical_dif > 0 -> {i, j + 1}
      i == k && vertical_dif < 0 -> {i, j - 1}
      j == l && horizontal_dif > 0 -> {i + 1, j}
      j == l && horizontal_dif < 0 -> {i - 1, j}
      horizontal_dif > 1 && vertical_dif > 0 -> {i + 1, j + 1}
      horizontal_dif < -1 && vertical_dif > 0 -> {i - 1, j + 1}
      horizontal_dif > 1 && vertical_dif < 0 -> {i + 1, j - 1}
      horizontal_dif < -1 && vertical_dif < 0 -> {i - 1, j - 1}
      horizontal_dif > 0 && vertical_dif > 1 -> {i + 1, j + 1}
      horizontal_dif > 0 && vertical_dif < -1 -> {i + 1, j - 1}
      horizontal_dif < 0 && vertical_dif > 1 -> {i - 1, j + 1}
      horizontal_dif < 0 && vertical_dif < 1 -> {i - 1, j - 1}
    end
  end
end
