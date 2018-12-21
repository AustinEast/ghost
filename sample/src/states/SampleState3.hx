package states;

import gxd.GM;
import gxd.State;
import gxd.util.RandomUtil;
import g2d.geom.Shape;
import g2d.Sprite;
import h2d.Tile;

using g2d.ext.ObjectExt;
/**
 * Sample State 3 - Collision Separation
 */
class SampleState3 extends State {
  /**
   * Text to display the FPS.
   */
  var fps:h2d.Text;
  /**
   * The amount of Entities to spawn.
   */
  var entity_count:Int = 100;
  /**
   * Override `init()` to initialize the State.
   */
  override public function create() {
    GM.collisions.debug = true;

    for (i in 0...entity_count) {
      // Create a Sprite at a random point on the Screen
      var sprite = new Sprite({transform: {x: Math.random() * GM.width, y: Math.random() * GM.height}});
      // Load the Sprite's graphic
      sprite.graphic.visible = false;
      // Set the Sprite's Collider to a random size/shape
      var size = RandomUtil.range_int(2, 5) * 8;
      sprite.collider.shape = i % 2 == 0 ? Shape.circle(0, 0, size * 0.5) : Shape.square(0, 0, size);
      // Add the Sprite to the State
      add(sprite);
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
    fps.text = 'FPS: ${GM.render_framerate}';
  }

  override public function destroy() {
    super.destroy();
    GM.collisions.debug = false;
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
