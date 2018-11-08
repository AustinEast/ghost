package boost.h2d.col.geom;

import hxmath.math.Vector2;

typedef CircleType = {
  x:Float,
  y:Float,
  radius:Float
}

class Circle extends Shape {
  public var radius:Float;

  public function new(x:Float = 0, y:Float = 0, radius:Float = 1) {
    super(x, y);
    this.radius = radius;
  }

  override function contains(v:Vector2):Bool return position.distanceTo(v) < radius;
}
