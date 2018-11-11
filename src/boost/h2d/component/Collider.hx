package boost.h2d.component;

import boost.h2d.geom.Shape;
import boost.util.DataUtil;
import ecs.entity.Entity;
import ecs.component.Component;

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
  public var x:Int;
  /**
   * The Y offset of the `Collider` from it's `Transform`.
   */
  public var y:Int;
  /**
   * The `Shape` of the `Collider`.
   */
  public var shape:Shape;
  /**
   * The Collision Group of the `Collider`.
   */
  public var group:String;
  /**
   *  Collision Groups the `Collider` collides with.
   */
  public var colliding_groups:Array<String>;
  /**
   * Callback Function that is triggered when this `Collider` first collides with another `Collider`.
   */
  public var on_enter:Entity->Void;
  /**
   * Callback Function that is triggered when this `Collider` collides with another `Collider` for multiple frames.
   */
  public var on_stay:Entity->Void;
  /**
   * Callback Function that is triggered when this `Collider` ends it's collision with another `Collider`.
   */
  public var on_exit:Entity->Void;

  public function new(shape:Shape, ?options:ColliderOptions) {
    options = DataUtil.copy_fields(options, defaults);
    x = options.x;
    y = options.y;
    this.shape = shape;
    solid = options.solid;
    group = options.group;
    colliding_groups = options.colliding_groups;
  }

  static function get_defaults():ColliderOptions return {
    x: 0,
    y: 0,
    solid: true,
    group: 'Default',
    colliding_groups: ['Default']
  }
}

typedef ColliderOptions = {
  ?x:Int,
  ?y:Int,
  ?solid:Bool,
  ?group:String,
  ?colliding_groups:Array<String>
}
