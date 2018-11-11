package boost.h2d.geom;

import boost.sys.ds.Pool;
import hxmath.math.Vector2;

using boost.h2d.Collisions;

typedef CircleType = {
  x:Float,
  y:Float,
  radius:Float
}

class Circle extends Shape implements IPooled {
  public static var pool(get, never):IPool<Circle>;
  static var _pool = new Pool<Circle>(Circle);

  public var radius:Float;
  public var pooled:Bool;

  public static inline function get(x:Float = 0, y:Float = 0, radius:Float = 1):Circle {
    var circle = _pool.get();
    circle.set(x, y, radius);
    circle.pooled = false;
    return circle;
  }

  function new(x:Float = 0, y:Float = 0, radius:Float = 1) {
    super(x, y);
    this.radius = radius;
  }

  public inline function put() {
    if (!pooled) {
      pooled = true;
      _pool.putUnsafe(this);
    }
  }

  public inline function set(x:Float = 0, y:Float = 0, radius:Float = 1):Circle {
    position.set(x, y);
    this.radius = radius;
    return this;
  }

  public inline function load(circle:Circle):Circle {
    return set(circle.x, circle.y, circle.radius);
  }

  public inline function to_rect():Rect {
    return Rect.get(x, y, radius * 2, radius * 2);
  }

  public function destroy() {
    position = null;
  }

  override function contains(v:Vector2):Bool return this.circle_contains(v);

  override function intersects(l:Line):Null<Intersection> return this.circle_intersects(l);

  override inline function overlaps(s:Shape):Bool return collides(s) != null;

  override inline function collides(s:Shape):Null<Collision> return s.collide_circle(this);

  override inline function collide_rect(r:Rect):Null<Collision> return r.rect_and_circle(this);

  override inline function collide_circle(c:Circle):Null<Collision> return c.circle_and_circle(this);

  // getters
  static function get_pool():IPool<Circle> return _pool;
}
