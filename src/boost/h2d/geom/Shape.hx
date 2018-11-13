package boost.h2d.geom;

import h2d.Graphics;
import hxmath.math.Vector2;

using boost.h2d.Collisions;

class Shape {
  public var x(get, set):Float;
  public var y(get, set):Float;
  public var position:Vector2;
  public var top(get, null):Float;
  public var bottom(get, null):Float;
  public var left(get, null):Float;
  public var right(get, null):Float;

  public static inline function rect(?x:Float, ?y:Float, ?width:Float, ?height:Float) return Rect.get(x, y, width, height);

  public static inline function square(?x:Float, ?y:Float, ?width:Float) return Rect.get(x, y, width, width);

  public static inline function circle(?x:Float, ?y:Float, ?radius:Float) return Circle.get(x, y, radius);

  public static inline function rect_from_circle(c:Circle):Rect return c.to_rect();

  public function new(x:Float = 0, y:Float = 0) position = new Vector2(x, y);

  public function draw_debug(dg:Graphics):Void dg.drawRect(x, y, 1, 1);

  public function scale(v:Float) {}

  public function contains(v:Vector2):Bool return position == v;

  public function intersects(l:Line):Null<Intersection> return null;

  public function overlaps(s:Shape):Bool return contains(s.position);

  public function collides(s:Shape):Null<Collision> return null;

  function collide_rect(r:Rect):Null<Collision> return null;

  function collide_circle(c:Circle):Null<Collision> return null;

  // getters
  function get_x():Float return position.x;

  function get_y():Float return position.y;

  function get_top():Float return position.y;

  function get_bottom():Float return position.y;

  function get_left():Float return position.x;

  function get_right():Float return position.x;

  // setters
  function set_x(value:Float):Float return position.x = value;

  function set_y(value:Float):Float return position.y = value;
}
