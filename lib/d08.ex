defmodule D08 do
  def part1(input) do
    forest_map = create_map(input)
    transformations = get_transformations(forest_map)

    Enum.reduce(transformations, MapSet.new(), fn map, acc -> MapSet.union(find_visible_trees(map), acc) end)
    |> MapSet.size()
  end

  def part2(input) do
    forest_map = create_map(input)
    transformations = get_transformations(forest_map)

    Enum.reduce(transformations, Map.new(), fn map, acc ->
      Map.merge(calculate_viewing_distances(map), acc, fn _, s1, s2 -> s1 * s2 end)
    end)
    |> Map.values()
    |> Enum.max()
  end

  defp create_map(input) do
    String.split(input, "\n")
    |> Enum.map(&create_row/1)
    |> add_indices()
  end

  defp get_transformations(map) do
    right_to_left = Enum.map(map, &Enum.reverse/1)
    top_to_bottom = transpose(map)
    bottom_to_top = Enum.map(top_to_bottom, &Enum.reverse/1)
    [map, right_to_left, top_to_bottom, bottom_to_top]
  end

  defp find_visible_trees(map) do
    Enum.reduce(map, MapSet.new(), fn row, acc -> search_row(row, acc, length(map)) end)
  end

  defp calculate_viewing_distances(map) do
    Enum.reduce(map, Map.new(), fn row, acc -> Map.merge(count_visibility(row, acc), acc) end)
  end

  defp create_row(line) do
    String.graphemes(line)
    |> Enum.map(&String.to_integer/1)
  end

  defp transpose(map) do
    Enum.with_index(map)
    |> Enum.map(fn {_, j} -> Enum.map(map, fn row -> hd(Enum.slice(row, j..j)) end) end)
  end

  defp add_indices(map) do
    Enum.with_index(map)
    |> Enum.map(fn {row, i} -> Enum.map(Enum.with_index(row), fn {value, j} -> {value, i, j} end) end)
  end

  defp search_row([], found, _) do found end
  defp search_row(row, found, size) do
    tree = hd(row)
    neighbors = tl(row)
    found = add_if_visible(found, tree, neighbors, size)
    search_row(neighbors, found, size)
  end

  defp count_visibility([], counts) do counts end
  defp count_visibility(trees, counts) do
    {height, i, j} = hd(trees)
    neighbors = tl(trees)
    visibility = Enum.reduce_while(neighbors, 0, fn {neighor_height, _, _}, acc ->
      if height > neighor_height do {:cont, acc + 1} else {:halt, acc + 1} end
    end)

    counts = Map.put(counts, {i, j}, visibility)
    count_visibility(neighbors, counts)
  end

  defp add_if_visible(found, tree, neighbors, size) do
    {_, i, j} = tree
    if is_visible?(tree, neighbors, size) do
      MapSet.put(found, {i, j})
    else
      found
    end
  end

  defp is_visible?({height, i, j}, neighbors, size) do
    if (i == 0) || (i == size) || (j == 0) || (j == size) do
      true
    else
      Enum.reduce(neighbors, true, fn {neighbor_height, _, _}, acc -> (neighbor_height < height) && acc end)
    end
  end
end
