package states;

import hxd.Key;
import ghost.h2d.geom.Shape;
import systems.ScreenWrapperSystem;
import h2d.Graphics;
import h2d.Tile;
import ghost.GM;
import ghost.h2d.GameObject;
import ghost.GameState;

using ghost.h2d.ext.ObjectExt;
/**
 * Sample State 4 - Physics
 */
class SampleState4 extends GameState {
  var player:GameObject;
  /**
   * Text to display the FPS.
   */
  var fps:h2d.Text;
  /**
   * The amount of Entities to spawn.
   */
  var entity_count:Int = 20;
  /**
   * Override `init()` to initialize the State.
   */
  override public function create() {
    // Set the State's Gravity
    GM.physics.gravity.y = 5;
    close_callback = () -> GM.physics.gravity.y = 0;

    var game_object = new GameObject(GM.width * 0.5, GM.height - 10);
    game_object.sprite.make(GM.width - 10, 16);
    game_object.collider;
    add(game_object);

    player = new GameObject(GM.width * 0.5, GM.height - 20);
    player.sprite.load(hxd.Res.images.bot, true, 16, 16);
    player.animator.add("idle", [0]);
    player.animator.add("run", [1, 2, 3, 4], 15, true);
    player.collider.shape = Shape.square(0, 2, 12);
    player.motion.max_velocity.set(90, 180);
    player.motion.drag.x = 5;
    add(player);

    for (i in 0...entity_count) {
      // Create a GameObject at a random point on the Screen
      game_object = new GameObject(Math.random() * GM.width, Math.random() * GM.height * 0.5);
      if (i % 2 == 0) {
        game_object.sprite.load(hxd.Res.images.box);
        game_object.motion.elasticity = .2;
      }
      else if (i % 3 == 0) {
        game_object.sprite.load(hxd.Res.images.ghostlg);
        game_object.motion.elasticity = .5;
        // game_object.collider.shape = Shape.circle(0, 0, 8);
      }
      else {
        game_object.sprite.load(hxd.Res.images.boxlg);
        game_object.motion.elasticity = .2;
        game_object.motion.mass = 5;
      }
      game_object.collider;
      game_object.motion.drag.x = 5;
      game_object.motion.max_velocity.set(180, 180);
      // Add the GameObject to the State
      add(game_object);
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
    fps.text = 'FPS: ${GM.framerate}';

    var left:Bool = false;
    var right:Bool = false;
    if (Key.isDown(Key.LEFT)) left = true;
    if (Key.isDown(Key.RIGHT)) right = true;
    if (left != right) {
      player.sprite.flip_x = left ? true : false;
      player.motion.acceleration.x = left ? -40 : 40;
    }
    player.motion.velocity.x != 0 ? player.animator.play("run") : player.animator.play("idle");
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
