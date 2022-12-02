defmodule Utils do
  def getInput(day) do
    {_, content} = File.read("lib/input/d" <> String.pad_leading(to_string(day), 2, "0") <> ".txt")
    content |> String.trim("\n")
  end
end
