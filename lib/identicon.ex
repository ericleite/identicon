defmodule Identicon do
  @moduledoc """
  Documentation for `Identicon`.
  """

  def main(input) do
    input
    |> hash_input
    |> seed_image
    |> color_image
    |> grid_image
    |> filter_grid_image
  end

  def hash_input(input) do
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list
  end

  def seed_image(seed) do
    %Identicon.Image{seed: seed}
  end

  def color_image(image) do
    %Identicon.Image{seed: [r, g, b | _tail]} = image
    %Identicon.Image{image | color: {r, g, b}}
  end

  def grid_image(image) do
    %Identicon.Image{seed: seed} = image
    grid =
      seed
      |> Enum.chunk_every(3, 3, :discard)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{ image | grid: grid }
  end

  def mirror_row(row) do
    row ++ (Enum.take(row, 2) |> Enum.reverse)
  end

  def filter_grid_image(image) do
    %Identicon.Image{grid: grid} = image
    filtered_grid = Enum.filter grid, fn({code, _index}) ->
      rem(code, 2) == 0
    end
    %Identicon.Image{image | grid: filtered_grid}
  end
end
