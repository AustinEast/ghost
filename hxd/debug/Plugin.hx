package hxd.debug;

import h2d.Text;
import h2d.ui.Button;
import h2d.Object;
import h2d.Tile;
import h2d.Flow;

class Plugin {
  public var name:String;
  // temp, display text until i figure out asset loading from external libraries ;p
  public var icon:Button; // BitmapButton;?
  public var active:Bool;

  var debugger:Debugger;
  var canvas:Object;
  var panel:Flow;
  var header:Flow;
  var base:Flow;
  var dragging:Bool;

  public function new(name:String, icon:Tile) {
    this.name = name;
    // this.icon = new Bitmap(icon);
    this.icon = new Button(name, () -> active ? hide() : show());
    this.icon.scale(2);
    active = false;
    dragging = false;
    canvas = new Object();
    canvas.visible = false;
    panel = new Flow();
    panel.layout = Vertical;
    panel.visible = false;
    panel.scale(2);
    header = new Flow(panel);
    header.enableInteractive = true;
    header.interactive.onPush = function(_) dragging = true;
    header.interactive.onRelease = function(_) dragging = false;
    header.padding = 2;
    header.verticalAlign = Middle;
    header.backgroundTile = Tile.fromColor(0x000000, 1, 1, 0.7);
    var t = new Text(hxd.res.DefaultFont.get(), header);
    t.text = name;
    base = new Flow(panel);
    base.padding = 2;
    base.backgroundTile = Tile.fromColor(0x000000, 1, 1, 0.2);
  }

  public function attach(debugger:Debugger) {
    this.debugger = debugger;
    debugger.canvas.addChild(canvas);
    debugger.panels.addChild(panel);
  }

  public function remove() {
    hide();
    canvas.remove();
    panel.remove();
    icon.remove();
    debugger = null;
  }

  public function update() {
    header.minWidth = base.outerWidth;
    if (dragging) {
      panel.setPosition(Math.clamp(GM.game.s2d.mouseX - 24, 0, GM.game.s2d.width - panel.outerWidth),
        Math.clamp(GM.game.s2d.mouseY - (debugger.menu.visible ? debugger.menu.outerHeight : 0) - 24, 0, GM.game.s2d.height - header.outerHeight));
    }
  }

  public function show() {
    active = true;
    canvas.visible = true;
    panel.visible = true;
    panel.needReflow = true;
  }

  public function hide() {
    active = false;
    canvas.visible = false;
    panel.visible = false;
  }
}
