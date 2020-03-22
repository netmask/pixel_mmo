defmodule PixelMmo.Map do

  def shape do
    [
      [1,1,1,1,1,1,1,1,1,1],
      [1,0,0,0,1,0,0,0,0,1],
      [1,0,0,0,1,0,0,0,0,1],
      [1,0,0,0,0,0,0,0,0,1],
      [1,1,1,0,0,0,0,1,0,1],
      [1,0,0,0,0,0,0,1,0,1],
      [1,0,0,0,0,0,1,1,0,1],
      [1,0,0,0,0,0,0,0,0,1],
      [1,0,0,0,0,1,0,0,0,1],
      [1,1,1,1,1,1,1,1,1,1],
    ]
  end 


  def walkable_tile(x, y), do: Enum.at(shape(), y) |> Enum.at(x)

  def free_tiles do
    Enum.with_index(shape())
    |> Enum.reduce([], fn({row, y}, acc) ->
      Enum.with_index(row)
      |> Enum.map(fn {column, x} -> column == 0 && [x,y] end)
      |> Enum.filter(fn (e) -> is_list(e) end )
      |> Enum.concat(acc)
    end) 
  end

  def random_free_tile, do: free_tiles() |> Enum.random
end
