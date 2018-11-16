package boost.h2d;

import hxmath.math.Vector2;
import boost.h2d.geom.*;

using hxmath.math.MathUtil;

class Collisions {
  public static inline function point_in_rect(p:Vector2, r:Rect):Bool {
    return r.left <= p.x && r.right >= p.x && r.top <= p.x && r.bottom >= p.y;
  }

  public static inline function point_in_circle(p:Vector2, c:Circle):Bool {
    return p.distanceTo(c.position) < c.radius;
  }

  public static inline function rect_contains(r:Rect, p:Vector2):Bool {
    return point_in_rect(p, r);
  }

  public static inline function circle_contains(c:Circle, p:Vector2):Bool {
    return point_in_circle(p, c);
  }

  public static inline function line_interects_rect(l:Line, r:Rect):Null<Intersection> {
    return null;
  }

  public static inline function line_intersects_circle(l:Line, c:Circle):Null<Intersection> {
    return null;
  }

  public static inline function rect_intersects(r:Rect, l:Line):Null<Intersection> {
    return line_interects_rect(l, r);
  }

  public static inline function circle_intersects(c:Circle, l:Line):Null<Intersection> {
    return line_intersects_circle(l, c);
  }

  public static function rect_and_rect(rect1:Rect, rect2:Rect, flip:Bool = false):Null<Collision> {
    var s1 = flip ? rect2 : rect1;
    var s2 = flip ? rect1 : rect2;

    // Vector from A to B
    var n = s2.position - s1.position;
    // Calculate overlap on x axis
    var x_overlap = s1.width + s2.width - Math.abs(n.x);
    // SAT test on x axis
    if (x_overlap > 0) {
      // Calculate overlap on y axis
      var y_overlap = s1.height + s2.height - Math.abs(n.y);
      // SAT test on y axis.
      // If both axis overlap, the boxes are colliding
      if (y_overlap > 0) {
        var col:Collision = {
          shape1: s1,
          shape2: s2
        };
        // Find out which axis is axis of least penetration
        if (x_overlap < y_overlap) {
          // Point towards B knowing that n points from A to B
          if (n.x < 0) col.normal = new Vector2(-1, 0); else col.normal = new Vector2(0, 0);
          col.overlap = x_overlap;
          return col;
        } else {
          // Point toward B knowing that n points from A to B
          if (n.y < 0) col.normal = new Vector2(0, -1); else col.normal = new Vector2(0, 1);
          col.overlap = y_overlap;
          return col;
        }
      }
    }

    return null;
  }

  public static function circle_and_circle(circle1:Circle, circle2:Circle, flip:Bool = false):Null<Collision> {
    var s1 = flip ? circle2 : circle1;
    var s2 = flip ? circle1 : circle2;

    // Vector2 from s2 to s1
    var n = s2.position - s1.position;
    // Squared radii of circles
    var r = s1.radius + s2.radius;
    r *= r;

    // Do quick check if circles are colliding
    if (n.lengthSq > r) return null;

    // Get actual square root
    var d = n.length;

    var col:Collision = {
      shape1: s1,
      shape2: s2
    };

    if (d != 0) {
      // Distance is difference between radius and distance
      col.overlap = r - d;
      col.normal = n / d;
      return col;
    } else {
      // If distance between circles is zero, make up a number
      col.overlap = s1.radius;
      col.normal = new Vector2(1, 0);
      return col;
    }
  }

  public static function rect_and_circle(r:Rect, c:Circle, flip:Bool = false):Null<Collision> {
    // Vector from A to B
    var n = c.position - r.position;
    // Closest point on A to center of B
    var closest = n.clone();
    var ex = r.width;
    var ey = r.height;
    // Clamp point to edges of the AABB
    closest.x = closest.x.clamp(-ex, ex);
    closest.y = closest.y.clamp(-ey, ey);
    var inside = false;

    // Circle is inside the AABB, so we need to clamp the circle's center
    // to the closest edge
    if (n == closest) {
      inside = true;
      // Find closest axis
      if (Math.abs(n.x) > Math.abs(n.y)) {
        // Clamp to closest extent
        closest.x = closest.x > 0 ? ex : -ex;
      } else {
        // Clamp to closest extent
        closest.y = closest.y > 0 ? ey : -ey;
      }
    }

    var normal = n - closest;
    var d = normal.lengthSq;
    var rad = c.radius;

    // Early out of the radius is shorter than distance to closest point and
    // Circle not inside the AABB
    if (d > rad * rad && !inside) return null;

    var col:Collision = {
      shape1: flip ? c : r,
      shape2: flip ? r : c
    }

    // Avoided sqrt until we needed
    d = Math.sqrt(d);

    // Collision normal needs to be flipped to point outside if circle was
    // inside the AABB
    col.normal = flip && inside ? -n : n;
    col.overlap = rad - d;
    return col;
  }
}

typedef Collision = {
  /**
   * The first shape in the Collision.
   */
  shape1:Shape,
  /**
   * The second shape in the Collision.
   */
  shape2:Shape,
  /**
   * The length of shape1's penetration into shape2.
   */
  ?overlap:Float,
  /**
   * The normal vector (direction) of shape1's penetration into shape2.
   */
  ?normal:Vector2,
}

typedef Intersection = {}
