package ghost.h2d.system;

import ghost.h2d.Collisions;
import ghost.h2d.component.Transform;
import ghost.h2d.component.Motion;
import ghost.sys.Event;
import ghost.util.DataUtil;
import ecs.node.Node;
import ecs.system.EventHandlerSystem;
import hxmath.math.Vector2;

using tink.CoreApi;
/**
 * System for providing simple "Arcade" 2D physics.
 */
class PhysicsSystem extends EventHandlerSystem<Event, Collision> {
  @:nodes var nodes:Node<Transform, Motion>;

  public static var defaults(get, null):PhysicsOptions;

  public var gravity:Vector2;
  public var correction_percent:Float;
  public var lerp:Float;

  public function new(?options:PhysicsOptions) {
    super();
    options = DataUtil.copy_fields(options, defaults);
    gravity = new Vector2(options.gravity.x, options.gravity.y);
    correction_percent = options.correction_percent;
    lerp = options.lerp;
  }

  override function select(e:Event) {
    return switch e {
      case CollisionEvent(col): Some(col);
      case _: None;
    }
  }

  override function handle(col:Collision) {
    if (col.item1.motion != null && col.item2.motion != null) {
      resolve(col.item1, col.item2, col.data);
    } else if (col.item1.motion != null) {
      resolve_static(col.item1, col.data);
    }
    // else {
    //   col.item2.transform.add(col.data.normal * col.data.overlap);
    // }
  }

  override function update(dt:Float) {
    for (node in nodes) {
      // Apply Gravity
      if (!node.motion.kinematic) {
        node.motion.acceleration += gravity * dt;
      }

      // Apply Acceleration Forces to Velocity
      node.motion.velocity += node.motion.acceleration;
      node.motion.acceleration.set(0, 0);

      // Apply Velocity
      node.transform.x += node.motion.velocity.x * dt;
      node.transform.y += node.motion.velocity.y * dt;
      node.transform.rotation += node.motion.rotational_velocity * dt;

      // Apply Drag
    }
  }

  function resolve(e1:CollisionItem, e2:CollisionItem, cd:CollisionData) {
    // Calculate relative velocity
    var rv = e1.motion.velocity - e2.motion.velocity;
    // Calculate relative velocity in terms of the normal direction
    var vel_to_normal = rv * cd.normal;
    var inv_mass_sum = e1.motion.inv_mass + e2.motion.inv_mass;
    // Do not resolve if velocities are separating
    if (vel_to_normal <= 0) {
      // Calculate elasticity
      var e = Math.min(e1.motion.elasticity, e2.motion.elasticity);
      // Calculate impulse scalar
      var j = (-(1 + e) * vel_to_normal) / inv_mass_sum;
      var impulse = j * cd.normal;
      // Apply impulse
      var mass_sum = e1.motion.mass + e2.motion.mass;
      var ratio = e1.motion.mass / mass_sum;
      e1.motion.velocity -= ratio * impulse;
      ratio = e2.motion.mass / mass_sum;
      e2.motion.velocity += ratio * impulse;
    }

    var correction = (Math.max(cd.overlap - lerp, 0) / inv_mass_sum) * correction_percent * cd.normal;
    e1.transform.subtract(e1.motion.inv_mass * correction);
    e2.transform.add(e2.motion.inv_mass * correction);
  }

  function resolve_static(e:CollisionItem, cd:CollisionData) {
    var vel_to_normal = -e.motion.velocity * cd.normal;
    if (vel_to_normal <= 0) {
      // var j = (-(1 + e.motion.elasticity) * e.motion.velocity) / e.motion.inv_mass;
      // var impulse = j * cd.normal;
      // // Apply impulse
      e.motion.velocity = e.motion.velocity * -e.motion.elasticity;
    }

    var correction = (Math.max(cd.overlap - lerp, 0)) * correction_percent * cd.normal;
    e.transform.subtract(e.motion.inv_mass * correction);
  }

  static function get_defaults() return {
    gravity: {
      x: 0.,
      y: 0.
    },
    correction_percent: 1.,
    lerp: 0.09
  }
}

typedef PhysicsOptions = {
  ?gravity:{
    x:Float,
    y:Float
  },
  ?correction_percent:Float,
  ?lerp:Float
}
