package states;

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
  var entity_count:Int = 10;
  /**
   * Debug Graphic
   */
  var dg:Graphics;
  /**
   * Override `init()` to initialize the State.
   */
  override public function init() {
    dg = new Graphics(local2d);

    dg.beginFill(0x00FF00, 0.5);
    dg.lineStyle(1, 0xFF00FF);
    dg.drawRect(10, 10, 100, 100);
    dg.drawCircle(100, 100, 30);
    dg.endFill();

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
