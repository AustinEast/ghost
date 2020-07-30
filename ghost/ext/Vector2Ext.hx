package ghost.ext;

import hxmath.math.Vector2;

using echo.util.Ext;

class Vector2Ext {
  /**
   * Checks if a `Vector2`'s components are equal to another `Vector2`, within the margin of error defined by the `diff` argument.
   * @param a The first `Vector2` to check.
   * @param b The second `Vector2` to check.
   * @param diff The margin of error to check by.
   * @return Returns true if the `Vector2`s are both equal (within the defined margin of error).
   */
  public static inline function equals(a:Vector2, b:Vector2, diff:Float = 0.00001):Bool return a.x.equals(b.x, diff) && a.y.equals(b.y, diff);
  /**
   * Checks if a `Vector2`'s components are equal to 0, within the margin of error defined by the `diff` argument.
   * @param v The `Vector2` to check.
   * @param diff The margin of error to check by.
   * @return Returns true if the `Vector2`'s components are both equal to 0 (within the defined margin of error).
   */
  public static inline function is_zero(v:Vector2, diff:Float = 0.00001):Bool return v.x.equals(0, diff) && v.y.equals(0, diff);
  /**
   * Checks if a `Vector2`'s components are equal to 1, within the margin of error defined by the `diff` argument.
   * @param v The `Vector2` to check.
   * @param diff The margin of error to check by.
   * @return Returns true if the `Vector2`'s components are both equal to 1 (within the defined margin of error).
   */
  public static inline function is_one(v:Vector2, diff:Float = 0.00001):Bool return v.x.equals(1, diff) && v.y.equals(1, diff);
  #if heaps
  /**
   * Creates a new `Point` instance from a `Vector2` instance.
   * @param v `Vector2` to clone into a `Point`.
   * @param p Optional `Point`. This will be set in place of creating a new `Point`.
   * @return new `Point`
   */
  public static inline function to_point(v:Vector2, ?p:h2d.col.Point):h2d.col.Point {
    if (p == null) p = new h2d.col.Point();
    p.set(v.x, v.y);
    return p;
  }
  #end
}
