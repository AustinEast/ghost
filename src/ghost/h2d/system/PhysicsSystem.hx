package ghost.h2d.system;

import h2d.Graphics;
import ghost.h2d.Collisions;
import ghost.h2d.component.Transform;
import ghost.h2d.component.Motion;
import ghost.sys.Event;
import ghost.util.DataUtil;
import ecs.node.Node;
import ecs.system.EventHandlerSystem;

using hxmath.math.Vector2;
using hxd.Math;
using ghost.h2d.ext.Vector2Ext;
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
  public var debug:Bool;
  /**
   * Temporary debug graphic until proper debug system is in place
   */
  var debug_graphic:Graphics;
  var debug_cleared:Bool;

  public function new(?options:PhysicsOptions, ?context:h2d.Object) {
    super();
    options = DataUtil.copy_fields(options, defaults);
    gravity = new Vector2(options.gravity.x, options.gravity.y);
    correction_percent = options.correction_percent;
    lerp = options.lerp;
    debug = options.debug;
    debug_graphic = new Graphics(context);
    debug_cleared = false;
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
    }
    else if (col.item1.motion != null) {
      resolve_static(col.item1, col.data);
    }
    // else {
    //   col.item2.transform.add(col.data.normal * col.data.overlap);
    // }
  }

  override function update(dt:Float) {
    if (!debug_cleared) debug_graphic.clear();
    if (debug) debug_graphic.beginFill(0x009badb7, 1);
    debug_graphic.lineStyle(1, 0x00847e87);

    for (node in nodes) {
      if (debug) debug_graphic.moveTo(node.transform.x, node.transform.y);

      // position += timestep * (velocity + timestep * acceleration / 2);
      // velocity += timestep * acceleration;

      // Apply Gravity
      if (!node.motion.kinematic) node.motion.acceleration += gravity;
      // Compute Velocity
      node.motion.velocity.x = compute_velocity(node.motion.velocity.x, node.motion.acceleration.x, node.motion.drag.x, node.motion.max_velocity.x);
      node.motion.velocity.y = compute_velocity(node.motion.velocity.y, node.motion.acceleration.y, node.motion.drag.y, node.motion.max_velocity.y);
      // Apply Velocity
      node.transform.add(dt * node.motion.velocity);
      // TODO: Flesh out rotation stuff
      // Apply Rotations
      node.transform.rotation += node.motion.rotational_velocity * dt;

      // Reset Acceleration Forces
      node.motion.acceleration.set(0, 0);
      // node.motion.rotational_acceleration = 0;

      if (debug) {
        debug_graphic.lineTo(node.transform.x, node.transform.y);
        debug_cleared = false;
      }
    }
    if (debug) debug_graphic.endFill();
  }

  function resolve(e1:CollisionItem, e2:CollisionItem, cd:CollisionData) {
    // Calculate relative velocity
    var rv = e1.motion.velocity - e2.motion.velocity;
    // Calculate relative velocity in terms of the normal direction
    var vel_to_normal = rv * cd.normal;
    var inv_mass_sum = e1.motion.inv_mass + e2.motion.inv_mass;
    // Do not resolve if velocities are separating
    if (vel_to_normal > 0) {
      // Calculate elasticity
      var e = (e1.motion.elasticity + e2.motion.elasticity) * 0.5;
      // Calculate impulse scalar
      var j = (-(1 + e) * vel_to_normal) / inv_mass_sum;
      var impulse = -j * cd.normal;
      // Apply impulse
      var mass_sum = e1.motion.mass + e2.motion.mass;
      var ratio = e1.motion.mass / mass_sum;
      e1.motion.velocity -= impulse * e1.motion.inv_mass;
      ratio = e2.motion.mass / mass_sum;
      e2.motion.velocity += impulse * e2.motion.inv_mass;
    }

    var correction = (Math.max(cd.overlap - lerp, 0) / inv_mass_sum) * correction_percent * cd.normal;
    e1.transform.subtract(e1.motion.inv_mass * correction);
    e2.transform.add(e2.motion.inv_mass * correction);
  }

  function resolve_static(e:CollisionItem, cd:CollisionData) {
    var vel_to_normal = e.motion.velocity * cd.normal;
    if (vel_to_normal > 0) {
      var j = (-(1 + e.motion.elasticity) * vel_to_normal) / e.motion.inv_mass;
      var impulse = -j * cd.normal;
      // Apply impulse
      e.motion.velocity -= impulse * e.motion.inv_mass;
    }

    var correction = (Math.max(cd.overlap - lerp, 0) / e.motion.inv_mass) * correction_percent * cd.normal;
    e.transform.subtract(e.motion.inv_mass * correction);
  }

  inline function compute_velocity(v:Float, a:Float, d:Float, m:Float) {
    // Apply Acceleration to Velocity
    if (a != 0) {
      v += a;
    }
    // Otherwise Apply Drag to Velocity
    else if (d != 0) {
      if (v - d > 0) v -= d;
      else if (v + d < 0) v += d;
      else v = 0;
    }

    // Clamp Velocity if it has a Max
    if (m != 0) v = v.clamp(-m, m);
    return v;
  }

  static function get_defaults() return {
    gravity: {
      x: 0.,
      y: 0.
    },
    correction_percent: 1.,
    lerp: 0.3,
    debug: false
  }
}

typedef PhysicsOptions = {
  ?gravity:{
    x:Float,
    y:Float
  },
  ?correction_percent:Float,
  ?lerp:Float,
  ?debug:Bool
}
