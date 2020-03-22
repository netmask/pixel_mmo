defmodule PixelMmo.World do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, name: :world)
  end

  def init(:ok), do: {:ok, %{}} #ok

  def handle_cast(:respawn, state) do
    dead_players(state) |> Enum.each(fn ({_name, actor}) ->
      [x, y] = PixelMmo.Map.random_free_tile
      PixelMmo.Actor.spawn(actor, x, y)
    end)
    
    {:noreply, state}
  end
  
  def handle_call({:player, name}, _from, state) do
    pid = case state[name] do
            nil -> spawn_player(name)
            _ -> state[name]
          end
    
    
    {:reply, pid, Map.put(state, name, pid)}
  end

  def handle_call(:draw, _from, state) do
    {:reply, merge_map(state), state}
  end

  def handle_call({:attack, player}, _from, state) do
    player = PixelMmo.Actor.state(player)
    
    kill_others(merge_map(state), state, player)
    
    {:reply, :ok, state}
  end

  def dead_players(state) do
    Enum.filter state, fn ({_name, actor}) ->
     %{dead: dead} = PixelMmo.Actor.state(actor)
      dead == 1
    end
  end
  
  def kill_others(map_state, state,  player) do

    Enum.each player_kill_matrix(player), fn (cords) ->
      [foe_y, foe_x] = cords
            
      fetch_tile_from_map(map_state, foe_x, foe_y)
      |> fetch_hero_names
      |> Enum.each(fn (foe_name) ->
        PixelMmo.Actor.kill(state[foe_name])
      end)      
    end
  end

  def player_kill_matrix(%{x: x, y: y}) do
    [
      [x - 1, y + 1],   [x,     y + 1],    [x + 1, y + 1],
      [x - 1, y   ],                       [x + 1, y    ],
      [x - 1, y - 1],   [x,     y - 1],    [x + 1, y - 1]
    ]    
  end
  
  def fetch_tile_from_map(map_state, x, y) do 
    Enum.at(map_state, x) |> Enum.at(y)
  end

  def fetch_hero_names(tile) when is_list(tile) do 
    Enum.map tile, fn (%{name: name}) -> name end
  end

  def fetch_hero_names(_), do: []
    
  def spawn_player(name) do
    {:ok, upid} = PixelMmo.ActorSupervisor.start_child(name)
    upid
  end

  def actor_cordinates(state) do
    Enum.map(state, fn {_name, pid} ->
      PixelMmo.Actor.state(pid) 
    end)
  end

  def merge_map(stage) do
    actor_cordinates(stage) |>
      Enum.reduce(PixelMmo.Map.shape, fn(%{x: x, y: y} = hero, map_state) ->
        List.replace_at(map_state, y, add_hero(map_state, y, x, hero))
      end)
  end

  def add_hero(map_state, y, x, hero) do
    tile = Enum.at(Enum.at(map_state, y), x) |> add_hero_to_tile(hero)
    List.replace_at(Enum.at(map_state, y), x, tile)        
  end


  def add_hero_to_tile(tile, hero) when is_list(tile), do: List.insert_at tile, -1, hero
  def add_hero_to_tile(_, hero), do: [hero]  
  def tile(_col, true), do: 2
  def tile(col, _member), do: col
  
  def darw_world() do
    GenServer.call :world, :draw
  end
    
  def player(name) do
    GenServer.call :world, {:player, name}
  end

  def move_allowed(%{x: x, y: y}, direction) do
    case direction do
      "up" -> can_move_to?(x, y - 1)
      "down" -> can_move_to?(x, y + 1)
      "left" -> can_move_to?(x - 1, y)
      "rigth" -> can_move_to?(x + 1, y)
    end
  end

  def can_move_to?(x, y) when x < 0 or y < 0, do: false 
  def can_move_to?(x, y) when x >= 0 and y >= 0 do   
    PixelMmo.Map.walkable_tile(x, y) == 0
  end

  
  def move(pid, direction) do
    player_state = PixelMmo.Actor.state(pid)
    move_actor pid,
      direction,
      move_allowed(player_state, direction)
  end


  def move_actor(_, _, false), do: false  
  def move_actor(pid, direction, true) do
    case direction do
      "up" -> PixelMmo.Actor.up(pid)
      "down" -> PixelMmo.Actor.down(pid)
      "rigth" -> PixelMmo.Actor.right(pid)
      "left" -> PixelMmo.Actor.left(pid)
    end
  end

  def attack(player) do
    GenServer.call :world, {:attack, player}
  end

  def respawn_dead() do
    GenServer.cast :world, :respawn
  end  
end
