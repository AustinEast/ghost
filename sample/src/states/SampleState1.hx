package states;

import hxd.GM;
import h2d.GameState;
import h2d.ghost.Sprite;
import h2d.Tile;
import ghost.Random;

using h2d.ext.ObjectExt;
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
  var entity_count:Int = 1;
  /**
   * Override `init()` to initialize the GameState.
   */
  public function new() {
    super();
    // Create a legion of circles!
    for (i in 0...entity_count) {
      // Create a new Sprite with options
      var sprite = new Sprite({
        x: world.width * 0.5,
        y: world.height * 0.5
      });
      // Load the GameObject's graphic
      // sprite.graphic.load(hxd.Res.images.cir);
      // sprite.motion.velocity.x = Math.random() * 45 * (Random.chance() == true ? 1 : -1);
      // Add the GameObject to the GameState
      add(sprite);
      GM.log.info(sprite.base.x + ', ' + sprite.base.y);
    }

    // Add the custom ScreenWrapper system.
    // add_system(new ScreenWrapperSystem());

    // Add some info text to the UI
    // add_ui();
  }
  /**
   * Override `update()` to run logic every frame.
   * This framework supports both using ECS Systems or a good old fashioned update loop to handle game logic.
   * Or in this case, both at one time!
   */
  override public function step(dt:Float) {
    super.step(dt);
    // fps.text = 'FPS: ${GM.render_framerate}';
  }
  // function add_ui() {
  //   var menu = ui.add_flow(0, 0, {
  //     background: Tile.fromColor(0x000000, 5, 5, 0.8),
  //     vertical: true,
  //     align: {
  //       vertical: Middle
  //     },
  //     padding: {
  //       bottom: 2,
  //       left: 2,
  //       right: 2
  //     }
  //   });
  //   fps = menu.add_text();
  //   menu.add_text('Entities: $entity_count');
  // }
}
