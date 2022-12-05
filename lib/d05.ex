defmodule D05 do
  def part1(input) do
    [arrangement_str, steps_str] = String.split(input, "\n\n")

    parse_steps(steps_str)
    |> Enum.reduce(parse_arrangement(arrangement_str), &do_step_9000/2)
    |> find_top_containers()
  end

  def part2(input) do
    [arrangement_str, steps_str] = String.split(input, "\n\n")

    parse_steps(steps_str)
    |> Enum.reduce(parse_arrangement(arrangement_str), &do_step_9001/2)
    |> find_top_containers()
  end

  defp parse_arrangement(str) do
    lines = String.split(str, "\n")
    number_of_stacks = div(String.length(List.first(lines)) + 1, 4)
    arrangement = Map.new(1..number_of_stacks, fn i -> {i, []} end)

    Enum.filter(lines, fn item -> !String.starts_with?(item, " 1") end)
    |> Enum.map(&parse_arrangement_line/1)
    |> Enum.reduce(arrangement, fn line, acc -> add_containers(acc, line) end)
  end

  defp parse_steps(str) do
    String.split(str, "\n")
    |> Enum.map(&parse_step/1)
  end

  defp do_step_9000([count, from, to], arrangement) do
    Enum.reduce(1..count, arrangement, fn _, acc -> move_container(from, to, acc) end)
  end

  defp do_step_9001([count, from, to], arrangement) do
    {from_containers, arrangement} = Map.get_and_update(arrangement, from, fn current_value -> {current_value, Enum.take(current_value, -(length(current_value)-count))} end)
    moved_containers = Enum.take(from_containers, count)

    to_containers = Map.get(arrangement, to)
    Map.put(arrangement, to, moved_containers ++ to_containers)
  end

  defp find_top_containers(arrangement) do
    Map.values(arrangement)
    |> Enum.reduce("", fn e, acc -> acc <> hd(e) end)
  end

  defp parse_arrangement_line(line) do
    String.codepoints(line)
    |> Enum.with_index(1)
    |> Enum.reduce("", fn {ele, index}, acc -> if (rem(index, 4) == 2) do acc <> ele else acc end end)
  end

  defp parse_step(line) do
    regex = ~r/move (\d+) from (\d+) to (\d+)/
    [_, countStr, fromStr, toStr] = Regex.run(regex, line)
    [String.to_integer(countStr), String.to_integer(fromStr), String.to_integer(toStr)]
  end

  defp move_container(from, to, arrangement) do
    {containers, arrangement} = Map.get_and_update(arrangement, from, fn current_value -> {current_value, tl(current_value)} end)
    to_containers = Map.get(arrangement, to)
    Map.put(arrangement, to, [hd(containers)] ++ to_containers)
  end

  defp add_containers(arrangement, line) do
    String.codepoints(line)
    |> Enum.with_index(1)
    |> Enum.filter(fn {e, _} -> e != " " end)
    |> Enum.reduce(arrangement, fn {container, index}, acc -> Map.put(acc, index, acc[index] ++ [container]) end)
  end
end
