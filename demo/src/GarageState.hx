package;

import h2d.ghost.Sprite;
import hxd.Key;
import echo.Group;
import ghost.Random;
import hxd.GM;
import h2d.GameState;
import h2d.ghost.TileMap;
import h2d.col.Point;
import hxd.debug.plugins.EchoDrawer;
import hxd.tools.OgmoLoader;
import entities.*;

class GarageState extends GameState {
  var hero:Hero;
  var powerups:Int;
  var map:TileMap;
  var colliders:Group;
  var level:OgmoLoader;
  #if debug
  var echo_drawer:EchoDrawer;
  #end

  public function new() {
    super({width: GM.width * 2, height: GM.height * 2, gravity_y: 180});
  }

  override public function create() {
    super.create();
    colliders = new Group();
    level = new OgmoLoader(hxd.Res.dat.garage.entry.getText());

    map = level.load_tilemap(hxd.Res.img.test_tile.toTile(), 16, 16, 'Collision');

    level.load_entities((entity) -> {
      var s:h2d.ghost.Sprite;
      switch (entity.name.toLowerCase()) {
        case 'player':
          hero = new Hero();
          s = hero;
        case 'boxsm':
          s = new Box();
        case 'boxlg':
          s = new BoxLg();
        default:
          s = new Sprite();
      }
      var b = s.bounds();
      s.x += entity.x + b.width * 0.5;
      s.y += entity.y + b.height * 0.5;
      b.put();
      s.refresh_cache();
      add(s);
      colliders.add(s);
    }, 'Entities');

    add(map);

    camera.target = hero;
    camera.min = new Point(0, 0);
    camera.max = new Point(level.width, level.height);

    world.listen(colliders, map.collider);
    world.listen(colliders);

    world.width = map.width;
    world.height = map.height;

    #if debug
    echo_drawer = new EchoDrawer(this);
    GM.debugger.add(echo_drawer);
    #end
  }

  override function step(dt:Float) {
    super.step(dt);
    world.for_each_dynamic((entity) -> {
      if (entity == hero) return;
      if (hero.sucking) {
        var eb = entity.bounds();
        if (!hero.facing) {
          if (eb.left > hero.x + 6 && eb.left < hero.x + 40) entity.acceleration.x -= 20;
        }
        else {
          if (eb.right < hero.x - 6 && eb.right > hero.x - 40) entity.acceleration.x += 20;
        }
        eb.put();
      }
    });
    if (Key.isReleased(Key.K)) close();
  }

  override function dispose() {
    super.dispose();
    #if debug
    echo_drawer.remove();
    #end
  }
}
