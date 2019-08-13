defmodule Identicon do
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
  end

  def hash_input(input) do
    %Identicon.Image{
      hex:
        :crypto.hash(:md5, input)
        |> :binary.bin_to_list()
    }
  end

  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  def build_grid(%Identicon.Image{hex: hex} = image) do
    %Identicon.Image{
      image
      | grid:
          hex
          |> Enum.chunk_every(3, 3, :discard)
          # |> Enum.map(fn row -> mirror_row(row) end)
          |> Enum.map(&mirror_row/1)
          |> List.flatten()
          |> Enum.with_index()
    }
  end

  def mirror_row(row) do
    [first, second | _tail] = row
    row ++ [second, first]
  end
end
