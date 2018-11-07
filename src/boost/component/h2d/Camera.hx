package boost.component.h2d;

import h2d.col.Bounds;
import h2d.col.Point;
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
  public var scroll:Point;
  public var width:Float;
  public var height:Float;
  public var bounds:Bounds
}
