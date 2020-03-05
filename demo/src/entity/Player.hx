package entity;

import component.Sucker;
import ghost.entity.Sprite;
import ghost.component.Trigger;
import hxd.Key;

class Player extends Sprite {
  var sucker:Sucker;
  var grounded:Trigger;

  public function new() {
    super({
      renderer: {
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
      },
      body: {
        drag_x: 100,
        max_velocity_x: 60,
        gravity_scale: 1.5,
        shape: {
          type: RECT,
          width: 12,
          height: 20,
        }
      }
    });

    // Center the graphic
    renderer.center_offset();
    renderer.animations.play("idle");

    sucker = new Sucker({
      type: RECT,
      width: 6,
      height: 8,
      offset_x: 18,
      offset_y: 4
    });
    grounded = new Trigger({
      type: RECT,
      width: 10,
      height: 2,
      offset_y: 10
    });
    components.add(sucker);
    components.add(grounded);
  }

  override function step(dt:Float) {
    super.step(dt);

    controls();
    animations();
  }

  inline function controls() {
    sucker.active = Key.isDown(Key.X) && grounded.check();

    // if (Key.isPressed(Key.UP)) velocity.y = -90;
    // Commented out for testing
    if (grounded.check() && Key.isPressed(Key.UP)) {
      body.velocity.y = -120;
      sucker.active = false;
    }

    var left:Bool = false;
    var right:Bool = false;

    if (Key.isDown(Key.LEFT)) left = true;
    if (Key.isDown(Key.RIGHT)) right = true;

    if (left != right) {
      renderer.flip_x = left ? true : false;
      sucker.facing = left;

      if (!sucker.active) {
        if (grounded.check()) body.velocity.x += left ? -5 : 5;
        else body.acceleration.x += left ? -50 : 50;
      }
    }
  }

  inline function animations() {
    if (sucker.active) {
      renderer.animations.play("suck");
    }
    else if (grounded.check()) body.velocity.x != 0 ? renderer.animations.play("run") : renderer.animations.play("idle");
    else renderer.animations.play("jump");
  }
}
