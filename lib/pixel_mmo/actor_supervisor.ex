defmodule PixelMmo.ActorSupervisor do
  use DynamicSupervisor

  def start_link(_init_arg \\ []) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_child(name) do
    DynamicSupervisor.start_child(__MODULE__, {PixelMmo.Actor, name})
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
