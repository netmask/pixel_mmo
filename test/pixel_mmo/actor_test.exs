defmodule PixelMmo.ActorTest do 
  use ExUnit.Case, async: true 


  setup do
    %{actor: start_supervised!(PixelMmo.Actor)}
  end
  
  test "it can kill and forvide other actions", %{actor: actor} do
    assert %{x: 5, y: 5, dead: 0} = PixelMmo.Actor.state(actor)    
    assert %{x: 5, y: 5, dead: 1} = PixelMmo.Actor.kill(actor)

    assert %{x: 5, y: 5, dead: 1} = PixelMmo.Actor.up(actor)
    assert %{x: 5, y: 5, dead: 1} = PixelMmo.Actor.down(actor)
    assert %{x: 5, y: 5, dead: 1} = PixelMmo.Actor.left(actor)
    assert %{x: 5, y: 5, dead: 1} = PixelMmo.Actor.right(actor)    
  end

  test "it can change his axis", %{actor: actor} do
    assert %{x: 5, y: 5, dead: 0} = PixelMmo.Actor.state(actor)

    assert %{x: 5, y: 4, dead: 0} = PixelMmo.Actor.up(actor)
    assert %{x: 4, y: 4, dead: 0} = PixelMmo.Actor.left(actor)
    assert %{x: 4, y: 5, dead: 0} = PixelMmo.Actor.down(actor)
    assert %{x: 5, y: 5, dead: 0} = PixelMmo.Actor.right(actor)    
  end
end
