package ghost;

import ghost.Layer.TypedLayer;
import ghost.util.Components;
import hxmath.math.Vector2;
import echo.util.JSON;
import echo.Body;
import echo.data.Options.BodyOptions;
import echo.util.Disposable;
#if heaps
import h2d.Object;
#elseif openfl
import openfl.display.Sprite;
#end
using hxmath.math.MathUtil;

typedef EntityOptions = {
  ?active:Bool,
  ?name:String,
  ?x:Float,
  ?y:Float,
  ?rotation:Float,
  ?body:BodyOptions,
  ?display:#if heaps Object #elseif openfl Sprite #end,
  ?components:Array<Component>
}

class Entity implements IDisposable {
  public static var defaults(get, never):EntityOptions;
  static var ids:Int = 0;
  /**
   * Unique id of the Entity.
   */
  public var id(default, null):Int;

  public var active:Bool;
  public var alive(default, set):Bool;
  public var name:Null<String>;
  public var x(get, set):Float;
  public var y(get, set):Float;
  public var rotation(get, set):Float;
  @:allow(ghost.TypedLayer)
  public var layer(default, null):TypedLayer<Entity>;
  public var display:#if heaps Object #elseif openfl Sprite #end;
  public var body(default, set):Null<Body>;
  public var components:Components;

  public var disposed(default, null):Bool;

  public function new(?options:EntityOptions) {
    id = ++ids;
    options = JSON.copy_fields(options, defaults);
    active = options.active;
    display = options.display == null ? new #if heaps Object() #elseif openfl Sprite() #end : options.display;
    name = options.name;
    if (options.body != null) body = new Body(options.body);
    x = options.x == null ? 0 : options.x;
    y = options.y == null ? 0 : options.y;
    rotation = options.rotation == null ? 0 : options.rotation;
    components = new Components(this);
    if (options.components != null) for (c in options.components) components.add(c);
    alive = true;
    disposed = false;
  }

  public function load_options(?options:EntityOptions):Entity {
    if (options == null) return this;

    if (options.active != null) active = options.active;
    if (options.display != null) display = options.display;
    if (options.name != null) name = options.name;
    if (options.body != null) body = new Body(options.body);
    if (options.x != null) x = options.x;
    if (options.y != null) y = options.y;
    if (options.rotation != null) rotation = options.rotation;
    if (options.components != null) for (c in options.components) components.add(c);

    return this;
  }
  /**
   * Override Me!
   */
  public function load_values(values:Map<String, Dynamic>) {}
  /**
   * Override Me!
   */
  public function step(dt:Float) {}

  public function remove():Entity {
    display.remove();
    if (layer != null) {
      layer.remove(this);
      if (body != null) layer.bodies.remove(body);
    }
    if (body != null) body.remove();
    layer = null;
    return this;
  }

  public function kill() {
    alive = false;
  }

  public function dispose() {
    components.dispose();
    remove();
    if (body != null) body.dispose();

    components = null;
    display = null;
    body = null;

    disposed = true;
  }

  function toString() {
    var c = Type.getClassName(Type.getClass(this));
    return name == null ? c : '$name ( $c )';
  }

  public inline function add_body(?options:BodyOptions) {
    if (options == null) options = {};
    if (options.x == null) options.x = x;
    if (options.y == null) options.y = y;
    if (options.rotation == null) options.rotation = rotation;
    if (body == null) body = new Body(options);
    else body.load_options(options);
    return body;
  }

  public inline function get_position(vector:Vector2):Vector2 return vector == null ? new Vector2(x, y) : vector.set(x, y);

  public inline function set_position(value:Vector2):Vector2 {
    x = value.x;
    y = value.y;
    return value;
  }
  /**
   * Override Me!
   * @param layer
   */
  @:allow(ghost.TypedLayer)
  function on_add(layer:Layer) {}

  function get_x():Float return body == null ? display.x : body.x;

  function get_y():Float return body == null ? display.y : body.y;

  function get_rotation():Float return body == null ? display.rotation.radToDeg() : body.rotation;

  function set_alive(value:Bool) {
    display.visible = value;
    components.active = value;
    if (body != null) body.active = value;
    return alive = value;
  }

  function set_x(value:Float):Float {
    if (body != null) return body.x = value;
    else display.x = value;
    return display.x;
  }

  function set_y(value:Float):Float {
    if (body != null) return body.y = value;
    else display.y = value;
    return display.y;
  }

  function set_rotation(value:Float):Float {
    if (body != null) return body.rotation = value;
    else display.rotation = value.degToRad();
    return value;
  }

  inline function set_body(value:Null<Body>):Null<Body> {
    if (body != null) {
      body.entity = null;
      body.on_move = null;
      body.on_rotate = null;
      body.remove();
      if (layer != null) layer.bodies.remove(body);
    }
    body = value;
    if (body != null) {
      body.entity = this;
      body.on_move = (x, y) -> display.setPosition(x, y);
      body.on_rotate = r -> display.rotation = r.degToRad();
      if (layer != null) {
        layer.game.world.add(body);
        layer.bodies.push(body);
      }
    }
    return body;
  }

  static inline function get_defaults():EntityOptions return {
    active: true
  };
}
