package entities;

import h2d.data.Options;
import h2d.ghost.Sprite;

class BoxLg extends Sprite {
  var options:SpriteOptions = {
    drag_x: 20,
    mass: 2,
    shape: {
      type: RECT,
      width: 16,
      height: 16
    },
    graphic: {
      asset: hxd.Res.img.boxlg,
    }
  };

  public function new() {
    super(options);
  }
}
