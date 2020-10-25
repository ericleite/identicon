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
    |> pixel_image
    |> draw_image
    |> save_image(input)
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

  def pixel_image(image) do
    %Identicon.Image{grid: grid} = image

    pixel_map = Enum.map grid, fn({_code, index}) ->
      x = rem(index, 5) * 50
      y = div(index, 5) * 50
      start = {x, y}
      stop = {x + 50, y + 50}
      {start, stop}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    egd_image = :egd.create(250, 250)
    egd_color = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(egd_image, start, stop, egd_color)
    end

    :egd.render(egd_image)
  end

  def save_image(egd_image, input) do
    File.write("tmp/#{input}.png", egd_image)
  end
end
