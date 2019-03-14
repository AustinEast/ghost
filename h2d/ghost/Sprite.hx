package h2d.ghost;

import h2d.Entity;
import h2d.data.Options;
import h2d.component.Body;
import h2d.component.Graphic;

class Sprite extends Entity {
  public var graphic:Graphic;
  public var body:Body;

  public function new(?options:SpriteOptions) {
    super();
    body = new Body(options.body);
    graphic = new Graphic(options.graphic);
    add(body);
    add(graphic);
  }
}
