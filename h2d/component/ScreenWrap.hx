package h2d.component;

import hxd.GM;

class ScreenWrap extends Component {
  public var width:Float;
  public var height:Float;

  public function new(width:Float = 0, height:Float = 0) {
    super("screen_wrap");

    this.width = width;
    this.height = height;
  }

  override function post_step(dt:Float) {
    super.post_step(dt);
    if (entity.base.x > GM.width + width) entity.base.x = -width;
    if (entity.base.x < -width) entity.base.x = GM.width + width;
    if (entity.base.y > GM.height + height) entity.base.y = -height;
    if (entity.base.y < -height) entity.base.y = GM.height + height;
  }
}
