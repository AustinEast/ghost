package g2d.component;

import echo.Shape;
import ecs.component.Component;

class Collider extends Component {
  /**
   * The `Shape` of the `Collider`.
   */
  public var shape:Shape;

  public function new(options:ShapeOptions) {
    this.shape = Shape.get(options);
  }
}
