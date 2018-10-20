package states;

import boost.util.Color;
import boost.GM;
import boost.h2d.GameObject;
import boost.GameState;

/**
 * Sample State 2 - 2D Animations
 */
class SampleState2 extends GameState {
     /**
     * Text to display the FPS
     */
    var fps:h2d.Text;
     /**
     * The Animated Entity we are controlling
     */
    var target:GameObject;
    /**
     * Cursor to show Target Entity animation position
     */
    var cursor:GameObject;
    /**
     * Override `init()` to initialize the State
     */
    override public function init() {

        // Create a GameObject to act as a background image
        var bg = new GameObject();
        // Make a Gray graphic that covers the Screen
        bg.make_graphic(GM.width, GM.height, Color.GRAY);
        // Add the GameObject to the Entities List
        ecs.entities.add(bg);
        
        // Create the target animated GameObject
        target = new GameObject(GM.width * 0.5, GM.height * 0.25);
        // Load the GameObject's graphic
        // Passing in four arguments:
        // * the desired Image file
        // * flag that the image is a Sprite Sheet
        // * the width of each Sprite Sheet cell
        // * the height of each Sprite Sheet cell
        target.load_graphic(hxd.Res.images.baddegg, true, 180, 96);
        // Center the origin of the graphic
        target.graphic.center_origin();
        // Add an animation to the GameObject's graphic
        // Passing in five arguments:
        // * the animation's name
        // * the frames of the GameObject's graphic that the animation plays
        // * the speed of the animation in Frames Per Second
        // * flag that the animation is looped
        // * the direction the animation should play
        target.graphic.animations.add("egg-crack", [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14], 15, true, FORWARD);
        // Play the animation
        target.graphic.animations.play("egg-crack");
        // Add the Entity to ECS Engine
        ecs.entities.add(target);

        cursor = new GameObject(target.x - target.graphic.width * 0.5, target.y + target.graphic.height);
        cursor.make_graphic(2,8);
        cursor.graphic.center_origin();

        // Add Enitities to ECS Engine
        ecs.entities.add(cursor);
        

        // Add some info text
        // TODO: add text stuff into ECS 
        fps = new h2d.Text(hxd.res.DefaultFont.get(), local2d);
    }
    /**
     * Override `update()` to run logic every frame
     * This framework supports both using ECS Systems or a good old fashioned update loop to handle game logic.
     * Or in this case, both at one time!
     */ 
    override public function update(dt:Float) {
        super.update(dt);
        fps.text = 'FPS: ${GM.fps}';
    }
}