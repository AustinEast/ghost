package h2d.ghost;

import hxd.Res;
import echo.data.Options.BodyOptions;
import h2d.Entity;
import h2d.Bitmap;
import h2d.component.Body;

class Sprite extends Entity {
  public var body:Body;

  public function new(?body_options:BodyOptions) {
    super(new Bitmap(Res.images.ghostlg.toTile()));
    body = new Body(body_options);
    add(body);
  }
}
