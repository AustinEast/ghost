package boost.h2d.system;

import h2d.col.Point;
import boost.h2d.component.Transform;
import boost.h2d.component.Motion;
import boost.sys.Event;
import boost.util.DataUtil;
import ecs.node.Node;
import ecs.system.System;
/**
 * System for providing simple "Arcadey" 2D physics.
 */
class PhysicsSystem extends System<Event> {
  @:nodes var nodes:Node<Transform, Motion>;

  public static var defaults(get, null):PhysicsOptions;

  public var gravity:Point;

  public function new(?options:PhysicsOptions) {
    super();
    options = DataUtil.copy_fields(options, defaults);
    gravity = new Point(options.gravity.x, options.gravity.y);
  }

  override function update(dt:Float) {
    for (node in nodes) {
      var transform = node.transform;
      var motion = node.motion;

      // Apply Gravity
      if (!motion.kinematic) {
        motion.velocity.x += gravity.x * dt;
        motion.velocity.y += gravity.y * dt;
      }

      // Apply Velocity
      transform.x += motion.velocity.x * dt;
      transform.y += motion.velocity.y * dt;
      transform.rotation += motion.rotational_velocity * dt;

      // Apply Drag
    }
  }

  static function get_defaults() return {
    gravity: {
      x: 0.,
      y: 0.
    }
  }
}

typedef PhysicsOptions = {
  ?gravity:{
    ?x:Float,
    ?y:Float
  }
}
