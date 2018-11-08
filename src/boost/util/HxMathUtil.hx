package boost.util;

import hxmath.math.Vector2;

class HxMathUtil {
  /**
   * Creates a new `Point` instance from a `Vector2` instance.
   * @param v `Vector2` to clone into a `Point`.
   * @param p Optional `Point`. This will be editted in place of creating a new `Point`.
   * @return new `Point`
   */
  public static function vec2_to_point(v:Vector2, ?p:h2d.col.Point):h2d.col.Point {
    if (p == null) p = new h2d.col.Point();
    p.set(v.x, v.y);
    return p;
  }
}
