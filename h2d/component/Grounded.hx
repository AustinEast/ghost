package h2d.component;

import echo.Shape;
import echo.data.Options;

class Grounded extends Component {
  var shape:Shape;

  public function new(options:ShapeOptions) {
    super('grounded');
    shape = Shape.get(options);
    shape.solid = false;
  }

  override function added(component) {
    super.added(component);
    owner.shapes.push(shape);
  }

  override function removed() {
    owner.remove_shape(shape);
    super.removed();
  }

  public function check():Bool return shape.collided;
}
