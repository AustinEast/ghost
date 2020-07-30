package component;

import hxmath.math.Vector2;
import ghost.Component;

class Transform extends Component {
  public var x:Float;
  public var y:Float;
  public var rotation:Float;

  public function get_position(?vector:Vector2):Vector2 {
    return vector == null ? new Vector2(x, y) : vector.set(x, y);
  }
}
