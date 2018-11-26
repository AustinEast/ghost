package ghost.h2d.component;

import hxmath.math.Vector2;
import ghost.util.DataUtil;
import ecs.component.Component;
import h2d.col.Point;
/**
 * Component to add motion to an Entity.
 *
 * TODO: Move some of the traits to a `Material` type
 */
class Motion extends Component {
  /**
   * Default Motion Options
   */
  public static var defaults(get, null):MotionOptions;

  public var velocity:Vector2;
  public var acceleration:Vector2;
  public var rotational_velocity:Float;
  public var drag:Vector2;
  public var rotational_drag:Float;
  public var elasticity:Float;
  public var mass(default, set):Float;
  public var inv_mass(default, null):Float;
  public var gravity_scale:Float;
  public var kinematic:Bool;

  public function new(?options:MotionOptions) {
    options = DataUtil.copy_fields(options, defaults);
    velocity = new Vector2(options.velocity.x, options.velocity.y);
    acceleration = new Vector2(0, 0);
    rotational_velocity = options.rotational_velocity;
    drag = new Vector2(options.drag.x, options.drag.y);
    rotational_drag = options.rotational_drag;
    elasticity = options.elasticity;
    mass = options.mass;
    gravity_scale = options.gravity_scale;
    kinematic = options.kinematic;
  }

  static function get_defaults():MotionOptions return {
    velocity: {x: 0, y: 0},
    rotational_velocity: 0,
    drag: {x: 0, y: 0},
    rotational_drag: 0,
    elasticity: 0,
    mass: 1,
    gravity_scale: 1,
    kinematic: false
  }

  function set_mass(value:Float) {
    if (value < 0) value = 0;
    inv_mass = 1 / value;
    return mass = value;
  }
}

typedef MotionOptions = {
  ?velocity:{?x:Float, ?y:Float},
  ?rotational_velocity:Float,
  ?drag:{?x:Float, ?y:Float},
  ?rotational_drag:Float,
  ?elasticity:Float,
  ?mass:Float,
  ?gravity_scale:Float,
  ?kinematic:Bool
}
