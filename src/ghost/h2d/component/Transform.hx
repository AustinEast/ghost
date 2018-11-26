package ghost.h2d.component;

import ghost.util.DataUtil;
import ecs.component.Component;
import hxmath.math.Vector2;

class Transform extends Component {
  /**
   * Default Transform Options
   *
   * TODO: Update to use `Vector2` (see geom shapes)
   */
  public static var defaults(get, null):TransformOptions;

  public var x(default, set):Float;
  public var y(default, set):Float;
  public var rotation(default, set):Float;
  public var scale_x(default, set):Float;
  public var scale_y(default, set):Float;
  public var dirty:Bool;

  public function new(?options:TransformOptions) {
    options = DataUtil.copy_fields(options, defaults);
    x = options.x;
    y = options.y;
    rotation = options.rotation;
    scale_x = options.scale_x;
    scale_y = options.scale_y;
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
  /**
   * Gets `scale_x` and `scale_y` as a new `Vector2`.
   * @param vector2 If a `Vector2` is passed in, it will be `set` instead of creating a new `Vector2`.
   * @return Vector2 containing `scale_x` and `scale_y`.
   */
  public function get_scale(?vector2:Vector2):Vector2 {
    if (vector2 == null) return new Vector2(scale_x, scale_y);
    vector2.set(scale_x, scale_y);
    return vector2;
  }
  /**
   * Sets `scale_x` and `scale_y` with a `Vector2`.
   * @param vector2 The `Vector2` to apply to the properties
   */
  public function set_scale(vector2:Vector2) {
    this.scale_x = vector2.x;
    this.scale_y = vector2.y;
  }

  // setters
  function set_x(value:Float):Float {
    if (x != value) dirty = true;
    return x = value;
  }

  function set_y(value:Float):Float {
    if (y != value) dirty = true;
    return y = value;
  }

  function set_rotation(value:Float):Float {
    if (rotation != value) dirty = true;
    return rotation = value;
  }

  function set_scale_x(value:Float):Float {
    if (scale_x != value) dirty = true;
    return scale_x = value;
  }

  function set_scale_y(value:Float):Float {
    if (scale_y != value) dirty = true;
    return scale_y = value;
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
  ?x:Float,
  ?y:Float,
  ?rotation:Float,
  ?scale_x:Float,
  ?scale_y:Float
}
