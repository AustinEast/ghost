package entities;

import h2d.data.Options;
import h2d.ghost.Sprite;

class Trash extends Sprite {
  var options:SpriteOptions = {
    drag_x: 20,
    shape: {
      type: RECT,
      width: 8,
      height: 8
    },
    graphic: {
      asset: hxd.Res.img.trash,
    }
  };

  public function new() {
    super(options);
    data.trash = true;
  }
}
