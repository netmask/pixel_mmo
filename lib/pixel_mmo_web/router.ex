defmodule PixelMmoWeb.Router do
  use PixelMmoWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PixelMmoWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/game", GameController, :index
    post "/game", GameController, :create
  end

  
  # Other scopes may use custom stacks.
  # scope "/api", PixelMmoWeb do
  #   pipe_through :api
  # end
end
