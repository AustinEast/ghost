package ghost.h3d.component;

import h3d.col.Point;
import ecs.component.Component;
/**
 * TODO
 */
class Transform extends Component {
  public var position(default, null):Point;
  public var rotation(default, null):Point;
  public var scale(default, null):Point;

  public function new(?position:Point, ?rotation:Point, ?scale:Point) {
    this.position = position == null ? new Point() : position;
    this.rotation = rotation == null ? new Point() : rotation;
    this.scale = scale == null ? new Point() : scale;
  }
}
