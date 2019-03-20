package hxd.debug.plugins;

import h2d.GameState;
import h2d.ui.CheckBox;
import echo.util.Debug;

class EchoDrawer extends Plugin {
  public var drawer:HeapsDebug;

  var state:GameState;
  var bodies_checkbox:CheckBox;
  var quadtree_checkbox:CheckBox;

  public function new(state:GameState) {
    super("echo");
    this.state = state;
    drawer = new HeapsDebug(canvas);
    base.layout = Vertical;
    bodies_checkbox = new CheckBox("Show Bodies", (v) -> drawer.draw_bodies = v, base);
    bodies_checkbox.toggle();
    quadtree_checkbox = new CheckBox("Show Quadtree", (v) -> drawer.draw_quadtree = v, base);
    quadtree_checkbox.toggle();
  }

  override public function update() {
    super.update();
    drawer.canvas.setPosition(state.camera.x, state.camera.y);
    drawer.draw(state.world);
  }

  override function hide() {
    super.hide();
    drawer.clear();
  }

  public function toggle_bodies() drawer.draw_bodies = !drawer.draw_bodies;

  public function toggle_quadtree() drawer.draw_quadtree = !drawer.draw_quadtree;
}
