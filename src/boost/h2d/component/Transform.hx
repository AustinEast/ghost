package boost.h2d.component;

import boost.util.DataUtil;
import h2d.col.Point;
import ecs.component.Component;

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
  }
  /**
   * Gets `x` and `y` as a new `Point`.
   * @param point If a `Point` is passed in, it will be `set` instead of creating a new `Point`.
   * @return Point containing X and Y position.
   */
  public function get_position(?point:Point):Point {
    if (point == null) return new Point(x, y);
    point.set(x, y);
    return point;
  }
  /**
   * Sets `x` and `y` with a `Point`.
   * @param point The `Point` to apply to the properties
   */
  public function set_position(point:Point) {
    this.x = point.x;
    this.y = point.y;
  }
  /**
   * Gets `scale_x` and `scale_y` as a new `Point`.
   * @param point If a `Point` is passed in, it will be `set` instead of creating a new `Point`.
   * @return Point containing `scale_x` and `scale_y`.
   */
  public function get_scale(?point:Point):Point {
    if (point == null) return new Point(scale_x, scale_y);
    point.set(scale_x, scale_y);
    return point;
  }
  /**
   * Sets `scale_x` and `scale_y` with a `Point`.
   * @param point The `Point` to apply to the properties
   */
  public function set_scale(point:Point) {
    this.scale_x = point.x;
    this.scale_y = point.y;
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
    x: 0,
    y: 0,
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
