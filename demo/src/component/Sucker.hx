package component;

import echo.Shape;
import echo.data.Options;
import ghost.Component;

class Sucker extends Component {
  public var active:Bool;
  public var facing(default, set):Bool;
  public var min_distance:Float = 6;
  public var max_distance:Float = 40;
  public var shape:Shape;

  public function new(options:ShapeOptions) {
    facing = false;
    shape = Shape.get(options);
    shape.solid = false;
  }

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

  override function dispose() {
    super.dispose();
    shape.put();
  }

  inline function set_facing(value:Bool) {
    if (shape != null && value != facing) shape.local_x = -shape.local_x;
    return facing = value;
  }
}
