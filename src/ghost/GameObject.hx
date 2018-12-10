package ghost;

import hxmath.math.Vector2;
import h2d.geom.Shape;
import h2d.component.Collider;
import h2d.component.Motion;
import h2d.component.Transform;
import h2d.component.Animator;
import h2d.component.Graphic;
import hxd.component.Process;
import h2d.geom.Rect;
import ecs.entity.Entity;
/**
 * GameObjects are `Entities` an update loop provided by the `Process` component added to it.
 *
 * Useful as a starting place while creating Entities for a GameState.
 *
 * TODO: Pool GameObjects
 */
class GameObject extends Entity {
  /**
   * Default GameObject Options
   */
  public static var defaults(get, null):GameObjectOptions;
  /**
   * The GameObject's Process Component.
   * Drives the `update` function.
   */
  public var process(default, null):Process;
  /**
   * Creates a new GameObject.
   * @param update The update function of the GameObject.
   * @param name The name of the GameObject.
   */
  public function new(?options:GameObjectOptions) {
    super(name);

    process = new Process(options.update, {loop: true});
    add(process);
  }

  public function kill() {
    var p = this.get(Process);
    if (p != null) p.active = false;
  }

  public function revive() {
    var p = this.get(Process);
    if (p != null) p.active = true;
  }

  static function get_defaults():GameObjectOptions return {}
}

typedef GameObjectOptions = {
  ?name:String,
  ?update:Float->Void
}
