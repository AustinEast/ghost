package;

import h2d.col.Point;
import echo.Group;
import ghost.Random;
import h2d.ghost.Sprite;
import hxd.GM;
import h2d.GameState;
import entities.*;

class GarageState extends GameState {
  var hero:Hero;

  public function new() {
    super({width: GM.width * 2, height: GM.height, gravity_y: 130});
    hero = new Hero(GM.width * 0.5, GM.height * 0.5);

    for (i in 0...20) {
      add(new BoxLg(Random.range(GM.width * 0.5, GM.width), Random.range(0, GM.height * 0.5)));
      add(new Box(Random.range(GM.width * 0.5, GM.width), Random.range(0, GM.height * 0.5)));
      add(new Box(Random.range(GM.width * 0.5, GM.width), Random.range(0, GM.height * 0.5)));
    }

    var ground = new Sprite({
      x: GM.width * 0.5,
      y: GM.height - 10,
      mass: 0,
      shape: {
        type: RECT,
        width: GM.width,
        height: 20
      }
    });
    ground.graphic.make(GM.width, 20);

    add(ground);
    add(hero);

    camera.target = hero;
    camera.min = new Point(0, -30);
    camera.max = new Point(10, 0);

    world.listen();
  }

  var bias = 3;

  override function step(dt:Float) {
    super.step(dt);
    world.for_each_dynamic((entity) -> {
      if (entity == hero) return;
      if (hero.sucking) {
        var eb = entity.bounds();
        var hb = hero.bounds();
        if (!hero.facing) {
          if (eb.left - bias > hb.right) entity.acceleration.x -= 120 / (eb.left - hb.right);
        }
        else {
          if (eb.right + bias < hb.left) entity.acceleration.x += 120 / (hb.left - eb.right);
        }
        eb.put();
        hb.put();
      }
    });
  }
}
