package h2d.object;

import ghost.util.DataUtil;
import ghost.GameObject;
import h2d.component.Collider;
import h2d.component.Motion;
import h2d.component.Transform;
import h2d.component.Animator;
import h2d.component.Graphic;
/**
 * Sprites are `GameObjects` preconfigured with components geared towards 2D games.
 *
 * creates, adds, and has references to `Transform`, `Motion`, `Collision`, `Graphic`, and `Animator` components.
 */
class Sprite extends GameObject {
  /**
   * Default Sprite Options
   */
  public static var defaults(get, null):SpriteOptions;
  /**
   * The Sprite's Transform Component.
   */
  public var transform(default, null):Transform;
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

    options = DataUtil.copy_fields(options, defaults);

    transform = new Transform(options.transform);
    graphic = new Graphic(options.graphic);
    animator = new Animator();

    add(transform);
    add(graphic);
    add(animator);

    if (options.moves) {
      motion = new Motion(options.motion);
      add(motion);
    }

    if (options.collides) {
      collider = new Collider(options.collider);
      add(collider);
    }
  }

  override public function kill() {
    super.kill();
    var g = this.get(Graphic);
    if (g != null) g.visible = false;
  }

  override public function revive() {
    super.revive();
    var g = this.get(Graphic);
    if (g != null) g.visible = true;
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
  > GameObjectOptions,
  ?moves:Bool,
  ?collides:Bool,
  ?transform:TransformOptions,
  ?motion:MotionOptions,
  ?collider:ColliderOptions,
  ?graphic:GraphicOptions
}
