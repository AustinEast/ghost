package states;

import h2d.Interactive;
import boost.util.Color;
import boost.GM;
import boost.h2d.GameObject;
import boost.GameState;
import hxd.Math;

/**
 * Sample State 2 - 2D Animations.
 */
class SampleState2 extends GameState {
     /**
     * Text to display the FPS.
     */
    var fps:h2d.Text;
     /**
     * The Animated Entity we are controlling.
     */
    var target:GameObject;
    /**
     * Cursor to show Target Entity animation position.
     */
    var cursor:GameObject;
    /**
     * Cursor Backround.
     */
    var cursor_bg:GameObject;
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
        target.graphic.animations.add("egg-crack", [0,0,0,0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14], 10, true, 2, FORWARD);
        // Play the animation
        target.graphic.animations.play("egg-crack");
        // Add the Target Entity to the State
        add(target);

        init_ui();        

        // Add some info text
        // TODO: add text stuff into ECS 
        fps = new h2d.Text(hxd.res.DefaultFont.get(), local2d);
    }
    /**
     * Create some UI elements to control the target's animation.
     */
    function init_ui() {
        cursor_bg = new GameObject(GM.width * 0.25, (GM.height * 0.5) + 10);
        cursor_bg.make_graphic(Math.floor(GM.width * 0.5), 10, Color.GRAY);

        cursor = new GameObject(cursor_bg.x + 1, cursor_bg.y + 1);
        cursor.make_graphic(2,8);

        var dir = new h2d.Text(hxd.res.DefaultFont.get(), local2d);
        dir.text = 'Animation Direction:';
        dir.textAlign = Center;
        dir.setPosition(GM.width * 0.5, cursor_bg.y + 10);

        // var forward_i = new Interactive()
        // var forward_text = new h2d.Text(hxd.res.DefaultFont.get(), local2d);
        // forward_text.text = "Forward";

        add(cursor_bg);
        add(cursor);
    }
    /**
     * Override `update()` to run logic every frame.
     * This framework supports both using ECS Systems or a good old fashioned update loop to handle game logic.
     * Or in this case, both at one time!
     */ 
    override public function update(dt:Float) {
        super.update(dt);
        fps.text = 'FPS: ${GM.fps}';

        var pos = target.graphic.animations.index / (target.graphic.animations.current.frames.length - 1);
        cursor.x = Math.lerp(cursor_bg.x + 2, cursor_bg.x + cursor_bg.graphic.width - 3, pos);
    }
}