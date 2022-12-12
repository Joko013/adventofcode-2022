defmodule D07 do
  def part1(input) do
    create_directories(input)
    |> calculate_directory_sizes()
    |> Enum.filter(fn {_, size} -> size < 100000 end)
    |> Enum.map(fn {_, size} -> size end)
    |> Enum.sum()
  end

  def part2(input) do
    sizes = create_directories(input)
    |> calculate_directory_sizes()
    remaining_space = 70000000 - sizes["/"]

    {_, size} = Enum.filter(sizes, fn {_, size} -> size + remaining_space > 30000000 end)
    |> Enum.min_by(fn {_, size} -> size end)
    size
  end

  defp create_directories(input) do
    {directories, _} = String.split(input, "\n")
    |> Enum.reduce({%{}, []}, fn line, acc -> run_line(line, acc) end)
    directories
  end

  defp calculate_directory_sizes(directories) do
    Enum.map(directories, fn {path, _} -> {path, sum_subdirectories(path, directories)} end)
    |> Map.new()
  end

  defp run_line(line, {directories, path}) do
    if String.starts_with?(line, "$") do
      execute_command(line, directories, path)
    else
      store_size_or_skip(line, directories, path)
    end
  end

  defp sum_subdirectories(path, directories) do
    Enum.filter(directories, fn {dir_path, _} -> String.starts_with?(dir_path, path) end)
    |> Enum.reduce(0, fn {_, value}, acc -> acc + value end)
  end

  defp execute_command(line, directories, path) do
    case String.split(line, " ") do
      ["$", "ls"] -> {directories, path}
      ["$", "cd", arg] -> change_directory(arg, directories, path)
    end
  end

  defp store_size_or_skip(line, directories, path) do
    case String.split(line, " ") do
      ["dir", _] -> {directories, path}
      [str_size, _] -> store_size(str_size, directories, path)
    end
  end

  defp change_directory("..", directories, path) do {directories, Enum.take(path, length(path) - 1)} end
  defp change_directory(destination, directories, path) do
    path = path ++ [destination]
    str_path = List.to_string(path)
    {Map.put(directories, str_path, 0), path}
  end

  defp store_size(str_size, directories, path) do
    size = String.to_integer(str_size)
    str_path = List.to_string(path)
    {Map.put(directories, str_path, directories[str_path] + size), path}
  end
end
