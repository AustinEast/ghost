package states;

import boost.util.Color;
import boost.GM;
import hxd.Key;
import boost.h2d.GameObject;
import boost.GameState;
import boost.ecs.system.render.Display2D;
import boost.ecs.system.render.Render2D;
import boost.ecs.system.physics.Arcade2D;
import systems.ScreenWrapper;

/**
 * Sample State 1 - Pixel Art Stress Test
 */
class SampleState1 extends GameState {

    var fps:h2d.Text;
    var entity_count:Int = 4000;

    override public function init() {

        // Add and configure our basic systems
        ecs.systems.add(new Arcade2D());
        ecs.systems.add(new Display2D(local2d, {pixelPerfect: true}));
        ecs.systems.add(new Render2D());

        // Add our custom system to handle in screen wrapping
        ecs.systems.add(new ScreenWrapper());

        // Create a Background Image
        var bg = new GameObject();
        bg.make_graphic(GM.width, GM.height, Color.GRAY);
        ecs.entities.add(bg);
        
        // Create our legion of circles
        for (i in 0...entity_count) {
            var c = new GameObject(Math.random() * GM.width, Math.random() * GM.height);
            c.load_graphic(hxd.Res.images.cir);
            // Center the origin of the graphic
            c.graphic.dx -= Math.floor(c.graphic.width * 0.5);
            c.graphic.dy -= Math.floor(c.graphic.height * 0.5);
            // Add some motion
            c.transform.rotation = Math.random() * 360;
            c.motion.rotational_velocity = 0.01;
            c.motion.velocity.x = Math.random() * 5;
            
            ecs.entities.add(c);
        }

        // Add some info text
        // TODO: add text stuff into ECS 
        fps = new h2d.Text(hxd.res.DefaultFont.get(), local2d);
        var entity_count_text = new h2d.Text(hxd.res.DefaultFont.get(), local2d);
        entity_count_text.text = 'Entities: $entity_count';
        entity_count_text.y += 12;
    }

    // This framework supports both using ECS Systems or a good old fashioned update loop to handle game logic.
    // Or in this case, both at one time!
    override public function update(dt:Float) {
        super.update(dt);
        fps.text = 'FPS: ${GM.fps}';
    }
}