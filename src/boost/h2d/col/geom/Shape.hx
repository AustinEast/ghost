package boost.h2d.col.geom;

import hxmath.math.Vector2;

class Shape {
  public var x(get, set):Float;
  public var y(get, set):Float;
  public var position:Vector2;

  // TODO: Static methods that recycle shapes from the pool
  public static function rect() {}

  public static function square() {}

  public static function circle() {}

  public function new(x:Float = 0, y:Float = 0) {
    position = new Vector2(x, y);
  }

  public function contains(v:Vector2):Bool return position == v;

  public function intersects(l:Line):Bool return l.contains(position);

  // getters
  function get_x():Float return position.x;

  function get_y():Float return position.y;

  // getters
  function set_x(value:Float):Float return position.x = value;

  function set_y(value:Float):Float return position.y = value;
}
