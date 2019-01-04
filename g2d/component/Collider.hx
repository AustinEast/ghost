package g2d.component;

import echo.Collisions;
import echo.shape.Shape;
import echo.shape.Circle;
import echo.shape.Rect;
import echo.util.QuadTree.QuadTreeData;
import glib.Data;
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

  @:allow(g2d.system.BroadPhaseSystem)
  var quadtree_data:QuadTreeData;
  @:allow(g2d.system.CollisionSystem)
  var collided:Bool;

  public function new(?options:ColliderOptions) {
    options = Data.copy_fields(options, defaults);

    switch options.shape {
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
    shape: RECT,
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
  var ?x:Float;
  var ?y:Float;
  var ?shape:ColliderShape;
  var ?width:Float;
  var ?height:Float;
  var ?radius:Float;
  var ?solid:Bool;
  var ?group:String;
  var ?colliding_groups:Array<String>;
  var ?on_enter:Pair<Entity, CollisionData>->Void;
  var ?on_stay:Pair<Entity, CollisionData>->Void;
  var ?on_exit:Pair<Entity, CollisionData>->Void;
}
