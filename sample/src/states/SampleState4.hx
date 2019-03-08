package states;

import hxmath.math.IntVector2;
import systems.ScreenWrapperSystem;
import hxd.GM;
import hxd.GameState;
import hxd.Key;
import echo.Shape;
import h2d.Sprite;
import h2d.Tile;

using h2d.ext.ObjectExt;
/**
 * Sample GameState 4 - Physics
 */
class SampleState4 extends GameState {
  var player:Sprite;
  /**
   * Text to display the FPS.
   */
  var fps:h2d.Text;
  /**
   * The amount of Entities to spawn.
   */
  var entity_count:Int = 50;
  /**
   * Override `init()` to initialize the GameState.
   */
  override public function create() {
    // Set the Physics System's Gravity
    GM.physics.gravity.y = 5;

    // Make a
    var size = new IntVector2(GM.width - 10, 16);
    var sprite = new Sprite({moves: false, transform: {x: GM.width * 0.5, y: GM.height - 10}});
    sprite.graphic.make(size.x, size.y);
    sprite.collider_from_graphic();
    add(sprite);

    player = new Sprite({
      transform: {x: GM.width * 0.5, y: GM.height - 20},
      motion: {
        max_velocity: {x: 90, y: 180},
        drag: {x: 5, y: 0}
      },
      collider: {width: 12, height: 12, y: 2}
    });
    player.graphic.load(hxd.Res.images.bot, true, 16, 16);
    player.animator.add("idle", [0]);
    player.animator.add("run", [1, 2, 3, 4], 15, true);
    add(player);

    for (i in 0...entity_count) {
      // Create a GameObject at a random point on the Screen
      sprite = new Sprite({
        transform: {x: Math.random() * GM.width, y: Math.random() * GM.height * 0.5}
      });
      if (i % 2 == 0) {
        sprite.graphic.load(hxd.Res.images.box);
        sprite.collider_from_graphic();
        sprite.motion.elasticity = 1;
      }
      else if (i % 3 == 0) {
        sprite.graphic.load(hxd.Res.images.ghostlg);
        sprite.motion.elasticity = 1;
        sprite.collider.shape = Shape.circle(0, 0, 8);
      }
      else {
        sprite.graphic.load(hxd.Res.images.boxlg);
        sprite.collider_from_graphic();
        sprite.motion.elasticity = .2;
        // sprite.motion.mass = 5;
      }
      sprite.motion.drag.x = 5;
      sprite.motion.max_velocity.set(180, 180);
      // Add the GameObject to the GameState
      add(sprite);
    }

    // Add the custom ScreenWrapper system.
    add_system(new ScreenWrapperSystem());

    // Add some info text to the UI
    add_ui();
  }
  /**
   * Override `update()` to run logic every frame.
   * This framework supports both using ECS Systems or a good old fashioned update loop to handle game logic.
   * Or in this case, both at one time!
   */
  override public function update(dt:Float) {
    super.update(dt);
    fps.text = 'FPS: ${GM.render_framerate}';

    var left:Bool = false;
    var right:Bool = false;
    if (Key.isDown(Key.LEFT)) left = true;
    if (Key.isDown(Key.RIGHT)) right = true;
    if (left != right) {
      player.graphic.flip_x = left ? true : false;
      player.motion.acceleration.x = left ? -40 : 40;
    }
    player.motion.velocity.x != 0 ? player.animator.play("run") : player.animator.play("idle");
  }
  /**
   * Override `dispose()` to preform any needed cleanup when the GameState is closed.
   */
  override public function dispose() {
    super.dispose();
    // Set the Physics System's Gravity back to 0
    GM.physics.gravity.y = 0;
  }

  function add_ui() {
    var menu = ui.add_flow(0, 0, {
      background: Tile.fromColor(0x000000, 5, 5, 0.8),
      vertical: true,
      align: {
        vertical: Middle
      },
      padding: {
        bottom: 2,
        left: 2,
        right: 2
      }
    });
    fps = menu.add_text();
    menu.add_text('Entities: $entity_count');
  }
}
