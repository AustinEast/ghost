package g2d.component;

import gxd.util.DataUtil;
import ecs.component.Component;
import hxmath.math.Vector2;

class Transform extends Component {
  /**
   * Default Transform Options
   *
   * TODO: Update to use `Vector2` (see col shapes)
   */
  public static var defaults(get, null):TransformOptions;

  public var x(get, set):Float;
  public var y(get, set):Float;
  public var rotation(get, set):Float;
  public var scale_x(get, set):Float;
  public var scale_y(get, set):Float;

  // Private until finished
  var parent(get, set):Transform;

  public var dirty:Bool;

  @:allow(g2d.system.RenderSystem)
  var context(default, set):h2d.Object;
  @:allow(g2d.system.RenderSystem)
  var object:h2d.Object;
  @:allow(g2d.system.RenderSystem)
  var children:Array<Transform>;
  var _parent:Transform;

  public function new(?options:TransformOptions) {
    options = DataUtil.copy_fields(options, defaults);
    object = new h2d.Object();
    object.setPosition(options.x, options.y);
    object.rotation = options.rotation;
    object.scaleX = options.scale_x;
    object.scaleY = options.scale_y;
    dirty = true;
  }

  public function add(vector2:Vector2) {
    x += vector2.x;
    y += vector2.y;
  }

  public function subtract(vector2:Vector2) {
    x -= vector2.x;
    y -= vector2.y;
  }
  /**
   * Gets `x` and `y` as a new `Vector2`.
   * @param vector2 If a `Vector2` is passed in, it will be `set` instead of creating a new `Vector2`.
   * @return Vector2 containing X and Y position.
   */
  public function get_position(?vector2:Vector2):Vector2 {
    if (vector2 == null) return new Vector2(x, y);
    vector2.set(x, y);
    return vector2;
  }
  /**
   * Sets `x` and `y` with a `Vector2`.
   * @param vector2 The `Vector2` to apply to the properties
   */
  public function set_position(vector2:Vector2) {
    this.x = vector2.x;
    this.y = vector2.y;
  }

  // Private until finished
  function remove() if (_parent != null) parent.remove_child(this);

  // Private until finished
  function remove_child(child:Transform) {
    children.remove(child);
    child.parent = null;
  }

  // Private until finished
  function remove_children() while (children.length > 0) remove_child(children[0]);

  // getters
  function get_x():Float return object.x;

  function get_y():Float return object.y;

  function get_rotation():Float return object.rotation;

  function get_scale_x():Float return object.scaleX;

  function get_scale_y():Float return object.scaleY;

  function get_parent():Transform return _parent;

  // setters
  function set_x(value:Float):Float {
    if (object.x == value) return object.x;
    dirty = true;
    return object.x = value;
  }

  function set_y(value:Float):Float {
    if (object.y == value) return object.y;
    dirty = true;
    return object.y = value;
  }

  function set_rotation(value:Float):Float {
    if (object.rotation == value) return object.rotation;
    dirty = true;
    return object.rotation = value;
  }

  function set_scale_x(value:Float):Float {
    if (object.scaleX == value) return object.scaleX;
    dirty = true;
    return object.scaleX = value;
  }

  function set_scale_y(value:Float):Float {
    if (object.scaleY == value) return object.scaleY;
    dirty = true;
    return object.scaleY = value;
  }

  function set_context(value:h2d.Object) {
    context = value;
    parent = null;
    dirty = true;
    return context;
  }

  function set_parent(value:Transform):Transform {
    object.remove();
    dirty = true;
    if (value != null) {
      value.object.addChild(object);
      return _parent = value;
    }
    if (context != null) context.addChild(object);
    return _parent = null;
  }

  static function get_defaults():TransformOptions return {
    x: 0.,
    y: 0.,
    rotation: 0,
    scale_x: 1,
    scale_y: 1
  }
}

typedef TransformOptions = {
  var ?x:Float;
  var ?y:Float;
  var ?rotation:Float;
  var ?scale_x:Float;
  var ?scale_y:Float;
}
