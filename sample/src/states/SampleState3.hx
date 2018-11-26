package states;

import ghost.util.RandomUtil;
import ghost.h2d.geom.Shape;
import h2d.Graphics;
import h2d.Tile;
import ghost.GM;
import ghost.h2d.GameObject;
import ghost.GameState;

using ghost.h2d.ext.ObjectExt;
/**
 * Sample State 3 - Collision Separation
 */
class SampleState3 extends GameState {
  /**
   * Text to display the FPS.
   */
  var fps:h2d.Text;
  /**
   * The amount of Entities to spawn.
   */
  var entity_count:Int = 100;
  /**
   * Debug Graphic
   */
  var dg:Graphics;
  /**
   * Override `init()` to initialize the State.
   */
  override public function create() {
    for (i in 0...entity_count) {
      // Create a GameObject at a random point on the Screen
      var game_object = new GameObject(Math.random() * GM.width, Math.random() * GM.height);
      // Load the GameObject's graphic
      game_object.sprite.visible = false;
      // Set the GameObject's Collider to a random sizhsshape
      var size = RandomUtil.range_int(2, 5) * 8;
      game_object.collider.shape = i % 2 == 0 ? Shape.circle(0, 0, size * 0.5) : Shape.square(0, 0, size);
      // Add some motion
      game_object.motion;
      // Add the GameObject to the State
      add(game_object);
    }

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
    // fps.text = 'FPS: ${GM.fps}';
  }

  function add_ui() {
    // var menu = ui.add_flow(0, 0, {
    //   background: Tile.fromColor(0x000000, 5, 5, 0.8),
    //   vertical: true,
    //   align: {
    //     vertical: Middle
    //   },
    //   padding: {
    //     bottom: 2,
    //     left: 2,
    //     right: 2
    //   }
    // });
    // fps = menu.add_text();
    // menu.add_text('Entities: $entity_count');
  }
}
