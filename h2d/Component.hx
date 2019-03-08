package h2d;

import ghost.ComponentBase;

class Component extends ComponentBase<Object> {
  @:allow(h2d.Entity)
  function state_added(state:GameState) {}

  @:allow(h2d.Entity)
  function state_removed(state:GameState) {}
}
