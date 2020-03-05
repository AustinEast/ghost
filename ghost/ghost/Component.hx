package ghost;

import ghost.util.ComponentType;
import ghost.util.Components;

class Component {
  public var type(get, never):ComponentType;
  public var entity(default, null):Entity;
  public var components(default, null):Components;

  public function added(components:Components) {
    this.components = components;
    this.entity = components.entity;
  }

  public function removed() {
    components = null;
    entity = null;
  }

  inline function send(event:String, ?data:Dynamic) if (components != null) components.handle(event, data);
  /**
   * Override Me!
   * @param event
   * @param data
   */
  @:allow(ghost.util.Components.send)
  function handle(event:String, ?data:Dynamic) {}

  public function dispose() {
    if (components != null) components.remove(type);
  }

  inline function get_type():ComponentType return this;

  public function toString() {
    return '$type( $entity )';
  }
}
