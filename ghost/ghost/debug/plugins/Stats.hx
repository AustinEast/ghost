package ghost.debug.plugins;

import h2d.Tile;
import h2d.Text;
import hxd.res.DefaultFont;
import ghost.util.Color;

using ghost.ext.ObjectExt;

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

  override public function refresh() {
    super.refresh();
    fps.text = 'FPS: ${debugger.game.framerate}';
    draw_count.text = 'Draw Count: ${debugger.game.engine.drawCalls}';
    width.text = 'Width: ${debugger.game.engine.width}';
    height.text = 'Height: ${debugger.game.engine.height}';
  }

  override function dispose() {
    fps.remove();
    draw_count.remove();
    width.remove();
    height.remove();
    super.dispose();
  }
}
