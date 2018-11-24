package ghost.h2d;

import ghost.h2d.component.Collider;
import ghost.h2d.component.Motion;
import ghost.h2d.component.Transform;
import ghost.h2d.component.Animator;
import ghost.h2d.component.Sprite;
import ghost.hxd.component.Process;
import ghost.h2d.geom.Rect;
import ecs.entity.Entity;
/**
 * GameObjects are `Entities` preconfigured with a transform and an update loop provided by the `Transform` and  `Process` components added to it.
 *
 * helper functions to quickly create and reference `Motion`, `Collision`, `Graphic`, and `Animator` components are also available to use.
 *
 * Useful as a starting place while creating Entities for a GameState.
 */
abstract GameObject(Entity) from Entity to Entity {
  /**
   * The GameObject's Transform Component.
   */
  public var transform(get, never):Transform;
  /**
   * The GameObject's Motion Component.
   */
  public var motion(get, never):Motion;
  /**
   * The GameObject's Collider Component.
   */
  public var collider(get, never):Collider;
  /**
   * The GameObject's Graphic Component.
   */
  public var sprite(get, never):Sprite;
  /**
   * The GameObject's Animator Component.
   */
  public var animator(get, never):Animator;
  /**
   * The GameObject's Process Component.
   * Drives the `update` function.
   */
  public var process(get, never):Process;
  /**
   * Creates a new GameObject.
   * @param x The x position of the GameObject.
   * @param y The y position of the GameObject.
   * @param update The update function of the GameObject.
   * @param name The name of the GameObject.
   */
  public function new(x:Float = 0, y:Float = 0, ?update:Float->Void, ?name:String) {
    this = new Entity(name);

    this.add(new Transform({x: x, y: y}));
    this.add(new Process(update, {loop: true}));
  }

  function get_transform():Transform {
    var t = this.get(Transform);
    if (t == null) {
      t = new Transform();
      this.add(t);
    }
    return t;
  }

  function get_motion():Motion {
    var m = this.get(Motion);
    if (m == null) {
      m = new Motion();
      this.add(m);
    }
    return m;
  }

  function get_sprite():Sprite {
    var s = this.get(Sprite);
    if (s == null) {
      s = new Sprite();
      this.add(s);
    }
    return s;
  }

  function get_animator():Animator {
    var a = this.get(Animator);
    if (a == null) {
      a = new Animator();
      this.add(a);
    }
    return a;
  }

  function get_collider():Collider {
    var c = this.get(Collider);
    if (c == null) {
      // When creating a new collider, check if there is a graphic to base the bounds on.
      // Otherwise just create a 16x16 rectangle.
      var s = sprite;
      c = new Collider(RECT, {
        width: s == null ? 5 : s.width,
        height: s == null ? 5 : s.height
      });
      this.add(c);
    }
    return c;
  }

  function get_process():Process {
    var p = this.get(Process);
    if (p == null) {
      p = new Process(null);
      this.add(p);
    }
    return p;
  }

  public function kill() {
    var s = this.get(Sprite);
    var p = this.get(Process);
    if (s != null) s.visible = false;
    if (p != null) p.active = false;
  }

  public function revive() {
    var s = this.get(Sprite);
    var p = this.get(Process);
    if (s != null) s.visible = true;
    if (p != null) p.active = true;
  }
}
