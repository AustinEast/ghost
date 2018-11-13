package states;

import boost.h2d.component.Animator.;
import h2d.Bitmap;
import h2d.Tile;
import h2d.Text;
import boost.util.Color;
import boost.GM;
import boost.h2d.GameObject;
import boost.GameState;
import hxd.Math;

using boost.h2d.ext.ObjectExt;
/**
 * Sample State 2 - 2D Animations.
 */
class SampleState2 extends GameState {
  /**
   * The Animator we are controlling.
   */
  var target_animator:Animator;
  /**
   * Cursor to show Target Entity Animation position.
   */
  var cursor:Bitmap;
  /**
   * Cursor Backround.
   */
  var cursor_bg:Bitmap;
  /**
   * Text to display the current Animation Direction.
   */
  var direction_text:Text;
  /**
   * Override `init()` to initialize the State.
   */
  override public function init() {
    // Create the target animated GameObject
    var game_object = new GameObject(GM.width * 0.5, GM.height * 0.25);
    // Load the GameObject's graphic
    // Passing in four arguments:
    // * the desired Image file
    // * flag that the image is a Sprite Sheet
    // * the width of each Sprite Sheet cell
    // * the height of each Sprite Sheet cell
    game_object.graphic.load(hxd.Res.images.baddegg, true, 180, 96);
    // Add the Target Entity to the State
    add(game_object);

    // Get a reference the GameObject's Animator so we can manipulate it
    target_animator = game_object.animator;
    // Add an animation to the GameObject's Animator
    // Passing in six arguments:
    // * the animation's name
    // * the frames of the GameObject's graphic that the animation plays
    // * the speed of the animation in Frames Per Second
    // * flag that the animation is looped
    // * how many seconds to delay the animation between loops
    // * the direction the animation should play
    target_animator.add('egg-crack', [0, 0, 0, 0, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], 10, true, 2, FORWARD);
    // Play the animation
    target_animator.play('egg-crack');

    // Add the UI Elements
    add_ui();
  }
  /**
   * Override `update()` to run logic every frame.
   * This framework supports both using ECS Systems or a good old fashioned update loop to handle game logic.
   * Or in this case, both at one time!
   */
  override public function update(dt:Float) {
    super.update(dt);

    var pos = target_animator.index / (target_animator.current.frames.length - 1);
    cursor.x = Math.lerp(2, cursor_bg.tile.width - cursor.tile.width - 2, pos);
  }

  function add_ui() {
    // Add and configure a Flow Object for the UI
    var menu = ui.add_flow(0, (GM.height * 0.5) + 10, {
      vertical: true,
      align: {
        horizontal: Middle
      },
      spacing: {
        vertical: 6
      },
      width: {
        min: GM.width
      }
    });

    // Add the Animation Cursor
    cursor_bg = menu.add_graphic(Tile.fromColor(Color.GRAY, Math.floor(GM.width * 0.5), 10));
    cursor = cursor_bg.add_graphic(Tile.fromColor(Color.WHITE, 4, 8), 0, 1);
    // Add the info Text
    direction_text = menu.add_text('Animation Direction: $FORWARD');
    // Add and configure a nested Flow Object to contain the directional buttons
    var dir_buttons = menu.add_flow(0, 0, {spacing: {horizontal: 3}});
    // Add the directional buttons
    dir_buttons.add_button(0, 0, '$FORWARD', () -> set_animation_direction(FORWARD));
    dir_buttons.add_button(0, 0, '$REVERSE', () -> set_animation_direction(REVERSE));
    dir_buttons.add_button(0, 0, '$PINGPONG', () -> set_animation_direction(PINGPONG));
  }

  function set_animation_direction(anim_dir:AnimationDirection) {
    target_animator.members.get('egg-crack').direction = anim_dir;
    target_animator.play('egg-crack', true);
    direction_text.text = 'Animation Direction: $anim_dir';
  }
}
