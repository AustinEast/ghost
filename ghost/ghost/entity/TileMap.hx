package ghost.entity;

import echo.Body;
import echo.Shape;
import ghost.Entity.EntityOptions;
import ghost.component.TileRenderer;
import hxmath.math.IntVector2;

class TileMap extends Entity {
  public var width(get, null):Int;
  public var height(get, null):Int;
  public var width_in_tiles(default, null):Int;
  public var height_in_tiles(default, null):Int;
  public var colliders(default, null):Array<Body>;
  public var renderer:TileRenderer;
  public var tile_shapes:Map<Int, Shape>;

  var map_data:Array<Int>;
  var start_index:Int;

  public function new(?options:EntityOptions) {
    colliders = [];
    if (options == null) options = {};
    if (options.body == null) options.body = {};
    if (options.body.mass == null) options.body.mass = 0;
    super(options);
    renderer = new TileRenderer();
    components.add(renderer);
    map_data = [];
    tile_shapes = new Map();
  }

  override function on_add(layer:Layer) {
    super.on_add(layer);
    for (b in colliders) {
      layer.game.world.add(b);
      layer.bodies.push(b);
    }
  }

  override function remove() {
    for (b in colliders) {
      if (layer != null) layer.bodies.remove(b);
      b.remove();
    }
    return super.remove();
  }

  public function load_from_array(data:Array<Int>, width_in_tiles:Int, height_in_tiles:Int, graphics:TileRendererOptions, ?shapes:Map<Int, Shape>,
      collision:TileCollision = NONE, start_index:Int = 0) {
    map_data = data;
    this.width_in_tiles = width_in_tiles;
    this.height_in_tiles = height_in_tiles;
    if (shapes != null) tile_shapes = shapes;
    load_map(graphics, collision, start_index);
  }

  public function load_from_2d_array(data:Array<Array<Int>>, graphics:TileRendererOptions, ?shapes:Map<Int, Shape>, collision:TileCollision = NONE,
      start_index:Int = 0) {
    map_data = [];
    map_data = [for (row in data) for (i in row) i];
    width_in_tiles = data[0].length;
    height_in_tiles = data.length;
    if (shapes != null) tile_shapes = shapes;
    load_map(graphics, collision, start_index);
  }

  function load_map(graphics:TileRendererOptions, collision:TileCollision = NONE, start_index:Int = 0) {
    renderer.load(graphics);
    this.start_index = start_index;
    set_tiles();
    generate_collider(collision);
  }

  public function get_tile_index(x:Int, y:Int):Int {
    return x + width_in_tiles * y;
  }

  public function get_tile_coordinates(index:Int, ?int_vec2:IntVector2):IntVector2 {
    var x = index % width_in_tiles;
    var y = Math.floor(index / width_in_tiles);
    return int_vec2 == null ? new IntVector2(x, y) : int_vec2.set(x, y);
  }

  public function set_tiles() for (i in 0...map_data.length) {
    if (map_data[i] > start_index) {
      var x = i % width_in_tiles;
      var y = Math.floor(i / width_in_tiles);
      renderer.set(x, y, map_data[i]);
    }
  }

  public function generate_collider(collision:TileCollision) {
    if (colliders != null) {
      for (body in colliders) body.remove();
      colliders.resize(0);
    }
    colliders = switch (collision) {
      case GRID: echo.util.TileMap.generate_grid(map_data, renderer.tile_width, renderer.tile_height, width_in_tiles, height_in_tiles, x, y, start_index);
      case OPTIMIZED: echo.util.TileMap.generate(map_data, renderer.tile_width, renderer.tile_height, width_in_tiles, height_in_tiles, x, y, start_index);
      default: [];
    }
    if (layer != null) for (body in colliders) {
      layer.game.world.add(body);
      layer.bodies.push(body);
    }
  }

  function get_width():Int return width_in_tiles * renderer.tile_width;

  function get_height():Int return height_in_tiles * renderer.tile_height;

  override function set_x(value:Float):Float {
    var dx = x - value;
    for (en in colliders) {
      en.x += dx;
    }
    return super.set_x(value);
  }

  override function set_y(value:Float):Float {
    var dy = y - value;
    for (en in colliders) {
      en.y += dy;
    }
    return super.set_y(value);
  }
}

@:enum
abstract TileCollision(Int) {
  var NONE = 0;
  var GRID = 1;
  var OPTIMIZED = 2;
}

typedef TileData = {
  var ?graphic:#if heaps h2d.Tile #elseif openfl openfl.geom.Rectangle #end;
  var ?shape:TileShape;
}

@:enum
abstract TileShape(Int) {
  var NONE = 0;
  var FULL = 1;
  var NE = 2;
  var SE = 3;
  var SW = 4;
  var NW = 5;
}
