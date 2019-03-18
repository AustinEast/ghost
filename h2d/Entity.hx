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
  public var layer(default, set):Int;

  public function new(options:BodyOptions, ?base:Object, layer:Int = 0) {
    super(options);
    this.base = base == null ? new Object() : base;
    this.layer = 0;
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
    state.camera.add(base, layer);
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

  public function set_layer(value:Int) {
    if (base.parent != null) base.parent.addChildAt(base, value);
    return layer = value;
  }
}
