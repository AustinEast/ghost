package boost.h2d.system;

import boost.h2d.Collisions;
import boost.h2d.component.Transform;
import boost.h2d.component.Collider;
import boost.h2d.component.Motion;
import boost.h2d.node.Static;
import boost.util.DataUtil;
import ecs.Engine;
import ecs.event.EventFactory;
import ecs.node.*;
import ecs.system.FixedUpdateSystem;
import h2d.Graphics;

using tink.CoreApi;

class CollisionSystem<Event> extends FixedUpdateSystem<Event> {
  var factory:EventFactory<Event, CollisionData>;
  var statics:NodeList<Static>;
  @:nodes var dynamics:Node<Transform, Collider, Motion>;

  public static var defaults(get, null):CollisionOptions;

  public var debug:Bool;
  /**
   * Store of the Collisions from the previous frame.
   * Used to determine if an overlap from the current frame should trigger the enter, stay, or exit callback in an entity.
   */
  var last_shape_cols:Array<CollisionData>;
  /**
   * Store of the Collisions from the current frame.
   */
  var shape_cols:Array<CollisionData>;
  /**
   * TODO
   */
  var listeners:CallbackLink;
  /**
   * Temporary debug graphic until proper debug system is in place
   */
  var debug_graphic:Graphics;

  public function new(factory, ?options:CollisionOptions, ?debug_graphic:Graphics) {
    super();
    options = DataUtil.copy_fields(options, defaults);

    this.factory = factory;
    this.debug_graphic = debug_graphic == null ? new Graphics() : debug_graphic;
  }

  override function onAdded(engine:Engine<Event>) {
    super.onAdded(engine);

    statics = new TrackingNodeList(engine, Static.new, entity -> entity.has(Transform) && entity.has(Collider) && !entity.has(Motion));
    listeners = [];
  }

  override function onRemoved(engine:Engine<Event>) {
    super.onRemoved(engine);
    listeners.dissolve();
    listeners = null;
  }

  override function update(dt:Float) {
    // TODO: Add in broad phase collision check
    debug_graphic.clear();
    if (debug) {
      debug_graphic.beginFill(0x00FF00, 0.5);
      debug_graphic.lineStyle(1, 0xFF00FF);
      for (node in statics) {
        node.collider.shape.draw_debug(debug_graphic, node.transform.x, node.transform.y);
      }
      for (node in dynamics) {
        node.collider.shape.draw_debug(debug_graphic, node.transform.x, node.transform.y);
      }
      debug_graphic.endFill();
    }
  }

  // function resolve(e1:Entity, e2:Entity, cd:CollisionData) {
  //   // Calculate relative velocity
  //   var rv = B.velocity - A.velocity // Calculate relative velocity in terms of the normal direction
  //   var velAlongNormal = DotProduct(rv, normal) // Do not resolve if velocities are separating
  //   if (velAlongNormal > 0) return;
  //   // Calculate restitution
  //   float e = min(A.restitution, B.restitution) // Calculate impulse scalar
  //   float j = -(1 + e) * velAlongNormal j /= 1 / A.mass + 1 / B.mass // Apply impulse
  //   Vec2 impulse = j * normal A.velocity -= 1 / A.mass * impulse B.velocity += 1 / B.mass * impulse
  // }
  static function get_defaults() return {
    debug: false
  }
}

typedef CollisionOptions = {
  ?debug:Bool
}
