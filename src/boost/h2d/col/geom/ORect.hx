package boost.h2d.col.geom;

import hxmath.math.Matrix2x2;
import hxmath.math.Vector2;

using hxd.Math;
using hxmath.math.MathUtil;

typedef ORectType = {
  x:Float,
  y:Float,
  dx:Float,
  dy:Float
}

class ORect extends Shape {
  public var rotation:Float;
  public var dx(get, set):Float;
  public var dy(get, set):Float;
  public var extents:Vector2;

  public function new(x:Float = 0, y:Float = 0, dx:Float = 1, dy:Float = 1, rotation:Float = 0) {
    super(x, y);
    extents = new Vector2(dx, dy);
    this.rotation = rotation;
  }

  // May not work.. needs testing
  override function contains(v:Vector2):Bool {
    var rotVector:Vector2 = v - position;
    var theta:Float = -rotation.degToRad();
    var rotMatrix:Matrix2x2 = new Matrix2x2(theta.cos(), theta.sin(), -theta.sin(), theta.cos());
    var p = (rotMatrix * rotVector) + extents;
    var r = new Rect(0, 0, dx * 2, dy * 2);
    return r.contains(p);
  }

  // getters
  function get_dx():Float return extents.x;

  function get_dy():Float return extents.y;

  // setters
  function set_dx(value:Float):Float return extents.x = value;

  function set_dy(value:Float):Float return extents.y = value;
}
