package boost.h2d.component;

import boost.util.DataUtil;
import ecs.component.Component;
import h2d.col.Point;

class Motion extends Component {
  /**
   * Default Motion Options
   */
  public static var defaults(get, null):MotionOptions;

  public var velocity:Point;
  public var rotational_velocity:Float;
  public var drag:Point;
  public var rotational_drag:Float;
  public var kinematic:Bool;

  public function new(?options:MotionOptions) {
    options = DataUtil.copy_fields(options, defaults);
    velocity = new Point(options.velocity.x, options.velocity.y);
    rotational_velocity = options.rotational_velocity;
    drag = new Point(options.drag.x, options.drag.y);
    rotational_drag = options.rotational_drag;
    kinematic = options.kinematic;
  }

  static function get_defaults():MotionOptions return {
    velocity: {x: 0, y: 0},
    rotational_velocity: 0,
    drag: {x: 0, y: 0},
    rotational_drag: 0,
    kinematic: false
  }
}

typedef MotionOptions = {
  ?velocity:{?x:Float, ?y:Float},
  ?rotational_velocity:Float,
  ?drag:{?x:Float, ?y:Float},
  ?rotational_drag:Float,
  ?kinematic:Bool
}
