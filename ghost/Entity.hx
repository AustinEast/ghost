package ghost;

import ghost.Layer.TypedLayer;
import ghost.util.Components;
import hxmath.math.Vector2;
import echo.util.JSON;
import echo.Body;
import echo.data.Options.BodyOptions;
import echo.util.Disposable;

// TODO - integrate hxbit at a base level and separate client and server??

typedef EntityOptions = {
  ?active:Bool,
  ?name:String,
  ?x:Float,
  ?y:Float,
  ?rotation:Float,
  ?body:BodyOptions,
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
  public var name:Null<String>;
  @:isVar
  public var x(get, set):Float;
  @:isVar
  public var y(get, set):Float;
  @:isVar
  public var rotation(get, set):Float;
  @:allow(ghost.TypedLayer)
  public var layer(default, null):TypedLayer<Entity>;
  public var game(get, never):Null<Game>;
  /**
   * TODO - move into component?
   */
  public var body(default, set):Null<Body>;

  public var components:Components;

  public var disposed(default, null):Bool;

  public function new(?options:EntityOptions) {
    id = ++ids;
    options = JSON.copy_fields(options, defaults);
    active = options.active;
    name = options.name;
    if (options.body != null) body = new Body(options.body);
    x = options.x == null ? 0 : options.x;
    y = options.y == null ? 0 : options.y;
    rotation = options.rotation == null ? 0 : options.rotation;
    components = new Components(this);
    if (options.components != null) for (c in options.components) components.add(c);
    disposed = false;
    init();
  }

  public function load_options(?options:EntityOptions):Entity {
    if (options == null) return this;

    if (options.active != null) active = options.active;
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
  public function init() {}
  /**
   * Override Me!
   */
  public function load_values(values:Map<String, Dynamic>) {}
  /**
   * Override Me!
   */
  public function step(dt:Float) {}

  public function remove():Entity {
    if (layer != null) {
      layer.remove(this);
      if (body != null) layer.bodies.remove(body);
    }
    if (body != null) body.remove();
    layer = null;
    return this;
  }

  public function dispose() {
    components.dispose();
    remove();
    if (body != null) body.dispose();

    components = null;
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

  public inline function set_position(vector:Vector2):Vector2 {
    x = vector.x;
    y = vector.y;
    return vector;
  }
  /**
   * Override Me!
   * @param layer
   */
  @:allow(ghost.TypedLayer)
  function on_add(layer:Layer) {}

  function get_x():Float return body == null ? x : body.x;

  function get_y():Float return body == null ? y : body.y;

  function get_rotation():Float return body == null ? rotation : body.rotation;

  function get_game() {
    if (layer != null) return layer.game;
    return null;
  }

  function set_x(value:Float):Float {
    if (body != null) return body.x = value;
    return x = value;
  }

  function set_y(value:Float):Float {
    if (body != null) return body.y = value;
    return y = value;
  }

  function set_rotation(value:Float):Float {
    if (body != null) return body.rotation = value;
    return rotation = value;
  }

  inline function set_body(value:Null<Body>):Null<Body> {
    if (body != null) {
      var b = body;
      body = null;
      x = b.x;
      y = b.y;
      b.entity = null;
      b.on_move = null;
      b.on_rotate = null;
      b.remove();
      if (layer != null) layer.bodies.remove(b);
    }
    body = value;
    if (body != null) {
      body.entity = this;
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
