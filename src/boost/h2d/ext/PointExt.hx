package boost.h2d.ext;

import hxmath.math.Vector2;
import h2d.col.Point;

class PointExt {
  /**
   * Creates a new `Vector2` instance from a `Point` instance.
   * @param v `Point` to clone into a `Vector2`.
   * @param p Optional `Vector2`. This will be editted in place of creating a new `Vector2`.
   * @return new `Vector2`
   */
  public static function to_vector2(p:Point, ?v:Vector2):Vector2 {
    v == null ? return new Vector2(p.x, p.y) : return v.set(p.x, p.y);
  }
  /**
   * Sets a `Points` components from a `Vector2` instance.
   * @param p `Point` to set.
   * @param v `Vector2` to copy from.
   * @return editted `Point`
   */
  public static function from_vector2(p:Point, v:Vector2):Point {
    p.set(v.x, v.y);
    return p;
  }
}
