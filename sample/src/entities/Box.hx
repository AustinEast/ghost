package entities;

import h2d.data.Options;
import h2d.ghost.Sprite;

class Box extends Sprite {
  var options:SpriteOptions = {
    body: {
      drag_x: 10,
      shape: {
        type: RECT,
        width: 8,
        height: 8
      }
    },
    graphic: {
      asset: hxd.Res.images.box,
    }
  };

  public function new(x:Float, y:Float) {
    super(options);
    body.position.set(x, y);
  }
}
