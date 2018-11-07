package boost.util.debug;

import hxd.res.DefaultFont;
import boost.util.Color;
import h2d.Object;
import h2d.Text;

class Stats extends Object {
  var fps:Text;
  var width:Text;
  var height:Text;

  public function new(?parent:Object) {
    super(parent);
    var font = DefaultFont.get();
    var padding = 4;
    fps = new Text(font, this);
    fps.dropShadow = {
      dx: 1,
      dy: 1,
      color: Color.BLACK,
      alpha: 1
    };
    width = new Text(font, this);
    width.y = fps.y + font.lineHeight + padding;
    width.dropShadow = {
      dx: 1,
      dy: 1,
      color: Color.BLACK,
      alpha: 1
    };
    height = new Text(font, this);
    height.y = width.y + font.lineHeight + padding;
    height.dropShadow = {
      dx: 1,
      dy: 1,
      color: Color.BLACK,
      alpha: 1
    };
  }

  public function update(dt:Float) {
    fps.text = 'FPS: {GM.game.engine.fps}';
    width.text = 'Width: {GM.game.engine.width}';
    height.text = 'Height: {GM.game.engine.height}';
  }
}
