package states;

import systems.ScreenWrapperSystem;
import gxd.GM;
import gxd.GameState;
import glib.Random;
import g2d.Sprite;
import h2d.Tile;

using g2d.ext.ObjectExt;
/**
 * Sample GameState 1 - Pixel Art Stress Test.
 */
class SampleState1 extends GameState {
  /**
   * Text to display the FPS.
   */
  var fps:h2d.Text;
  /**
   * The amount of Entities to spawn.
   */
  var entity_count:Int = 2000;
  /**
   * Override `init()` to initialize the GameState.
   */
  override public function create() {
    // Create a legion of circles!
    for (i in 0...entity_count) {
      // Create a new Sprite with options
      var sprite = new Sprite({
        collides: false,
        transform: {
          x: Math.random() * GM.width,
          y: Math.random() * GM.height,
          rotation: Math.random() * 360
        },
        motion: {
          rotational_velocity: 1,
          velocity: {x: Math.random() * 45 * (Random.chance() == true ? 1 : -1), y: 0}
        }
      });
      // Load the GameObject's graphic
      sprite.graphic.load(hxd.Res.images.cir);
      sprite.motion.velocity.x = Math.random() * 45 * (Random.chance() == true ? 1 : -1);
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
