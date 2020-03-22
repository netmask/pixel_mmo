defmodule PixelMmo.Respawner do
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule() # Schedule work to be performed at some point
    {:ok, state}
  end

  def handle_info(:work, state) do
    PixelMmo.World.respawn_dead()
    schedule() 
    {:noreply, state}
  end

  defp schedule() do
    IO.puts "respawning dead"
    Process.send_after(self(), :work,  6 * 60 * 1000) 
  end
end
