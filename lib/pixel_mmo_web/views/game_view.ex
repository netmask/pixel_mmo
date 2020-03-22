defmodule PixelMmoWeb.GameView do
  use PixelMmoWeb, :view

  def draw_map(map, me) do
    Enum.map(map, fn (row) ->
      Enum.map(row, fn (col) ->
        draw_tile col, me
      end) |> Enum.join
    end) |> Enum.join |> raw
  end

  def draw_tile(heros, me) when is_list(heros) do
    %{name: my_name} = me
    
    heros = Enum.map(heros, fn (%{name: name, dead: dead}) ->
      "<span class='#{dead == 1 && 'dead' } #{my_name == name && 'me' || 'foe' }'>#{name}</span>"
    end) 

    "<div class=\"hero #{length(heros) > 1 && 'multiple'}\">#{heros}</div>"
  end
  
  def draw_tile(1, _) do
    "<div class=\"wall\"> </div>"
  end

  def draw_tile(0, _) do
    "<div class=\"walk\"> </div>"
  end
end
