package entities;

import h2d.data.Options;
import h2d.ghost.Sprite;

class BoxLg extends Sprite {
  var options:SpriteOptions = {
    body: {
      drag_x: 10,
      mass: 2,
      shape: {
        type: RECT,
        width: 16,
        height: 16
      }
    },
    graphic: {
      asset: hxd.Res.images.boxlg,
    }
  };

  public function new(x:Float, y:Float) {
    super(options);
    body.position.set(x, y);
  }
}
