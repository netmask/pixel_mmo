defmodule PixelMmoWeb.GameController do
  use PixelMmoWeb, :controller

  def index(conn, %{"name" => name}) do    
    render(conn, "index.html",
      me: player(name) |> state,
      name: name,
      map: PixelMmo.World.darw_world())
  end

  def index(conn, _), do: render(conn, "index_login.html")

  def create(conn, %{"name" => name} = params) do
    do_action player(name), params
    
    render(conn, "index.html",
      me: player(name) |> state,
      name: name,
      map: PixelMmo.World.darw_world())
  end

  defp player(name) do
    PixelMmo.World.player(name)
  end

  def state(player) do
    PixelMmo.Actor.state player
  end
  
  def do_action(player, %{"direction" => direction}) do
    PixelMmo.World.move player, direction
  end

  def do_action(player, %{"action" => "attack"}) do
    PixelMmo.World.attack player
  end
end
