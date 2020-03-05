package ghost.util;

import ghost.util.ComponentType;
import ghost.util.Signal;
/**
 * TODO - Extend Group?
 */
class Components {
  static var ids:Int = 0;
  /**
   * Unique id of the Components container.
   */
  public var id(default, null):Int;

  public var active:Bool;
  public var entity:Entity;
  public var added:Signal<Component>;
  public var removed:Signal<Component>;

  var members:Map<ComponentType, Component>;

  public function new(entity:Entity) {
    this.entity = entity;
    id = ++ids;
    active = true;
    added = new Signal<Component>();
    removed = new Signal<Component>();
    members = [];
  }

  public function add(component:Component, overwrite:Bool = false):Component {
    if (overwrite) remove(component.type);
    else if (members.exists(component.type)) {
      ghost.util.Log.warn('Component of type "${component.type}" already attached to Entity (${entity.name == null ? Std.string(entity.id) : entity.name})');
      return component;
    }

    members.set(component.type, component);
    component.added(this);
    added.dispatch(component);
    return component;
  }

  public function remove(type:ComponentType):Null<Component> {
    var component = get(type);
    if (component != null) {
      members.remove(component.type);
      component.removed();
      removed.dispatch(component);
      return component;
    }
    return null;
  }

  public inline function has(type:ComponentType):Bool return members.exists(type);

  public function has_all(types:Array<ComponentType>):Bool {
    for (type in types) if (!has(type)) return false;
    return true;
  }

  public inline function get<T:Component>(type:Class<T>):Null<T> return cast members.get((cast type : Class<Component>));

  public inline function send(event:String, ?data:Dynamic) for (component in members) component.handle(event, data);

  @:allow(ghost.Component.send)
  inline function handle(event:String, ?data:Dynamic) send(event, data);

  public function dispose() {
    active = false;
    members = null;
  }
}
