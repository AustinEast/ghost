package gxd;

import h2d.Layers;
import ecs.system.SystemId;
import ecs.component.Component;
import ecs.system.System;
import ecs.entity.Entity;
import glib.Data;
import glib.Disposable;
import h2d.Mask;
import hxd.App;
/**
 * The Game Class bootstraps the creation of a HEAPS game.
 *
 * Once created, this class doesn't need to be interacted with directly.
 * Instead, look to the Game Manager (GM) Class for available properties and methods.
 */
class Game extends hxd.App implements IDisposable {
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
   *
   */
  public var world(default, null):g2d.system.BroadPhaseSystem;
  /**
   *
   */
  public var collisions(default, null):g2d.system.CollisionSystem;
  /**
   *
   */
  public var physics(default, null):g2d.system.PhysicsSystem;
  /**
   * A Mask to constrain the root 2D Scene to the Game's width/height. Eventually will be replaced by camera system
   */
  public var root2d(default, null):Mask;
  /**
   * Layers Object that `h2d` Entities will be displayed on. Eventually will be replaced by camera system
   */
  public var viewport(default, null):Layers;
  /**
   * Layers Object that ui will be displayed on. Eventually will be replaced by camera system
   */
  public var ui(default, null):Layers;
  /**
   * Age of the Game (in Seconds).
   */
  public var age(default, null):Float;
  /**
   * Callback function that is called at the end of this Game's `init()`.
   *
   * This acts as the Game's main entry point for adding in GameStates, GameObjects, Components, and Systems.
   */
  public var create:Void->Void;
  /**
   * ECS Engine.
   */
  var ecs:ecs.Engine<Event>;
  /**
   * The Game Entity.
   */
  var entity:Entity;
  /**
   * Creates a new Game.
   * @param filesystem The type of FileSystem to initialize.
   * @param options Optional Parameters to configure the Game.
   */
  public function new(filesystem:FileSystemOptions = EMBED, ?options:GameOptions) {
    super();
    options = Data.copy_fields(options, Game.defaults);

    ecs = new ecs.Engine();
    entity = new Entity("Game");

    name = options.name;
    version = options.version;
    width = options.width <= 0 ? engine.width : options.width;
    height = options.height <= 0 ? engine.height : options.height;
    hxd.Timer.wantedFPS = options.framerate;

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
    viewport = new Layers(root2d);
    ui = new Layers(root2d);

    // Add the game entity to the ECS Engine
    ecs.entities.add(entity);

    // Init the Game Manager
    GM.init(this, engine, entity);

    // Get reference to some of our systems
    world = new g2d.system.BroadPhaseSystem(Event.BroadPhaseEvent);
    collisions = new g2d.system.CollisionSystem(Event.CollisionEvent, null, root2d);
    physics = new g2d.system.PhysicsSystem(null, root2d);

    // Add the default Systems to the ECS Engine
    ecs.systems.add(new gxd.system.StateSystem(this), STATE);
    ecs.systems.add(new gxd.system.UpdateSystem(), UPDATE);
    ecs.systems.add(world, BROADPHASE);
    ecs.systems.add(collisions, COLLISION);
    ecs.systems.add(physics, PHYSICS);
    ecs.systems.add(new g2d.system.RenderSystem(viewport), RENDER);
    ecs.systems.add(new g2d.system.AnimationSystem(), ANIMATION);

    // Call the callback function if it's set
    if (create != null) create();

    // Call a resize event for good measure
    onResize();
  }

  @:dox(hide) @:noCompletion
  override public function update(dt:Float) {
    age += dt;
    ecs.update(dt);
  }

  @:dox(hide) @:noCompletion
  override public function onResize() {
    var scaleFactorX:Float = engine.width / width;
    var scaleFactorY:Float = engine.height / height;
    var scaleFactor:Float = Math.min(scaleFactorX, scaleFactorY);
    if (scaleFactor < 1) scaleFactor = 1;

    root2d.setScale(scaleFactor);
    root2d.setPosition(engine.width * 0.5 - (width * scaleFactor) * 0.5, engine.height * 0.5 - (height * scaleFactor) * 0.5);
  }
  /**
   * Adds a GameObject to the Game.
   * @param object The GameObject to add.
   * @return The added GameObject. Useful for chaining.
   */
  public function add(object:GameObject):GameObject {
    ecs.entities.add(object.components);
    return object;
  }
  /**
   * Removes a GameObject from the Game.
   * @param object The GameObject to remove.
   * @return The removed GameObject. Useful for chaining.
   */
  public function remove(object:GameObject):GameObject {
    ecs.entities.remove(object.components);
    return object;
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

  override public function dispose() {
    ecs.destroy();
    dispose();
  }

  static function get_defaults() return {
    name: "Ghost App",
    version: "0.0.0",
    width: 0,
    height: 0,
    framerate: 60
  }
}

typedef GameOptions = {
  var ?name:String;
  var ?version:String;
  var ?width:Int;
  var ?height:Int;
  var ?framerate:Int;
}

@:enum
abstract FileSystemOptions(Int) {
  var EMBED = 0;
  var LOCAL = 1;
  var PAK = 2;
}

@:enum
abstract GameSystems(String) from(String) to(SystemId) {
  var STATE = 'State';
  var UPDATE = 'Update';
  var BROADPHASE = 'BroadPhase';
  var COLLISION = 'Collision';
  var PHYSICS = 'Physics';
  var RENDER = 'Render';
  var ANIMATION = 'Animation';
}
