package entities;

import h2d.data.Options;
import h2d.ghost.Sprite;

class Box extends Sprite {
  var options:SpriteOptions = {
    drag_x: 10,
    shape: {
      type: RECT,
      width: 8,
      height: 8
    },
    graphic: {
      asset: hxd.Res.img.box,
    }
  };

  public function new() {
    super(options);
  }
}
