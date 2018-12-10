package ghost;

import hxd.component.Process;
import ecs.entity.Entity;
/**
 * GameObjects are `Entities` with an update loop provided by the `Process` component added to it.
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
   */
  public function new(?options:GameObjectOptions) {
    super(options.name);

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
  var ?name:String;
  var ?update:Float->Void
}
