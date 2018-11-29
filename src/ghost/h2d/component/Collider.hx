package ghost.h2d.component;

import ghost.h2d.Collisions;
import ghost.h2d.geom.Circle;
import ghost.h2d.geom.Rect;
import ghost.sys.ds.QuadTree.QuadTreeData;
import ghost.h2d.geom.Shape;
import ghost.util.DataUtil;
import ecs.entity.Entity;
import ecs.component.Component;

using tink.CoreApi;

class Collider extends Component {
  /**
   * Default `Collider` Options
   */
  public static var defaults(get, null):ColliderOptions;
  /**
   * Flag to set whether this collider is solid.
   * If set to false, collisions with this `Component`'s `Entity` will not separate, but it will
   * trigger the `Collider`'s Callback functions (`on_enter`, `on_stay`, `on_exit`).
   */
  public var solid:Bool;
  /**
   * The X offset of the `Collider` from it's `Transform`.
   */
  public var x(get, set):Float;
  /**
   * The Y offset of the `Collider` from it's `Transform`.
   */
  public var y(get, set):Float;
  /**
   * The `Shape` of the `Collider`.
   */
  public var shape:Shape;
  /**
   * The Collision Group of the `Collider`.
   *
   * TODO: Convert to bitmask
   */
  public var group:String;
  /**
   *  Collision Groups the `Collider` collides with.
   *
   * TODO: Convert to bitmask
   */
  public var colliding_groups:Array<String>;
  /**
   * Callback Function that is triggered when this `Collider` first collides with another `Collider`.
   */
  public var on_enter:Pair<Entity, CollisionData>->Void;
  /**
   * Callback Function that is triggered when this `Collider` collides with another `Collider` for multiple frames.
   */
  public var on_stay:Pair<Entity, CollisionData>->Void;
  /**
   * Callback Function that is triggered when this `Collider` ends it's collision with another `Collider`.
   */
  public var on_exit:Pair<Entity, CollisionData>->Void;

  @:allow(ghost.h2d.system.BroadPhaseSystem)
  var quadtree_data:QuadTreeData;
  @:allow(ghost.h2d.system.CollisionSystem)
  var collided:Bool;

  public function new(shape:ColliderShape = RECT, ?options:ColliderOptions) {
    options = DataUtil.copy_fields(options, defaults);

    switch shape {
      case RECT:
        this.shape = Rect.get(options.x, options.y, options.width, options.height);
      case CIRCLE:
        this.shape = Circle.get(options.x, options.y, options.radius);
    }

    solid = options.solid;
    group = options.group;
    colliding_groups = options.colliding_groups;
    on_enter = options.on_enter;
    on_stay = options.on_stay;
    on_exit = options.on_exit;
    collided = false;
  }

  // getters
  function get_x():Float return shape.x;

  function get_y():Float return shape.y;

  // setters
  function set_x(value:Float):Float return shape.x = value;

  function set_y(value:Float):Float return shape.y = value;

  static function get_defaults():ColliderOptions return {
    x: 0.,
    y: 0.,
    width: 1.,
    height: 1.,
    radius: 1.,
    solid: true,
    group: 'Default',
    colliding_groups: ['Default'],
    on_enter: (_) -> {},
    on_stay: (_) -> {},
    on_exit: (_) -> {}
  }
}

@:enum
abstract ColliderShape(Int) {
  var RECT = 0;
  var CIRCLE = 1;
  // var POLYGON = 2;
}

typedef ColliderOptions = {
  ?x:Float,
  ?y:Float,
  ?width:Float,
  ?height:Float,
  ?radius:Float,
  ?solid:Bool,
  ?group:String,
  ?colliding_groups:Array<String>,
  ?on_enter:Pair<Entity, CollisionData>->Void,
  ?on_stay:Pair<Entity, CollisionData>->Void,
  ?on_exit:Pair<Entity, CollisionData>->Void,
}
