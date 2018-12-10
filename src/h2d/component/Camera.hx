package h2d.component;

import hxmath.math.Vector2;
import h2d.col.Bounds;
import ecs.component.Component;

class Camera extends Component {
  /**
   * The x position within the viewport
   */
  public var x:Int;
  /**
   * The y position within the viewport
   */
  public var y:Int;
  public var scroll:Vector2;
  public var width:Float;
  public var height:Float;
  public var bounds:Bounds
}
