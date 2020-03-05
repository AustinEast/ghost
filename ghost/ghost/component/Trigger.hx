package ghost.component;

import echo.Shape;
import echo.data.Options;
/**
 * The Trigger Component adds a non-solid Shape collider to an Entity, providing a quick way to see if other colliders are in a specific volume.
 */
class Trigger extends Component {
  var shape:Shape;

  public function new(options:ShapeOptions) {
    shape = Shape.get(options);
    shape.solid = false;
  }

  public inline function check():Bool return shape.collided;

  override function added(component) {
    super.added(component);
    if (entity.body == null) entity.add_body();
    entity.body.shapes.push(shape);
    shape.set_parent(entity.body.frame);
  }

  override function removed() {
    if (entity.body != null) entity.body.remove_shape(shape);
    super.removed();
  }
}
