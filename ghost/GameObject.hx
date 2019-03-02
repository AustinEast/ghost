package gxd;

import glib.Data;
import glib.Disposable;
import gxd.component.Process;
import gxd.component.Instance;
import ecs.entity.Entity;
/**
 * GameObjects are `Entities` with an update loop provided by the `Process` component added to it.
 *
 * Useful as a starting place while creating Entities for a GameState.
 *
 * TODO: Pool GameObjects
 */
class GameObject implements IDisposable {
  /**
   * Default GameObject Options
   */
  public static var defaults(get, null):GameObjectOptions;

  public var id(get, null):Int;
  public var name(default, null):String;
  /**
   * Flag to check if the GameObject is alive.
   * Use `kill()` and `revive()` to set this value.
   */
  public var alive(default, null):Bool;
  public var components(default, null):Entity;
  /**
   * The GameObject's Process Component.
   * Drives the `update` function.
   */
  public var process(default, null):Process;
  public var disposeed(default, null):Bool;
  /**
   * Creates a new GameObject.
   */
  public function new(?options:GameObjectOptions) {
    options = Data.copy_fields(options, defaults);

    alive = true;
    disposeed = false;
    name = options.name;
    components = new Entity(options.name);
    process = new Process(options.update == null ? update : options.update, {loop: true});
    init_components();
  }

  function init_components() {
    components.add(process);
    components.add(new Instance(this, GAMEOBJECT));
  }

  public function update(dt:Float) {}

  public function dispose() {
    alive = false;
    components.destroy();
    process = null;
    disposeed = true;
  }

  public function kill() {
    if (process != null) process.active = false;
    alive = false;
  }

  public function revive() {
    if (process != null) process.active = true;
    alive = true;
  }

  // getters
  function get_id():Int return components.id;

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
  var ?update:Float->Void;
}
