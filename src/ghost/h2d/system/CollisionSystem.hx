package ghost.h2d.system;

import ghost.util.Color;
import ghost.h2d.Collisions;
import ghost.h2d.component.Transform;
import ghost.h2d.component.Collider;
import ghost.sys.Event;
import ghost.util.DataUtil;
import ecs.Engine;
import ecs.event.EventFactory;
import ecs.node.*;
import ecs.system.EventHandlerSystem;
import h2d.Graphics;

using tink.CoreApi;

class CollisionSystem extends EventHandlerSystem<Event, Pair<CollisionItem, CollisionItem>> {
  var factory:EventFactory<Event, Collision>;
  @:nodes var nodes:Node<Transform, Collider>;

  public static var defaults(get, null):CollisionOptions;

  public var debug:Bool;
  /**
   * Store of the Collisions from the current frame.
   */
  var collisions:Array<Collision>;
  /**
   * Store of the Collisions from the previous frame.
   * Used to determine if an overlap from the current frame should trigger the enter, stay, or exit callback in an entity.
   */
  var last_collisions:Array<Collision>;
  /**
   * Temporary debug graphic until proper debug system is in place
   */
  var debug_graphic:Graphics;
  var debug_cleared:Bool;

  public function new(factory, ?options:CollisionOptions, ?context:h2d.Object) {
    super();
    options = DataUtil.copy_fields(options, defaults);

    debug = options.debug;
    this.factory = factory;
    debug_graphic = new Graphics(context);
    debug_cleared = false;
    collisions = last_collisions = [];
  }

  override function select(e:Event) {
    return switch e {
      case BroadPhaseEvent(pair): Some(pair);
      case _: None;
    }
  }

  override function handle(pair:Pair<CollisionItem, CollisionItem>) {
    // Construct a pair of shapes from the CollisionItems
    var s1 = pair.a.collider.shape.clone();
    s1.position.x += pair.a.transform.x;
    s1.position.y += pair.a.transform.y;

    var s2 = pair.b.collider.shape.clone();
    s2.position.x += pair.b.transform.x;
    s2.position.y += pair.b.transform.y;

    // Perform Collision check
    var col = s1.collides(s2);
    if (col != null) {
      pair.a.collider.collided = true;
      pair.b.collider.collided = true;
      collisions.push({item1: pair.a, item2: pair.b, data: col});
      if (!pair.a.collider.solid || !pair.b.collider.solid) return;
      // Dispatch CollisionEvent
      engine.events.immediate(factory({item1: pair.a, item2: pair.b, data: col}));
    }

    s1.put();
    s2.put();
  }

  override function update(dt:Float) {
    // TODO: Trigger callbacks based off of prior frame's collisions
    last_collisions = collisions.copy();
    collisions = [];

    if (!debug_cleared) debug_graphic.clear();
    if (debug) {
      debug_graphic.beginFill(0x000000, 0.0);
      debug_graphic.lineStyle(1, Color.BLUE);
      for (node in nodes) {
        if (node.collider.collided) {
          debug_graphic.lineStyle(1, Color.RED);
          node.collider.collided = false;
        }
        node.collider.shape.draw_debug(debug_graphic, node.transform.x, node.transform.y);
      }
      debug_graphic.endFill();
      debug_cleared = false;
    }
  }

  static function get_defaults() return {
    debug: false
  }
}

typedef CollisionOptions = {
  ?debug:Bool
}
