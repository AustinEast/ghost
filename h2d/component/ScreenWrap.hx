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
    if (owner.base.x > GM.width + width) owner.base.x = -width;
    if (owner.base.x < -width) owner.base.x = GM.width + width;
    if (owner.base.y > GM.height + height) owner.base.y = -height;
    if (owner.base.y < -height) owner.base.y = GM.height + height;
  }
}
