package gxd;

import gxd.component.Process;
import ecs.entity.Entity;
/**
 * GameObjects are `Entities` with an update loop provided by the `Process` component added to it.
 *
 * Useful as a starting place while creating Entities for a State.
 *
 * TODO: Pool GameObjects
 */
class GameObject extends Entity {
  /**
   * Default GameObject Options
   */
  public static var defaults(get, null):GameObjectOptions;
  /**
   * Flag to check if the GameObject is alive.
   * Use `kill()` and `revive()` to set this value.
   */
  public var alive(default, null):Bool;
  /**
   * The GameObject's Process Component.
   * Drives the `update` function.
   */
  public var process(default, null):Process;
  /**
   * Creates a new GameObject.
   */
  public function new(?options:GameObjectOptions) {
    super(options.name);

    alive = true;
    process = new Process(options.update == null ? update : options.update, {loop: true});
    add(process);
  }

  public function update(dt:Float) {}

  public function kill() {
    var p = this.get(Process);
    if (p != null) p.active = false;
    alive = false;
  }

  public function revive() {
    var p = this.get(Process);
    if (p != null) p.active = true;
    alive = true;
  }

  static function get_defaults():GameObjectOptions return {}
}

typedef GameObjectOptions = {
  /**
   * Name of the GameObject
   */
  var ?name:String;
  /**
   * Optional function to override the GameObject's `update()` function
   */
  var ?update:Float->Void
}
