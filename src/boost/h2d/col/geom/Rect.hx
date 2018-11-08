package boost.h2d.col.geom;

import hxmath.math.MathUtil;
import hxmath.math.Vector2;

typedef RectType = {
  x:Float,
  y:Float,
  width:Float,
  height:Float
}

class Rect extends Shape {
  public var width(get, set):Float;
  public var height(get, set):Float;
  public var min(get, null):Vector2;
  public var max(get, null):Vector2;
  public var size:Vector2;

  public static function from_vectors(a:Vector2, b:Vector2):Rect {
    return new Rect(Math.min(a.x, b.x), Math.min(a.y, b.y), Math.abs(b.x - a.x), Math.abs(b.y - a.y));
  }

  public function new(x:Float = 0, y:Float = 0, width:Float = 1, height:Float = 1) {
    super(x, y);
    size = new Vector2(width, height);
  }

  override function contains(v:Vector2):Bool {
    return MathUtil.closedRangeContains(x, width, v.x) && MathUtil.closedRangeContains(y, height, v.y);
  }

  // getters
  function get_width():Float return size.x;

  function get_height():Float return size.y;

  function get_min():Vector2 return new Vector2(Math.min(x, x + width), Math.min(y, y + height));

  function get_max():Vector2 return new Vector2(Math.max(x, x + width), Math.max(y, y + height));

  // getters
  function set_width(value:Float):Float return size.x = value;

  function set_height(value:Float):Float return size.y = value;
}
