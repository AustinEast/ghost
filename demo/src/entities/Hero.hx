package entities;

import h2d.col.Point;
import hxd.Key;
import h2d.ghost.Sprite;
import h2d.data.Options;
import h2d.component.Grounded;

class Hero extends Sprite {
  public var sucking:Bool;
  public var facing:Bool;
  public var grounded:Grounded;

  var options:SpriteOptions = {
    drag_x: 100,
    max_velocity_x: 60,
    shape: {
      type: RECT,
      width: 12,
      height: 20,
    },
    graphic: {
      asset: hxd.Res.img.buster,
      animated: true,
      width: 40,
      height: 32,
      animations: [
        {
          name: "idle",
          frames: [5, 6, 7, 8],
          looped: true,
          speed: 8
        },
        {
          name: "run",
          frames: [9, 10, 11, 12],
          looped: true,
          speed: 8
        },
        {
          name: "jump",
          frames: [10, 11],
          looped: true,
          speed: 8
        },
        {
          name: "suck",
          frames: [13, 14, 15, 16],
          looped: true,
          speed: 8
        }
      ]
    }
  };

  public function new(x:Float, y:Float) {
    super(options);
    position.set(x, y);
    graphic.animations.play("idle");
    sucking = false;
    grounded = new Grounded({
      type: RECT,
      width: 10,
      height: 2,
      offset_y: 10
    });
    components.add(grounded);
  }

  override function step(dt:Float) {
    super.step(dt);
    sucking = Key.isDown(Key.X) && grounded.check();
    var left:Bool = false;
    var right:Bool = false;
    if (Key.isDown(Key.LEFT)) left = true;
    if (Key.isDown(Key.RIGHT)) right = true;
    if (left != right) {
      graphic.flip_x = left ? true : false;
      facing = left;

      if (!sucking) {
        if (grounded.check()) velocity.x += left ? -5 : 5;
        else acceleration.x += left ? -50 : 50;
      }
    }
    if (Key.isPressed(Key.UP)) velocity.y = -90;
    // Commented out for testing
    // if (!sucking && grounded.check() && Key.isPressed(Key.UP)) velocity.y = -90;
  }

  override function post_step(dt:Float) {
    super.post_step(dt);
    if (sucking) {
      graphic.animations.play("suck");
    }
    else if (grounded.check()) velocity.x != 0 ? graphic.animations.play("run") : graphic.animations.play("idle");
    else graphic.animations.play("jump");
  }
}
