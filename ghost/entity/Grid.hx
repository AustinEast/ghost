package ghost.entity;

import echo.Body;
import echo.data.Options;
import ghost.Entity;
import ghost.util.Color;
#if heaps
import h2d.Object;
import h2d.Graphics;
#elseif openfl
#end
class Grid extends Entity {
  // public var graphic:Graphics;
  public var map_data:Array<String>;
  public var legend:Map<String, Color>;
  public var width_in_cells:Int;
  public var height_in_cells:Int;
  public var cell_width:Int;
  public var cell_height:Int;
  public var colliders(default, null):Array<Body>;

  override function init() {
    super.init();
    // graphic = new Graphics(display);
    legend = new Map();
    colliders = [];
  }

  override function on_add(layer:Layer) {
    super.on_add(layer);
    for (b in colliders) layer.game.world.add(b);
  }

  override function remove() {
    for (b in colliders) b.remove();
    return super.remove();
  }

  public function load_from_array(data:Array<String>, width_in_cells:Int, height_in_cells:Int, cell_width:Int, cell_height:Int,
      collision:GridCollision = NONE) {
    map_data = data;
    this.width_in_cells = width_in_cells;
    this.height_in_cells = height_in_cells;
    this.cell_width = cell_width;
    this.cell_height = cell_height;

    load_map(collision);
  }

  public function load_from_2d_array(data:Array<Array<String>>, cell_width:Int, cell_height:Int, collision:GridCollision = NONE) {
    map_data = [];
    map_data = [for (row in data) for (i in row) i];
    width_in_cells = data[0].length;
    height_in_cells = data.length;
    this.cell_width = cell_width;
    this.cell_height = cell_height;

    load_map(collision);
  }

  function load_map(collision:GridCollision = NONE) {
    for (i in 0...map_data.length) {
      if (map_data[i] == "0") continue;

      if (legend.exists(map_data[i])) {
        var color = legend.get(map_data[i]);
        // graphic.beginFill(color, color.alpha);
      }
      // else graphic.beginFill();
      var x = i % width_in_cells;
      var y = Math.floor(i / width_in_cells);

      // graphic.drawRect(x * cell_width, y * cell_height, cell_width, cell_height);
      // graphic.endFill();
    }
    generate_collider(collision);
  }

  public function generate_collider(collision:GridCollision) {
    if (colliders != null) {
      for (body in colliders) body.remove();
      colliders.resize(0);
    }

    var map_data = [for (i in 0...map_data.length) map_data[i] == "0" ? 0 : 1];
    colliders = switch (collision) {
      case GRID: echo.util.TileMap.generate_grid(map_data, cell_width, cell_height, width_in_cells, height_in_cells, x, y, 0);
      case OPTIMIZED: echo.util.TileMap.generate(map_data, cell_width, cell_height, width_in_cells, height_in_cells, x, y, 0);
      default: [];
    }

    if (layer != null) for (body in colliders) {
      layer.game.world.add(body);
      layer.bodies.push(body);
    }
  }

  override function set_x(value:Float):Float {
    var dx = x - value;
    if (colliders != null) for (en in colliders) en.x += dx;

    return super.set_x(value);
  }

  override function set_y(value:Float):Float {
    var dy = y - value;
    if (colliders != null) for (en in colliders) en.y += dy;
    return super.set_y(value);
  }
}

@:enum
abstract GridCollision(Int) {
  var NONE = 0;
  var GRID = 1;
  var OPTIMIZED = 2;
}
