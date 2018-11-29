package ghost.h2d.system;

import ghost.h2d.Collisions;
import ghost.h2d.geom.Rect;
import ghost.h2d.node.Static;
import ghost.h2d.component.Transform;
import ghost.h2d.component.Collider;
import ghost.h2d.component.Motion;
import ghost.sys.Event;
import ghost.sys.ds.QuadTree;
import ghost.util.DataUtil;
import ecs.Engine;
import ecs.event.EventFactory;
import ecs.node.*;
import ecs.system.System;
import h2d.Graphics;

using tink.CoreApi;
/**
 * System to perform a BroadPhase Overlap check to find potential collisions.
 * Emits an event containing results.
 */
class BroadPhaseSystem extends System<Event> {
  var factory:EventFactory<Event, Pair<CollisionItem, CollisionItem>>;
  @:nodes var dynamics:Node<Transform, Collider, Motion>;
  @:nodes var nodes:Node<Transform, Collider>;

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
  var debug_cleared:Bool;

  public function new(factory, ?options:BroadPhaseOptions, ?context:h2d.Object) {
    super();
    options = DataUtil.copy_fields(options, defaults);

    this.factory = factory;
    quadtree = QuadTree.get(options.x + (options.width * 0.5), options.y + (options.height * 0.5), options.width, options.height);
    debug = options.debug;
    debug_graphic = new Graphics(context);
    debug_cleared = false;
  }

  override function onAdded(engine:Engine<Event>) {
    super.onAdded(engine);
    for (node in nodes) add_collider(node);
    listeners = [nodes.nodeAdded.handle(add_collider), nodes.nodeRemoved.handle(remove_collider)];
  }

  override function onRemoved(engine:Engine<Event>) {
    super.onRemoved(engine);
    quadtree.put();
    listeners.dissolve();
    listeners = null;
  }

  function add_collider(node:Node<Transform, Collider>) {
    node.collider.quadtree_data = {
      data: {
        id: node.entity.id,
        collider: node.collider,
        transform: node.transform
      },
      bounds: node.collider.shape.to_aabb(),
      flag: false
    };
    if (node.entity.has(Motion)) node.collider.quadtree_data.data.motion = node.entity.get(Motion);
    quadtree.update(node.collider.quadtree_data);
  }

  function remove_collider(node:Node<Transform, Collider>) {
    quadtree.remove(node.collider.quadtree_data);
  }

  function draw_quadtree(q:QuadTree) for (child in q.children) {
    child.draw_debug(debug_graphic);
    draw_quadtree(child);
  }

  override function update(dt:Float) {
    // Update entity Quadtree data if their transforms have been updated
    for (node in nodes) update_data(node.entity.id, node.transform, node.collider);

    // Get an empty rect to copy our dynamic nodes' aabbs
    var r = Rect.get();

    // Make an array to store all collision pairs, to cull for duplicates
    var arr:Array<Pair<CollisionItem, CollisionItem>> = [];

    // Query the Quadtree for potential collisions with all Dynamic Colliders
    for (node in dynamics) {
      // Calculate the node's aabb
      node.collider.shape.to_aabb(r);
      r.position.x += node.transform.x;
      r.position.y += node.transform.y;

      // Search for potential collision pairs in the quadtree
      for (item in quadtree.query(r)) {
        // Filter out self collisions
        if (node.entity.id == item.data.id) continue;
        // Filter out duplicate pairs
        if (arr.filter((pair)
            -> {
              if (pair.a.id == node.entity.id && pair.b.id == item.data.id) return true;
              if (pair.b.id == node.entity.id && pair.a.id == item.data.id) return true;
              return false;
            }).length > 0) continue;
        // TODO: Filter by Collision Mask

        // Create a pair of the two filtered items, and cache it for filtering duplicates
        arr.push(new Pair({
          id: node.entity.id,
          collider: node.collider,
          transform: node.transform,
          motion: node.motion
        }, {
          id: item.data.id,
          collider: item.data.collider,
          transform: item.data.transform,
          motion: item.data.motion
        }));
        // Dispatch an event containing potential collision pair
        engine.events.afterSystemUpdate(factory(arr[arr.length - 1]));
      }
    }
    // Recycle the aabb rect
    r.put();

    // Draw debug graphics
    if (!debug_cleared) debug_graphic.clear();
    if (debug) {
      debug_graphic.beginFill(0x009badb7, 0.4);
      debug_graphic.lineStyle(1, 0x00847e87);
      draw_quadtree(quadtree);
      debug_graphic.endFill();
      debug_cleared = false;
    }
  }

  inline function update_data(id:Int, t:Transform, c:Collider) {
    if (t.dirty) {
      t.dirty = false;
      c.shape.to_aabb(c.quadtree_data.bounds);
      c.quadtree_data.bounds.position.x += t.x;
      c.quadtree_data.bounds.position.y += t.y;
      quadtree.update(c.quadtree_data);
    }
  }

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

typedef BroadPhaseOptions = {
  ?x:Float,
  ?y:Float,
  ?width:Float,
  ?height:Float,
  ?debug:Bool
}
