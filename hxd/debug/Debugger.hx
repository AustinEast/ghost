package hxd.debug;

import h2d.Flow;
import h2d.Object;
import h2d.Tile;

class Debugger {
  public var active:Bool;

  var base:Flow;

  public var canvas:Object;
  public var panels:Object;
  public var menu:Flow;

  var icons:Flow;
  var game:Game;
  var plugins:Map<String, Plugin>;

  public function new(game:Game) {
    active = false;
    plugins = [];
    canvas = new Object(game.root2d);
    base = new Flow(game.debug);
    base.layout = Vertical;
    menu = new Flow(base);
    menu.minWidth = game.s2d.width;
    menu.padding = 4;
    menu.backgroundTile = Tile.fromColor(0x000000, 1, 1, 0.5);
    menu.horizontalAlign = Right;
    menu.verticalAlign = Middle;
    icons = new Flow(menu);
    panels = new Object(base);
    this.game = game;
    hide();
  }

  public function update() {
    if (Key.isPressed(Key.QWERTY_TILDE)) active ? hide() : show();
    for (plugin in plugins) if (plugin.active) plugin.update();
  }

  public function add(plugin:Plugin) {
    if (plugins.exists(plugin.name)) throw '${plugin.name} Plugin already exists in the Debugger';
    plugins.set(plugin.name, plugin);
    plugin.attach(this);
    icons.addChild(plugin.icon);
  }

  public function remove(plugin:Plugin) {
    plugins.remove(plugin.name);
    plugin.remove();
  }

  public inline function has(name:String):Bool return plugins.exists(name);

  public inline function get(name:String):Null<Plugin> return plugins.get(name);

  public function show() {
    active = true;
    menu.visible = true;
    base.needReflow = true;
  }

  public function hide() {
    active = false;
    menu.visible = false;
  }

  public function resize() {
    menu.minWidth = game.s2d.width;
  }
}
