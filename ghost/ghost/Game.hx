package ghost;

import ghost.entity.TileMap;
import ghost.Layer;
import ghost.system.AnimationSystem;
import ghost.util.NodeType;
import ghost.util.Nodes;
import ghost.util.Color;
import ghost.util.Group;
import echo.data.Options;
import echo.World;
import echo.util.JSON;
import ogmo.Project;
#if heaps
import h2d.Object;
import h3d.Engine;
import hxd.App;
#if debug
import ghost.debug.Debugger;
import ghost.debug.plugins.Stats;
import ghost.debug.plugins.EntityDrawer;
import ghost.debug.plugins.EchoDrawer;
#end
#elseif openfl
#end
class Game #if heaps extends hxd.App #end {
  /**
   * Default Game Options.
   */
  public static var defaults(get, null):GameOptions;
  /**
   * The width of the screen in game pixels.
   */
  public var width(default, null):Int;
  /**
   * The height of the screen in game pixels.
   */
  public var height(default, null):Int;
  #if heaps
  /**
   * The rate that the Game steps gameplay logic. This is separate from the rendering framerate (access that with `game.engine.fps`).
   */
  public var framerate(get, set):Float;
  #end
  /**
   * The loaded OGMO Project.
   */
  public var project(default, null):Project;

  public var levels(default, null):Group<Level>;
  public var layers(default, null):Group<TypedLayer<Entity>>;
  public var entities(default, null):Group<Entity>;
  public var systems(default, null):Group<System>;
  public var world(default, null):World;
  public var camera(default, null):Camera;
  /**
   * Age of the Game (in Seconds).
   */
  public var age(default, null):Float;

  #if (heaps && debug)
  public var debugger:ghost.debug.Debugger;
  #end

  var options:GameOptions;

  // TODO cache and reuse "Nodes" between systems
  // var nodes_cache:Map<NodeType, Nodes<Dynamic>>;

  public function new(?options:GameOptions) {
    super();

    this.options = JSON.copy_fields(options, Game.defaults);

    #if heaps
    // Load the FileSystem
    #if hl
    switch (this.options.filesystem) {
      case EMBED:
        hxd.Res.initEmbed();
      case LOCAL:
        hxd.Res.initLocal();
      case PAK:
        hxd.Res.initPak();
    }
    // If we arent building for hashlink, just embed the resources
    #else
    hxd.Res.initEmbed();
    #end
    #elseif openfl
    // TODO - sub to added_to_stage and update
    #end

    levels = new Group();
    layers = new Group();
    entities = new Group();
    systems = new Group();
  }

  #if heaps
  override function init() {
    super.init();
  #elseif openfl
  function init() {
  #end
    // Apply options
    width = options.width <= 0 ? #if heaps engine.width #elseif openfl Lib.current.stage.width #end : options.width;
    height = options.height <= 0 ? #if heaps engine.height #elseif openfl Lib.current.stage.height #end : options.height;
    if (options.world == null) options.world = {width: width, height: height};
    world = new World(options.world);
    age = 0;
    camera = new Camera(this);
    #if heaps
    framerate = options.framerate;
    // Set the default scale mode (for heaps)
    s2d.scaleMode = LetterBox(width, height, false, Center, Center);
    #if debug
    debugger = new Debugger(this);
    debugger.add(new Stats());
    debugger.add(new EntityDrawer());
    debugger.add(new EchoDrawer());
    #end
    #end
    // Add default systems
    add_system(new AnimationSystem());
    // Run user's start function
    if (options.start != null) options.start(this);
  }

  #if heaps
  override function update(dt:Float) {
    super.update(dt);
  #elseif openfl
  function update(dt:Float) {
  #end

    age += dt;
    // Step the Echo Physics simulation
    world.step(dt);
    // Step the Systems
    systems.for_each(s -> s.step(dt));
    // Run the user's step function
    if (options.step != null) options.step(this, dt);
    // Step each Layer and their contained Entities
    layers.for_each(l -> if (l.active && !l.disposed) l.step(dt));
    // Step the Camera
    camera.step(dt);
    #if heaps
    #if debug
    debugger.refresh();
    #end
    #end
  }
  #if heaps
  #if debug
  override function render(e:Engine) {
    super.render(e);
    debugger.render(e);
  }

  override function onResize() {
    super.onResize();
    debugger.resize();
  }
  #end
  #end
  public function load_project(data:String):Project {
    if (project != null) close_project();
    project = Project.create(data);
    #if heaps
    engine.backgroundColor = Color.fromString(project.backgroundColor, true);
    #elseif openfl
    // TODO - openfl background color
    #end
    for (template in project.layers) {
      switch template.definition {
        case DECAL:
          new TypedLayer<ghost.entity.Sprite>(template.name, this, template);
        case GRID:
          new TypedLayer<ghost.entity.Grid>(template.name, this, template);
        case TILE:
          new TypedLayer<ghost.entity.TileMap>(template.name, this, template);
        case ENTITY:
          new TypedLayer<ghost.Entity>(template.name, this, template);
      }
    }
    return project;
  }

  public function close_project() {
    // Close Levels
    for (level in levels) level.dispose();
    levels.clear();

    // Clear Layers
    for (layer in layers) layer.dispose();
    layers.clear();
  }

  public function load_level(data:String, update_world:Bool = true):Level {
    var level = new Level(data, this);
    levels.add(level);
    if (update_world) {
      world.x = level.data.offsetX;
      world.y = level.data.offsetY;
      world.width = level.data.width;
      world.height = level.data.height;
    }
    return level;
  }

  public inline function get_layer(name:String):Null<Layer> {
    return cast layers.get(layer -> return layer.name.toLowerCase() == name.toLowerCase());
  }

  public inline function get_decal_layer(name:String):Null<DecalLayer> {
    return cast layers.get(layer -> return layer.template != null
      && layer.template.definition == DECAL
      && layer.name.toLowerCase() == name.toLowerCase());
  }

  public inline function get_grid_layer(name:String):Null<GridLayer> {
    return cast layers.get(layer -> return layer.template != null
      && layer.template.definition == GRID
      && layer.name.toLowerCase() == name.toLowerCase());
  }

  public inline function get_tile_layer(name:String):Null<TileLayer> {
    return cast layers.get(layer -> return layer.template != null
      && layer.template.definition == TILE
      && layer.name.toLowerCase() == name.toLowerCase());
  }

  public function add_layer(layer:Layer):Layer {
    remove_layer(layer);
    layer.attach(this);
    return layer;
  }

  public function remove_layer(layer:Layer):Layer {
    if (layer.game == this) layer.detach();
    return layer;
  }
  /**
   * Gets the first `Entity` that has the requested name.
   * @param name The `String` to test against.
   * @return The first found `Entity`, if any.
   */
  public function get_entity(name:String):Null<Entity> return entities.get(e -> e.name == name);
  /**
   * Gets all `Entity`s that have the requested name.
   * @param name The `String` to test against.
   * @return All found `Entity`s. If none are found, the array will return empty.
   */
  public function get_all_entities(name:String):Array<Entity> return entities.get_all(e -> e.name == name);

  public function add_system(system:System) {
    if (!systems.has(system)) {
      systems.add(system);
      system.added(this);
    }
  }

  public function remove_system(system:System) {
    if (systems.remove(system)) {
      system.removed();
    }
  }

  #if heaps
  inline function get_framerate() return hxd.Timer.wantedFPS;

  inline function set_framerate(value:Float) return hxd.Timer.wantedFPS = value;
  #end

  static inline function get_defaults():GameOptions return {
    #if heaps
    filesystem: EMBED,
    #end
    width: 0,
    height: 0,
    framerate: 60
  }
}

typedef GameOptions = {
  /**
   * A Callback that is invoked when the Game is ready to start.
   */
  ?start:Game->Void,
  /**
   * A Callback that is invoked when the Game is stepped.
   */
  ?step:Game->Float->Void,
  /**
   * The width of the screen in game pixels.
   */
  ?width:Int,
  /**
   * The height of the screen in game pixels.
   */
  ?height:Int,
  ?world:WorldOptions,
  #if heaps ?filesystem:FileSystemOptions, ?framerate:Int, #end
}

#if heaps
@:enum
abstract FileSystemOptions(Int) {
  var EMBED;
  var LOCAL;
  var PAK;
}
#end
// @:enum
// abstract SystemPosition(Int) {
//   var PREWORLD;
//   var PRESTEP;
//   var POSTSTEP;
// }
