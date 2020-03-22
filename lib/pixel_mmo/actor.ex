defmodule PixelMmo.Actor do
  use GenServer

  def start_link(name) do
    GenServer.start_link(__MODULE__, {:ok, name}, [])
  end

  def init({:ok, name}), do: {:ok,  %{name: name, x: 5, y: 5, dead: 0} }

  def handle_call(:state, _from, state), do: reply_state state
  
  def handle_call({:move, direction}, _from, state) do
    walk(direction, state) |> reply_state
  end

  def handle_call({:state, :kill}, _from, state) do
    reply_state %{state | dead: 1}
  end

  def handle_call({:state, :spawn, %{x: x, y: y}}, _from, state) do
    reply_state %{state | dead: 0, x: x, y: y} # a better way ?
  end

  def reply_state(new_state) do
    {:reply, new_state, new_state}
  end

  def walk(_, %{dead: 1} = state), do: state
  def walk(direction, %{x: x, y: y} = state) do
    case direction do
      :up -> %{ state | y: y - 1}
      :down -> %{ state | y: y + 1}
      :left -> %{ state | x: x - 1}
      :right -> %{ state | x: x + 1}
    end
  end

  #client 
  def up(server), do: GenServer.call(server, {:move, :up})
  def down(server), do: GenServer.call(server, {:move, :down})
  def left(server), do: GenServer.call(server, {:move, :left})
  def right(server), do: GenServer.call(server, {:move, :right})
  def kill(server), do: GenServer.call(server, {:state, :kill})
  def spawn(server, x, y), do: GenServer.call(server, {:state, :spawn, %{x: x, y: y}})
  def state(server), do: GenServer.call(server, :state)    
end
