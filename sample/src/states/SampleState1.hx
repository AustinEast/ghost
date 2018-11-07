package states;

import h2d.Tile;
import boost.GM;
import boost.h2d.GameObject;
import boost.GameState;
import systems.ScreenWrapper;

using boost.ext.ObjectExt;

/**
 * Sample State 1 - Pixel Art Stress Test.
 */
class SampleState1 extends GameState {
    /**
     * Text to display the FPS.
     */
    var fps:h2d.Text;
    /**
     * The amount of Entities to spawn.
     */
    var entity_count:Int = 5000;
    /**
     * Override `init()` to initialize the State.
     */
    override public function init() {        
        // Create a legion of circles!
        for (i in 0...entity_count) {
            // Create a GameObject at a random point on the Screen
            var c = new GameObject(Math.random() * GM.width, Math.random() * GM.height);
            // Load the GameObject's graphic
            c.graphic.load(hxd.Res.images.cir);
            // Add some motion
            c.transform.rotation = Math.random() * 360;
            c.motion.rotational_velocity = 0.01;
            c.motion.velocity.x = Math.random() * 5;
            // Add the GameObject to the State
            add(c);
        }
        // Add some info text to the UI
        add_ui();
    }
    /**
     * Override `init_systems()` to add the custom ScreenWrapper system.
     */
    override function init_systems() {
        super.init_systems();         
        ecs.systems.add(new ScreenWrapper());
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