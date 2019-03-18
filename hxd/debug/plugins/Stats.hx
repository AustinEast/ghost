package hxd.debug.plugins;

import h2d.Tile;
import hxd.res.DefaultFont;
import ghost.Color;
import h2d.Object;
import h2d.Text;

class Stats extends Plugin {
  var fps:Text;
  var width:Text;
  var height:Text;

  public function new() {
    super("stats", Tile.fromColor(0xfff));
    base.layout = Vertical;
    var font = DefaultFont.get();
    var padding = 4;
    fps = new Text(font, base);
    fps.dropShadow = {
      dx: 1,
      dy: 1,
      color: Color.BLACK,
      alpha: 1
    };
    width = new Text(font, base);
    width.y = fps.y + font.lineHeight + padding;
    width.dropShadow = {
      dx: 1,
      dy: 1,
      color: Color.BLACK,
      alpha: 1
    };
    height = new Text(font, base);
    height.y = width.y + font.lineHeight + padding;
    height.dropShadow = {
      dx: 1,
      dy: 1,
      color: Color.BLACK,
      alpha: 1
    };
  }

  override public function update() {
    super.update();
    fps.text = 'FPS: ${GM.render_framerate}';
    width.text = 'Width: ${GM.engine.width}';
    height.text = 'Height: ${GM.engine.height}';
  }
}
