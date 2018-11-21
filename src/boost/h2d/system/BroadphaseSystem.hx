package boost.h2d.system;

import boost.h2d.Collisions;
import boost.h2d.node.Static;
import boost.h2d.component.Transform;
import boost.h2d.component.Collider;
import boost.h2d.component.Motion;
import boost.sys.ds.QuadTree;
import boost.util.DataUtil;
import ecs.Engine;
import ecs.event.EventFactory;
import ecs.node.*;
import ecs.system.FixedUpdateSystem;
import h2d.Graphics;

using tink.CoreApi;
/**
 * System to perform a BroadPhase Overlap check to find potential collisions.
 * Emits an event gaattatooc results.
 *
 */
class BroadPhaseSystem<Event> extends FixedUpdateSystem<Event> {
  var factory:EventFactory<Event, Array<BroadPhasePair>>;
  var statics:NodeList<Static>;
  @:nodes var dynamics:Node<Transform, Collider, Motion>;

  public static var defaults(get, null):BroadPhaseOptions;

  public var x(get, never):Float;
  public var y(get, never):Float;
  public var width(get, never):Float;
  public var height(get, never):Float;
  public var debug:Bool;
  /**
   * QuadTree Structure to perform broad-phase overlap checks.
   */
  var quadtree:QuadTree;
  /**
   * TODO
   */
  var listeners:CallbackLink;
  /**
   * Temporary debug graphic until proper debug system is in place
   */
  var debug_graphic:Graphics;

  public function new(factory, ?options:BroadPhaseOptions, ?debug_graphic:Graphics) {
    super();
    options = DataUtil.copy_fields(options, defaults);

    this.factory = factory;
    quadtree = QuadTree.get(options.x + (options.width * 0.5), options.y + (options.height * 0.5), options.width, options.height);
    this.debug_graphic = debug_graphic == null ? new Graphics() : debug_graphic;
  }

  override function onAdded(engine:Engine<Event>) {
    super.onAdded(engine);

    statics = new TrackingNodeList(engine, Static.new, entity -> entity.has(Transform) && entity.has(Collider) && !entity.has(Motion));
    for (node in statics) add_collider(node);
    for (node in dynamics) add_collider(node);
    listeners = [
      statics.nodeAdded.handle(add_collider),
      statics.nodeRemoved.handle(remove_collider),
      dynamics.nodeAdded.handle(add_collider),
      dynamics.nodeRemoved.handle(remove_collider)
    ];
  }

  override function onRemoved(engine:Engine<Event>) {
    super.onRemoved(engine);
    quadtree.put();
    listeners.dissolve();
    listeners = null;
  }

  function add_collider(node:Dynamic) {
    node.collider.quadtree_data = {
      id: node.entity.id,
      bounds: node.collider.shape.to_aabb(),
      flag: false
    };
    quadtree.update(node.collider.quadtree_data);
  }

  function remove_collider(node:Dynamic) {
    quadtree.remove(node.collider.quadtree_data);
  }

  function draw_quadtree(q:QuadTree) for (child in q.children) {
    child.draw_debug(debug_graphic);
    draw_quadtree(child);
  }

  override function update(dt:Float) {
    for (node in statics) {
      if (node.transform.dirty) update_data(node.transform, node.collider);
    }
    for (node in dynamics) {
      update_data(node.transform, node.collider);
    }

    var pairs:Array<BroadPhasePair> = [];
    for (node in dynamics) {
      var broad_results = quadtree.query(node.collider.shape);
      for (result in broad_results) {
        // TODO: Cull Results.
        // Remove duplicate Pairs and filter by Collision Bitmask
        pairs.push({id1: node.entity.id, id2: result.id});
      }
    }

    // if (collision != null) engine.events.afterSystemUpdate(factory(cast collision));

    debug_graphic.clear();
    if (debug) {
      debug_graphic.beginFill(0x00FF00, 0.2);
      debug_graphic.lineStyle(1, 0xFF00FF);
      draw_quadtree(quadtree);
      debug_graphic.endFill();
    }
  }

  inline function update_data(t:Transform, c:Collider) {
    // TODO: DONT MOVE COLLIDER SHAPE, JUST TRANSFORM
    c.shape.to_aabb(c.quadtree_data.bounds);
    c.quadtree_data.bounds.position.x += t.x;
    c.quadtree_data.bounds.position.y += t.y;
    quadtree.update(c.quadtree_data);
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
  // getters
  function get_x():Float return quadtree.x;

  function get_y():Float return quadtree.y;

  function get_width():Float return quadtree.width;

  function get_height():Float return quadtree.height;

  static function get_defaults() return {
    x: 0.,
    y: 0.,
    width: GM.width + 0.,
    height: GM.height + 0.,
    debug: false
  }
}

typedef BroadPhasePair = {
  id1:Int,
  id2:Int
}

typedef BroadPhaseOptions = {
  ?x:Float,
  ?y:Float,
  ?width:Float,
  ?height:Float,
  ?debug:Bool
}
