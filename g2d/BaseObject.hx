package g2d;

import gxd.GameObject;
import glib.Data;
import g2d.component.Transform;
/**
 * A GameObject with a 2D Transform Component amd some useful shortcuts for those values. This is a good starting point for composing 2D GameObjects.
 */
class BaseObject extends GameObject {
  /**
   * Default BaseObject Options
   */
  public static var defaults(get, null):BaseObjectOptions;
  /**
   * This GameObject's Transform Component.
   */
  public var transform(default, null):Transform;
  public var x(get, set):Float;
  public var y(get, set):Float;
  public var rotation(get, set):Float;
  public var scale_x(get, set):Float;
  public var scale_y(get, set):Float;
  /**
   * Creates a new BaseObject.
   */
  public function new(?options:BaseObjectOptions) {
    super(options);

    options = Data.copy_fields(options, defaults);

    transform = new Transform(options.transform);
    components.add(transform);
  }

  override function dispose() {
    super.dispose();
    transform = null;
  }

  // getters
  function get_x():Float return transform.x;

  function get_y():Float return transform.y;

  function get_rotation():Float return transform.rotation;

  function get_scale_x():Float return transform.scale_x;

  function get_scale_y():Float return transform.scale_y;

  // setters
  function set_x(value:Float):Float return transform.x = value;

  function set_y(value:Float):Float return transform.y = value;

  function set_rotation(value:Float):Float return transform.rotation = value;

  function set_scale_x(value:Float):Float return transform.scale_x = value;

  function set_scale_y(value:Float):Float return transform.scale_y = value;

  static function get_defaults():BaseObjectOptions return {
    transform: Transform.defaults
  }
}

typedef BaseObjectOptions = {
  > GameObjectOptions,
  var ?transform:TransformOptions;
}
