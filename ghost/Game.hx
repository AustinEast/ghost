package ghost;

import ghost.entity.Grid;
import ghost.entity.Sprite;
import ghost.entity.TileMap;
import ghost.Layer;
import ghost.system.AnimationSystem;
import ghost.util.Color;
import ghost.util.Group;
import echo.data.Options;
import echo.World;
import echo.util.JSON;
import ogmo.Project;

class Game {
  /**
   * Default Game Options.
   */
  public static var defaults(get, null):GameOptions;
  /**
   * The width of the Game Engine in pixels.
   */
  public var width(default, null):Int;
  /**
   * The height of the Game Engine in pixels.
   */
  public var height(default, null):Int;
  /**
   * The loaded OGMO Project.
   */
  public var project(default, null):Project;

  public var levels(default, null):Group<Level>;
  public var layers(default, null):Group<TypedLayer<Entity>>;
  public var entities(default, null):Group<Entity>;
  public var systems(default, null):Group<System>;
  public var world(default, null):World;
  public var sprite_class(default, null):Class<Sprite>;
  public var tilemap_class(default, null):Class<TileMap>;
  public var grid_class(default, null):Class<Grid>;
  /**
   * Age of the Game Engine (in Seconds).
   */
  public var age(default, null):Float;

  // TODO cache and reuse "Nodes" between systems
  // var nodes_cache:Map<NodeType, Nodes<Dynamic>>;
  /**
   * Makes a new Game Engine.
   * @param width The width of the Game Engine in pixels.
   * @param height The height of the Game Engine in pixels.
   * @param options
   */
  public function new(width:Int, height:Int, ?options:GameOptions) {
    levels = new Group();
    layers = new Group();
    entities = new Group();
    systems = new Group();

    options = JSON.copy_fields(options, Game.defaults);

    // Apply options
    this.width = width;
    this.height = height;
    sprite_class = options.sprite;
    tilemap_class = options.tilemap;
    grid_class = options.grid;
    if (options.world == null) options.world = {width: width, height: height};
    world = new World(options.world);
    age = 0;

    add_system(new AnimationSystem());
  }

  public function update(dt:Float) {
    age += dt;
    // Step the Echo Physics simulation
    world.step(dt);
    // Step the Systems
    systems.for_each(s -> s.step(dt));
    // Step each Layer and their contained Entities
    layers.for_each(l -> if (l.active && !l.disposed) l.step(dt));
  }

  public function load_project(data:String):Project {
    if (project != null) close_project();
    project = Project.create(data);

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
    if (levels.count > 0) {
      for (level in levels) level.dispose();
      levels.clear();
    }

    // Clear Layers
    if (layers.count > 0) {
      for (layer in layers) layer.dispose();
      layers.clear();
    }
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

  static inline function get_defaults():GameOptions return {
    sprite: Sprite,
    tilemap: TileMap,
    grid: Grid
  }
}
/**
 * Options for a new Game Game.
 */
typedef GameOptions = {
  ?world:WorldOptions,
  ?sprite:Class<Sprite>,
  ?tilemap:Class<TileMap>,
  ?grid:Class<Grid>
}

// @:enum
// abstract SystemPosition(Int) {
//   var PREWORLD;
//   var PRESTEP;
//   var POSTSTEP;
// }
