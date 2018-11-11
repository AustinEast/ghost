package boost.h2d;

import hxmath.math.MathUtil;
import hxmath.math.Vector2;
import boost.h2d.geom.*;

class Collisions {
  public static inline function point_in_rect(p:Vector2, r:Rect):Bool {
    return MathUtil.closedRangeContains(r.x, r.width, p.x) && MathUtil.closedRangeContains(r.y, r.height, p.y);
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
    return null
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

  public static function rect_and_rect(r1:Rect, r2:Rect):Null<Collision> {
    return null;
  }

  public static function rect_and_circle(r:Rect, s:Circle):Null<Collision> {
    return null;
  }

  public static function circle_and_circle(s1:Circle, s2:Circle):Null<Collision> {
    return null;
  }

  public static function circle_and_rect(s:Circle, r:Rect):Null<Collision> {
    return null;
  }
}

abstract Collision(CollisionData) {}

abstract Intersection(IntersectionData) {}

typedef CollisionData = {}

typedef IntersectionData = {}
