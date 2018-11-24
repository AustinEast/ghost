package ghost;

import ecs.system.SystemId;
import ghost.util.DataUtil;
import h2d.Mask;
import ghost.sys.Event;
import ghost.util.DestroyUtil;
import ecs.component.Component;
import ecs.system.System;
import ecs.entity.Entity;
import hxd.App;
/**
 * The Game Class bootstraps the creation of a HEAPS game.
 *
 * Once created, this class doesn't need to be interacted with directly.
 * Instead, look to the Game Manager (GM) Class for available properties and methods.
 */
class Game extends hxd.App implements IDestroyable {
  /**
   * Default Game Options.
   */
  public static var defaults(get, null):GameOptions;
  /**
   * The name of the Game.
   */
  public var name:String;
  /**
   * The version of the Game.
   */
  public var version:String;
  /**
   * The width of the screen in game pixels.
   */
  public var width(default, null):Int;
  /**
   * The height of the screen in game pixels.
   */
  public var height(default, null):Int;
  /**
   * The target framerate.
   */
  public var framerate:Int;
  /**
   * A Mask to constrain the root 2D Scene to the Game's width/height. Eventually will be replaced by camera system
   */
  public var root2d(default, null):Mask;
  /**
   * Flag to check if a game resize is requested.
   */
  public var resized:Bool;
  /**
   * Age of the Game (in Seconds).
   */
  public var age(default, null):Float;
  /**
   * Callback function that is called at the end of this Game's `init()`.
   * Useful for adding in game-wide Components and Systems from the Game's entry point.
   */
  public var on_init:Void->Void;
  /**
   * ECS Engine.
   */
  var ecs:ecs.Engine<Event>;
  /**
   * The Game Entity.
   */
  var entity:Entity;
  /**
   * Temporary store of initial_state to pass into the Game Component on `init()`.
   */
  var initial_state:Class<GameState>;
  /**
   * Creates a new Game and Initial State.
   * @param initial_state The Initial State the Game will load.
   * @param filesystem The type of FileSystem to initialize.
   * @param options Optional Parameters to configure the Game.
   */
  public function new(initial_state:Class<GameState>, filesystem:FileSystemOptions = EMBED, ?options:GameOptions) {
    super();

    options = DataUtil.copy_fields(options, Game.defaults);
    name = options.name;
    version = options.version;
    width = options.width <= 0 ? engine.width : options.width;
    height = options.height <= 0 ? engine.height : options.height;
    framerate = options.framerate;
    resized = false;

    this.initial_state = initial_state;
    this.age = 0;

    // Load the FileSystem
    // If we dont have access to macros, just `initEmbed()`
    #if macro
    switch (filesystem) {
      case EMBED:
        hxd.Res.initEmbed();
      case LOCAL:
        hxd.Res.initLocal();
      case PAK:
        hxd.Res.initPak();
    }
    #else
    hxd.Res.initEmbed();
    #end
  }

  override public function init() {
    root2d = new Mask(width, height, s2d);
    // Create the ECS Engine and Game Entity
    ecs = new ecs.Engine();
    entity = new Entity("Game");
    // Add our game components, then add the game entity to the ECS Engine
    entity.add(new ghost.hxd.component.States(initial_state));
    ecs.entities.add(entity);

    // Init the Game Manager
    GM.init(this, engine, entity);

    // Add the default Systems to the ECS Engine
    ecs.systems.add(new ghost.hxd.system.StateSystem(this), STATE);
    ecs.systems.add(new ghost.hxd.system.ScaleSystem(this, engine), SCALE);
    ecs.systems.add(new ghost.hxd.system.ProcessSystem(), PROCESS);
    ecs.systems.add(new ghost.h2d.system.BroadPhaseSystem(BroadPhaseEvent, {debug: true}, root2d), BROADPHASE);
    ecs.systems.add(new ghost.h2d.system.CollisionSystem(CollisionEvent, {debug: true}, root2d), COLLISION);
    ecs.systems.add(new ghost.h2d.system.PhysicsSystem(), PHYSICS);
    ecs.systems.add(new ghost.h2d.system.RenderSystem(root2d), RENDER);
    ecs.systems.add(new ghost.h2d.system.AnimationSystem(), ANIMATION);

    // Call the callback function if it's set
    if (on_init != null) on_init();

    // Call a resize event for good measure
    onResize();
  }

  @:dox(hide) @:noCompletion
  override public function update(dt:Float) {
    super.update(dt);
    age += dt;
    ecs.update(dt);
  }

  @:dox(hide) @:noCompletion
  override public function onResize() {
    super.onResize();
    resized = true;
  }
  /**
   * Adds a `Component` to the Game.
   * Useful for adding custom game-wide functionality that persists between states.
   * @param component `Component` to add.
   */
  public function add_component(component:Component) entity.add(component);
  /**
   * Removes a `Component` from the Game.
   * @param component `Component` to remove.
   */
  public function remove_component(component:Component) entity.remove(component);
  /**
   * Adds a `System` to the Game.
   * Useful for adding custom game-wide functionality that persists between states.
   * @param system `System` to add.
   * @param before The System to position the new System before. Defaults to the BroadPhase System.
   */
  public function add_system(system:System<Event>, before:SystemId = BROADPHASE) ecs.systems.addBefore(before, system);
  /**
   * Removes a `System` from the Game.
   * @param system `System` to remove.
   */
  public function remove_system(system:System<Event>) ecs.systems.remove(system);

  public function destroy() {
    ecs.destroy();
    dispose();
  }

  static function get_defaults() return {
    name: "Boost App",
    version: "0.0.0",
    width: 0,
    height: 0,
    framerate: 60
  }
}

typedef GameOptions = {
  ?name:String,
  ?version:String,
  ?width:Int,
  ?height:Int,
  ?framerate:Int
}

@:enum
abstract FileSystemOptions(Int) {
  var EMBED = 0;
  var LOCAL = 1;
  var PAK = 2;
}

@:enum
abstract GameSystems(String) from (String) to (SystemId) {
  var STATE = 'State';
  var SCALE = 'Scale';
  var PROCESS = 'Process';
  var BROADPHASE = 'BroadPhase';
  var COLLISION = 'Collision';
  var PHYSICS = 'Physics';
  var RENDER = 'Render';
  var ANIMATION = 'Animation';
}
