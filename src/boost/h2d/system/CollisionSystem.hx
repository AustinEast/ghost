package boost.h2d.system;

import ecs.node.NodeBase;
import ecs.node.NodeList;
import ecs.node.TrackingNodeList;
import h2d.Graphics;
import boost.h2d.component.Transform;
import boost.h2d.component.Collider;
import boost.h2d.component.Motion;
import boost.h2d.geom.Rect;
import boost.sys.Event;
import boost.sys.ds.QuadTree;
import boost.util.DataUtil;
import ecs.Engine;
import ecs.node.Node;
import ecs.system.System;
import tink.CoreApi.CallbackLink;

class CollisionSystem extends System<Event> {
  var statics:NodeList<Static>;
  @:nodes var dynamics:Node<Transform, Collider, Motion>;

  public static var defaults(get, null):CollisionOptions;

  public var world:Rect;
  public var debug_colliders:Bool;
  public var debug_quadtree:Bool;
  /**
   * QuadTree Structure to perform broad-phase overlap checks.
   */
  var quadtree:QuadTree;
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

  public function new(?options:CollisionOptions, ?debug_graphic:Graphics) {
    super();
    options = DataUtil.copy_fields(options, defaults);

    quadtree = QuadTree.get(options.world.x + (options.world.width * 0.5),
      options.world.y + (options.world.height * 0.5),
      options.world.width * 0.5,
      options.world.height * 0.5);
    this.debug_graphic = debug_graphic == null ? new Graphics() : debug_graphic;
  }

  override function onAdded(engine:Engine<Event>) {
    super.onAdded(engine);

    statics = new TrackingNodeList(engine, Static.new, entity -> entity.has(Transform) && entity.has(Collider) && !entity.has(Motion));
    for (node in statics) add_collider(node.entity.id, node.collider);
    for (node in dynamics) add_collider(node.entity.id, node.collider);
    listeners = [
      statics.nodeAdded.handle((node) -> add_collider(node.entity.id, node.collider)),
      statics.nodeRemoved.handle((node) -> remove_collider(node.entity.id)),
      dynamics.nodeAdded.handle((node) -> add_collider(node.entity.id, node.collider)),
      dynamics.nodeRemoved.handle((node) -> remove_collider(node.entity.id)),
    ];
  }

  override function onRemoved(engine:Engine<Event>) {
    super.onRemoved(engine);
    quadtree.put();
    listeners.dissolve();
    listeners = null;
  }

  function add_collider(id:Int, collider:Collider) {
    collider.quadtree_data = new QuadTreeData(id, collider.shape);
    quadtree.insert(collider.quadtree_data);
  }

  function remove_collider(id:Int) {
    quadtree.remove(id);
  }

  function draw_quadtree(q:QuadTree) for (child in q.children) {
    child.draw_debug(debug_graphic);
    draw_quadtree(child);
  }

  override function update(dt:Float) {
    // TODO: Add in broad phase collision check
    debug_graphic.clear();
    debug_graphic.beginFill(0x00FF00, 0.5);
    debug_graphic.lineStyle(1, 0xFF00FF);
    for (node in dynamics) {
      var collider = node.collider;
      var transform = node.transform;
      collider.shape.position.set(transform.x, transform.y);
      collider.quadtree_data.shape = collider.shape;
      quadtree.update(collider.quadtree_data);

      collider.shape.draw_debug(debug_graphic);
      // for (node2 in dynamics) {
      // var shape_col = differ.Collision.shapeWithShape(node.collider.shape, node2.collider.shape);
      // if (shape_col != null) {
      // If not static or kinematic, separate
      // if ()

      // if has motion component, do the velocity stuff

      // Send the other entity back to the tested entities for callbacks
      // node.entity.
      // 	}
      // }
    }
    draw_quadtree(quadtree);
    // quadtree.draw_debug(debug_graphic);
    debug_graphic.endFill();
  }

  static function get_defaults() return {
    world: {
      x: 0.,
      y: 0.,
      width: GM.width + 0.,
      height: GM.height + 0.
    },
    debug: {
      colliders: false,
      quadtree: false
    }
  }
}

class Static extends NodeBase {
  public var transform:Transform;
  public var collider:Collider;

  public function new(entity) {
    this.entity = entity;
    this.transform = entity.get(Transform);
    this.collider = entity.get(Collider);
  }
}

typedef CollisionOptions = {
  ?world:{
    ?x:Float,
    ?y:Float,
    ?width:Float,
    ?height:Float
  },
  ?debug:{
    ?colliders:Bool,
    ?quadtree:Bool
  }
}

typedef CollisionData = {
  seperation:{
    x:Int, y:Int
  }
}
