package states;

import echo.Group;
import ghost.Random;
import h2d.ghost.Sprite;
import hxd.GM;
import h2d.GameState;
import entities.*;

class CleaningState extends GameState {
  var hero:Hero;

  public function new() {
    super({width: GM.width, height: GM.height, gravity_y: 130});
    hero = new Hero(GM.width * 0.5, GM.height * 0.5);

    for (i in 0...20) {
      add(new BoxLg(Random.range(GM.width * 0.5, GM.width), Random.range(0, GM.height * 0.5)));
      add(new Box(Random.range(GM.width * 0.5, GM.width), Random.range(0, GM.height * 0.5)));
    }

    var ground = new Sprite({
      body: {
        x: GM.width * 0.5,
        y: GM.height - 10,
        mass: 0,
        shape: {
          type: RECT,
          width: GM.width,
          height: 20
        }
      }
    });
    ground.graphic.make(GM.width, 20);

    add(ground);
    add(hero);

    world.listen();
  }

  override function step(dt:Float) {
    super.step(dt);
    world.for_each_dynamic((body) -> {
      if (body.entity == hero) return;
      if (hero.sucking) {
        if (!hero.facing) {
          if (body.x > hero.body.x) body.acceleration.x -= 120 / (body.x - hero.body.x);
        }
        else {
          if (body.x < hero.body.x) body.acceleration.x += 120 / (hero.body.x - body.x);
        }
      }
    });
  }
}
