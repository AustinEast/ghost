package;

import echo.Group;
import ghost.Random;
import hxd.GM;
import h2d.GameState;
import h2d.col.Point;
import h2d.ghost.Sprite;
import h2d.ghost.TileMap;
import hxd.debug.plugins.EchoDrawer;
import entities.*;

class GarageState extends GameState {
  var hero:Hero;
  var powerups:Int;
  var map:TileMap;
  var colliders:Group;
  #if debug
  var echo_drawer:EchoDrawer;
  #end

  public function new() {
    super({width: GM.width * 2, height: GM.height * 2, gravity_y: 130});
    colliders = new Group();

    hero = new Hero(GM.width * 0.5, GM.height * 0.5);
    colliders.add(hero);

    for (i in 0...100) {
      if (i % 2 == 0) colliders.add(add(new BoxLg(Random.range(0, GM.width * 2), Random.range(0, GM.height * 0.5))));
      else colliders.add(add(new Box(Random.range(0, GM.width * 2), Random.range(0, GM.height * 0.5))));
    }

    map = get_tiled_layer(1);

    add(map);
    add(hero);

    camera.target = hero;
    // camera.min = new Point(0, -30);
    // camera.max = new Point(100, 300);

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
          if (eb.left > hero.x + 6) entity.acceleration.x -= (120 / (eb.left - hero.x + 6)) + 10;
        }
        else {
          if (eb.right < hero.x - 6) entity.acceleration.x += 120 / (hero.x - 6 - eb.right);
        }
        eb.put();
      }
    });
  }

  override function dispose() {
    super.dispose();
    echo_drawer.remove();
  }

  function get_tiled_layer(layer:Int = 0, collides:Bool = true):TileMap {
    var data = haxe.Json.parse(hxd.Res.dat.map.entry.getText());
    // var l = data.layers[layer];
    var map = new TileMap();
    map.load_from_2d_array(data.data, hxd.Res.img.test_tile.toTile(), 16, 16, collides);
    return map;
  }
}
