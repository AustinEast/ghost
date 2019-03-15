package h2d.ghost;

import h2d.Entity;
import h2d.data.Options;
import h2d.component.Graphic;

class Sprite extends Entity {
  public var graphic:Graphic;

  public function new(?options:SpriteOptions) {
    super(options);
    graphic = new Graphic(options.graphic);
    components.add(graphic);
  }
}
