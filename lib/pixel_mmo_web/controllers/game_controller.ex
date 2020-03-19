defmodule PixelMmoWeb.GameController do
  use PixelMmoWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
