package g2d;

import glib.Data;
import g2d.BaseObject;
import g2d.component.Collider;
import g2d.component.Motion;
import g2d.component.Transform;
import g2d.component.Animator;
import g2d.component.Graphic;
/**
 * Sprites are `GameObjects` preconfigured with components geared towards 2D games.
 *
 * creates, adds, and has references to `Transform`, `Motion`, `Collision`, `Graphic`, and `Animator` components.
 */
class Sprite extends BaseObject {
  /**
   * Default Sprite Options
   */
  public static var defaults(get, null):SpriteOptions;
  /**
   * Optional Motion Component.
   */
  public var motion(default, null):Null<Motion>;
  /**
   * Optional Collider Component.
   */
  public var collider(default, null):Null<Collider>;
  /**
   * Optional Graphic Component.
   */
  public var graphic(default, null):Null<Graphic>;
  /**
   * Optional Animator Component.
   */
  public var animator(default, null):Null<Animator>;
  /**
   * Creates a new Sprite.
   */
  public function new(?options:SpriteOptions) {
    super(options);

    options = Data.copy_fields(options, defaults);

    graphic = new Graphic(options.graphic);
    animator = new Animator();

    components.add(graphic);
    components.add(animator);

    if (options.moves) {
      motion = new Motion(options.motion);
      components.add(motion);
    }

    if (options.collides) {
      collider = new Collider(options.collider);
      components.add(collider);
    }
  }

  override public function destroy() {
    super.destroy();
    motion = null;
    collider = null;
    graphic = null;
    animator = null;
  }

  override public function kill() {
    super.kill();
    if (graphic != null) graphic.visible = false;
  }

  override public function revive() {
    super.revive();
    if (graphic != null) graphic.visible = true;
  }

  public function collider_from_graphic() {
    if (collider != null) collider.shape = graphic.to_aabb();
  }

  static function get_defaults():SpriteOptions return {
    moves: true,
    collides: true,
    transform: Transform.defaults,
    motion: Motion.defaults,
    collider: Collider.defaults,
    graphic: Graphic.defaults
  }
}

typedef SpriteOptions = {
  > BaseObjectOptions,
  var ?moves:Bool;
  var ?collides:Bool;
  var ?transform:TransformOptions;
  var ?motion:MotionOptions;
  var ?collider:ColliderOptions;
  var ?graphic:GraphicOptions;
}
