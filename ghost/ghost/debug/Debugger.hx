package ghost.debug;

import h2d.Scene;
import h2d.Flow;
import h2d.Object;
import h2d.Tile;

class Debugger {
  public var active:Bool;
  public var canvas:Object;
  public var panels:Object;
  public var menu:Flow;
  public var game:Game;

  var scene:Scene;
  var base:Flow;
  var icons:Flow;
  var plugins:Map<String, Plugin>;

  public function new(game:Game) {
    active = false;
    plugins = [];
    canvas = new Object(game.camera.background);
    scene = new Scene();
    game.sevents.addScene(scene, 1);
    base = new Flow(scene);
    base.layout = Vertical;
    menu = new Flow(base);
    menu.minWidth = game.s2d.width;
    menu.padding = 4;
    menu.backgroundTile = Tile.fromColor(0x000000, 1, 1, 0.5);
    menu.horizontalAlign = Right;
    menu.verticalAlign = Middle;
    icons = new Flow(menu);
    icons.horizontalSpacing = 4;
    panels = new Object(base);
    this.game = game;
    refresh();
    hide();
  }

  public function render(e:h3d.Engine) {
    scene.render(e);
  }

  public function refresh() {
    var dt = hxd.Timer.dt;
    scene.setElapsedTime(dt);
    if (hxd.Key.isPressed(hxd.Key.QWERTY_TILDE)) active ? hide() : show();
    for (plugin in plugins) if (plugin.active) plugin.refresh();
  }

  public function add(plugin:Plugin) {
    if (plugins.exists(plugin.name)) throw '${plugin.name} Plugin already exists in the Debugger';
    plugins.set(plugin.name, plugin);
    plugin.attach(this);
    icons.addChild(plugin.icon);
  }

  public function remove(plugin:Plugin) {
    plugins.remove(plugin.name);
    plugin.debugger = null;
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
    scene.checkResize();
    menu.minWidth = scene.width;
  }
}
