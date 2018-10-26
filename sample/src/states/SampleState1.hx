package states;

import boost.util.Color;
import boost.GM;
import boost.h2d.GameObject;
import boost.GameState;
import systems.ScreenWrapper;
using boost.ext.FlowExt;

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

        // Create a GameObject to act as a background image
        var bg = new GameObject();
        // Make a colored graphic that covers the Screen
        bg.make_graphic(GM.width, GM.height, 0xff222034);
        // Add the GameObject to the State
        add(bg);
        
        // Create a legion of circles!
        for (i in 0...entity_count) {
            // Create a GameObject at a random point on the Screen
            var c = new GameObject(Math.random() * GM.width, Math.random() * GM.height);
            // Load the GameObject's graphic
            c.load_graphic(hxd.Res.images.cir);
            // Center the origin of the graphic
            c.graphic.center_origin();
            // Add some motion
            c.transform.rotation = Math.random() * 360;
            c.motion.rotational_velocity = 0.01;
            c.motion.velocity.x = Math.random() * 5;
            // Add the GameObject to the State
            add(c);
        }

        // Add some info text to the UI
        fps = ui.add_text();
        ui.add_text('Entities: $entity_count', 0, 12);
        ui.isVertical = true;
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
}