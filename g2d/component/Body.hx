package g2d.component;

import hxmath.math.Vector2;
import glib.Data;
import ecs.component.Component;
import h2d.col.Point;
/**
 * Component to add motion to an Entity.
 */
class Body extends Component {
  public var velocity:Vector2;
  public var max_velocity:Vector2;
  public var acceleration:Vector2;
  public var rotational_velocity:Float;
  public var drag:Vector2;
  public var rotational_drag:Float;
  public var elasticity:Float;
  public var mass(default, set):Float;
  public var inv_mass(default, null):Float;
  public var gravity_scale:Float;

  var body:echo.Body;

  public function new(?options:MotionOptions) {
    options = Data.copy_fields(options, defaults);
    velocity = new Vector2(options.velocity.x, options.velocity.y);
    max_velocity = new Vector2(options.max_velocity.x, options.max_velocity.y);
    acceleration = new Vector2(0, 0);
    rotational_velocity = options.rotational_velocity;
    drag = new Vector2(options.drag.x, options.drag.y);
    rotational_drag = options.rotational_drag;
    elasticity = options.elasticity;
    mass = options.mass;
    gravity_scale = options.gravity_scale;
    kinematic = options.kinematic;
  }
}

typedef MotionOptions = {
  var ?velocity:{
    var x:Float;
    var y:Float;
  }
  var ?max_velocity:{
    var x:Float;
    var y:Float;
  }
  var ?rotational_velocity:Float;
  var ?drag:{
    var x:Float;
    var y:Float;
  }
  var ?rotational_drag:Float;
  var ?elasticity:Float;
  var ?mass:Float;
  var ?gravity_scale:Float;
  var ?kinematic:Bool;
}
