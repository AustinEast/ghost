package hxd.debug.plugins;

import h2d.Tile;
import hxd.res.DefaultFont;
import ghost.Color;
import h2d.Text;

using h2d.ext.ObjectExt;

class Stats extends Plugin {
  var fps:Text;
  var draw_count:Text;
  var width:Text;
  var height:Text;

  public function new() {
    super("stats");
    base.layout = Vertical;
    var padding = 4;
    fps = base.add_text('', 0, 0, {
      dropShadow: {
        {
          dx: 1,
          dy: 1,
          color: Color.BLACK,
          alpha: 1
        }
      }
    });
    draw_count = base.add_text('', 0, fps.y + fps.font.lineHeight + padding, {
      dropShadow: {
        dx: 1,
        dy: 1,
        color: Color.BLACK,
        alpha: 1
      }
    });
    width = base.add_text('', 0, draw_count.y + fps.font.lineHeight + padding, {
      dropShadow: {
        dx: 1,
        dy: 1,
        color: Color.BLACK,
        alpha: 1
      }
    });
    height = base.add_text('', 0, width.y + fps.font.lineHeight + padding, {
      dropShadow: {
        dx: 1,
        dy: 1,
        color: Color.BLACK,
        alpha: 1
      }
    });
  }

  override public function update() {
    super.update();
    fps.text = 'FPS: ${GM.render_framerate}';
    draw_count.text = 'Draw Count: ${GM.engine.drawCalls}';
    width.text = 'Width: ${GM.engine.width}';
    height.text = 'Height: ${GM.engine.height}';
  }

  override function dispose() {
    fps.remove();
    draw_count.remove();
    width.remove();
    height.remove();
    super.dispose();
  }
}
