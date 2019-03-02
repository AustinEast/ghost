package g2d;

import echo.data.Options;
import h2d.Object;
import echo.Body;

class Body extends Object {
  public var body:echo.Body;

  public function new(?parent:Object, ?options:BodyOptions) {
    super(parent);
    body = new echo.Body(options);
  }

  override function set_x(v:Float):Float {
    body.x = absX return super.set_x(v);
  }
}
