package h3d;

import ghost.ComponentBase;
import h3d.scene.Object;

class Component extends ComponentBase<Object> {
  @:allow(h3d.Entity)
  function state_added(state:GameState) {}

  @:allow(h3d.Entity)
  function state_removed(state:GameState) {}
}
