package ghost.debug.plugins;

import ghost.util.Color;
import h2d.Text;
import h2d.Graphics;
import ghost.ui.CheckBox;
import echo.util.Debug;

using ghost.ext.ObjectExt;

class EntityDrawer extends Plugin {
  public var drawer:Graphics;

  var entities_text:Text;

  public function new() {
    super('entities');
    drawer = new Graphics(canvas);
    base.layout = Vertical;
    entities_text = base.add_text('Entities: ');
  }

  override public function refresh() {
    super.refresh();
    drawer.clear();
    debugger.game.entities.for_each(e -> {
      drawer.beginFill(Color.BLACK);
      drawer.drawCircle(e.x + 0.2, e.y + 0.2, 1, 8);
      drawer.setColor(Color.WHITE);
      drawer.drawCircle(e.x, e.y, 1, 8);
    });
    drawer.endFill();
    entities_text.text = 'Entities: ${debugger.game.entities.members.length}';
  }

  override function hide() {
    super.hide();
    drawer.clear();
  }
}
