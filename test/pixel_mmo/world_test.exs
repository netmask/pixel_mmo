defmodule PixelMmo.WorldTest do 
  use ExUnit.Case, async: true 


  test "it can play a match!" do
    pid1 = PixelMmo.World.player "Player 1"

    pid2 = PixelMmo.World.player "Player 2"
    pid3 = PixelMmo.World.player "Player 3"
    pid4 = PixelMmo.World.player "Player 4"
    pid5 = PixelMmo.World.player "Player 5"

    runner = PixelMmo.World.player "Run Runner"
    
    PixelMmo.World.move pid2, "left"
    PixelMmo.World.move pid3, "rigth"
    PixelMmo.World.move pid4, "up"
    PixelMmo.World.move pid5, "down"

    PixelMmo.World.move runner, "up"
    PixelMmo.World.move runner, "up"
    
    PixelMmo.World.attack pid1 

    assert %{dead: 1} = PixelMmo.Actor.state(pid2)
    assert %{dead: 1} = PixelMmo.Actor.state(pid3)
    assert %{dead: 1} = PixelMmo.Actor.state(pid4)
    assert %{dead: 1} = PixelMmo.Actor.state(pid5)

    assert %{dead: 0} = PixelMmo.Actor.state(runner)
    
  end


  test ".can_move_to? expect to return false if a tile is out of bounds or not walkable" do
    refute PixelMmo.World.can_move_to?(-1, -1)
    refute PixelMmo.World.can_move_to?(-1, 0)
    refute PixelMmo.World.can_move_to?(0, -1)
    refute PixelMmo.World.can_move_to?(0, 0)
  end

  test "move_allowed expect to return true or false if the next tile is walkable" do
    refute PixelMmo.World.move_allowed %{x: 1, y: 1}, "up"
    assert PixelMmo.World.move_allowed %{x: 1, y: 1}, "down"
    refute PixelMmo.World.move_allowed %{x: 1, y: 1}, "left"
    assert PixelMmo.World.move_allowed %{x: 1, y: 1}, "rigth"
  end
end
