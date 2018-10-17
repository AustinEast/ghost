package states;

import boost.util.Color;
import boost.GM;
import hxd.Key;
import boost.h2d.GameObject;
import boost.GameState;
import boost.ecs.system.render.Display2D;
import boost.ecs.system.render.Render2D;
import boost.ecs.system.physics.Arcade2D;

/**
 * Sample State 2 - 2D Animations
 */
class SampleState2 extends GameState {

    var fps:h2d.Text;
    var target:GameObject;

    override public function init() {

        // Add and configure our basic systems
        ecs.systems.add(new Display2D(local2d, {pixelPerfect: true}));
        ecs.systems.add(new Render2D());


        // Create a Background Image
        var bg = new GameObject();
        bg.make_graphic(GM.width, GM.height, Color.GRAY);
        ecs.entities.add(bg);
        
        // Create the Animation target
        target = new GameObject(GM.width * 0.5, GM.height * 0.5);
        target.load_graphic(hxd.Res.images.baddegg, true, 180, 96);
        target.graphic.add_animation("crack", [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14], 15, true);
        target.graphic.play_animation("crack");
        // Center the origin of the graphic
        target.graphic.dx -= Math.floor(target.graphic.width * 0.5);
        target.graphic.dy -= Math.floor(target.graphic.height * 0.5);
        
        ecs.entities.add(target);

        // Add some info text
        // TODO: add text stuff into ECS 
        fps = new h2d.Text(hxd.res.DefaultFont.get(), local2d);
    }

    // This framework supports both using ECS Systems or a good old fashioned update loop to handle game logic.
    // Or in this case, both at one time!
    override public function update(dt:Float) {
        super.update(dt);
        fps.text = 'FPS: ${GM.fps}';
    }
}