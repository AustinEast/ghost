package h2d.ghost;

import hxd.GM;
import h2d.col.Point;

class Camera extends Layers {
  public var dx:Float;
  public var dy:Float;
  public var target:Entity;
  public var min:Point;
  public var max:Point;

  public function new() {
    super();
    dx = GM.width * 0.5;
    dy = GM.height * 0.5;
  }

  override function sync(ctx:RenderContext) {
    if (target != null) {
      dx = target.x - GM.width * 0.5;
      dy = target.y - GM.height * 0.5;
    }
    if (min != null) {
      if (dx < min.x) dx = min.x;
      if (dy < min.y) dy = min.y;
    }
    if (max != null) {
      if (dx > max.x - GM.width) dx = max.x - GM.width;
      if (dy > max.y - GM.height) dy = max.y - GM.height;
    }
    x = -dx;
    y = -dy;
    super.sync(ctx);
  }
}
