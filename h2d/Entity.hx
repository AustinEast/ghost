package h2d;

import echo.Body;
import echo.data.Options;
import h2d.Object;
import h2d.Component;

class Entity extends Body {
  public var base:Object;
  public var state:GameState;
  public var components:Components;
  public var disposed(default, null):Bool;

  public function new(options:BodyOptions, ?base:Object) {
    super(options);
    this.base = base == null ? new Object() : base;
    components = new Components(this);
    disposed = false;
  }

  public function pre_step(dt:Float) {
    components.pre_step(dt);
  }

  public function step(dt:Float) {
    components.step(dt);
  }

  public function post_step(dt:Float) {
    components.post_step(dt);
    base.setPosition(x, y);
  }

  override public function dispose() {
    super.dispose();
    state = null;
    disposed = true;
  }

  @:allow(h2d.GameState)
  function added(state:GameState) {
    this.state = state;
    state.viewport.addChild(base);
    state.world.add(this);
    // for (component in component_arr) Std.instance(component, Component).state_added(state);
  }

  @:allow(h2d.GameState)
  function removed(state:GameState) {
    this.state = null;
    base.remove();
    state.world.remove(this);
    // for (component in component_arr) Std.instance(component, Component).state_added(state);
  }
}
