package boost.h2d.geom;

import boost.sys.ds.Pool;
import hxmath.math.MathUtil;
import hxmath.math.Vector2;

using boost.h2d.Collisions;

typedef RectType = {
  x:Float,
  y:Float,
  width:Float,
  height:Float
}

class Rect extends Shape implements IPooled {
  public static var pool(get, never):IPool<Rect>;
  static var _pool = new Pool<Rect>(Rect);

  public var width(get, set):Float;
  public var height(get, set):Float;
  public var min(get, null):Vector2;
  public var max(get, null):Vector2;
  public var size:Vector2;
  public var pooled:Bool;

  public static inline function get(x:Float = 0, y:Float = 0, width:Float = 1, height:Float = 1):Rect {
    var rect = _pool.get();
    rect.set(x, y, width, height);
    rect.pooled = false;
    return rect;
  }

  public static function get_from_vectors(a:Vector2, b:Vector2):Rect {
    var rect = _pool.get();
    rect.set(Math.min(a.x, b.x), Math.min(a.y, b.y), Math.abs(b.x - a.x), Math.abs(b.y - a.y));
    rect.pooled = false;
    return rect;
  }

  function new(x:Float = 0, y:Float = 0, width:Float = 1, height:Float = 1) {
    super(x, y);
    size = new Vector2(width, height);
  }

  public inline function put() {
    if (!pooled) {
      pooled = true;
      _pool.putUnsafe(this);
    }
  }

  public inline function set(x:Float = 0, y:Float = 0, width:Float = 1, height:Float = 1):Rect {
    position.set(x, y);
    size.set(width, height);
    return this;
  }

  public inline function load(rect:Rect):Rect {
    position.set(rect.x, rect.y);
    size.set(rect.width, rect.height);
    return this;
  }

  public function destroy() {
    position = null;
    size = null;
  }

  override inline function contains(p:Vector2):Bool return this.rect_contains(p);

  override inline function intersects(l:Line):Null<Intersection> return this.rect_intersects(l);

  override inline function overlaps(s:Shape):Bool return collides(s) != null;

  override inline function collides(s:Shape):Null<Collision> return s.collide_rect(this);

  override inline function collide_rect(r:Rect):Null<Collision> return r.rect_and_rect(this);

  override inline function collide_circle(c:Circle):Null<Collision> return c.circle_and_rect(this);

  // getters
  static function get_pool():IPool<Rect> return _pool;

  function get_width():Float return size.x;

  function get_height():Float return size.y;

  function get_min():Vector2 return new Vector2(Math.min(x, x + width), Math.min(y, y + height));

  function get_max():Vector2 return new Vector2(Math.max(x, x + width), Math.max(y, y + height));

  // getters
  function set_width(value:Float):Float return size.x = value;

  function set_height(value:Float):Float return size.y = value;
}
