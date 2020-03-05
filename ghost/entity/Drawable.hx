package ghost.entity;

import ghost.Entity.EntityOptions;

class Drawable extends Entity {
  public var canvas:h2d.Graphics;

  public function new(?options:EntityOptions) {
    super(options);
    canvas = new h2d.Graphics(display);
  }

  override function dispose() {
    super.dispose();
    canvas.remove();
    canvas = null;
  }
}
