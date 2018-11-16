package states;

import systems.ScreenWrapperSystem;
import boost.h2d.geom.Rect;
import h2d.Graphics;
import h2d.Tile;
import boost.GM;
import boost.h2d.GameObject;
import boost.GameState;

using boost.h2d.ext.ObjectExt;
/**
 * Sample State 3 - Collision
 */
class SampleState3 extends GameState {
  /**
   * Text to display the FPS.
   */
  var fps:h2d.Text;
  /**
   * The amount of Entities to spawn.
   */
  var entity_count:Int = 20;
  /**
   * Debug Graphic
   */
  var dg:Graphics;
  /**
   * Override `init()` to initialize the State.
   */
  override public function init() {
    var game_object = new GameObject(GM.width * 0.5, GM.height - 10);
    game_object.graphic.make(GM.width - 10, 8);
    game_object.collider;
    add(game_object);

    for (i in 0...entity_count) {
      // Create a GameObject at a random point on the Screen
      game_object = new GameObject(Math.random() * GM.width, Math.random() * GM.height * 0.5);
      // Load the GameObject's graphic
      game_object.graphic.load(hxd.Res.images.cir);
      game_object.collider;
      // Add some motion
      game_object.motion;
      // Add the GameObject to the State
      add(game_object);
    }

    // Add some info text to the UI
    add_ui();
  }
  /**
   * Override `init_systems()` to add the custom ScreenWrapper system.
   */
  override function init_systems() {
    super.init_systems();
    ecs.systems.add(new ScreenWrapperSystem());
  }
  /**
   * Override `update()` to run logic every frame.
   * This framework supports both using ECS Systems or a good old fashioned update loop to handle game logic.
   * Or in this case, both at one time!
   */
  override public function update(dt:Float) {
    super.update(dt);
    fps.text = 'FPS: ${GM.fps}';
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
