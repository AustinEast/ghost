package h2d.ghost;

import echo.Body;
import echo.Group;
import h2d.component.Tiles;

class TileMap extends Entity {
  public var width_in_tiles(default, null):Int;
  public var height_in_tiles(default, null):Int;
  public var collider(default, null):Group;

  var tiles:Tiles;
  var map_data:Array<Int>;
  var start_index:Int;

  public function new(x:Float = 0, y:Float = 0) {
    super({mass: 0, x: x, y: 0});
    tiles = new Tiles();
    components.add(tiles);
    map_data = [];
    collider = new Group();
  }

  override function added(state:GameState) {
    super.added(state);
    collider.for_each(b -> state.world.add(b));
  }

  override function removed(state:GameState) {
    super.removed(state);
    collider.for_each(b -> b.remove());
  }

  public function load_from_array(data:Array<Int>, width_in_tiles:Int, height_in_tiles:Int, tile_graphic:Tile, ?tile_width:Int, ?tile_height:Int,
      collides:Bool = true, start_index:Int = 0) {
    tiles.load({
      tile_graphic: tile_graphic,
      tile_width: tile_width,
      tile_height: tile_height
    });
    map_data = data;
    this.width_in_tiles = width_in_tiles;
    this.height_in_tiles = height_in_tiles;
    this.start_index = start_index;
    set_tiles();
    if (collides) generate_collider();
  }

  public function load_from_2d_array(data:Array<Array<Int>>, tile_graphic:Tile, ?tile_width:Int, ?tile_height:Int, collides:Bool = true, start_index:Int = 0) {
    tiles.load({
      tile_graphic: tile_graphic,
      tile_width: tile_width,
      tile_height: tile_height
    });
    map_data = [];
    map_data = [for (row in data) for (i in row) i];
    width_in_tiles = data[0].length;
    height_in_tiles = data.length;
    this.start_index = start_index;
    set_tiles();
    if (collides) generate_collider();
  }

  public function set_tiles() for (i in 0...map_data.length) {
    var x = i % width_in_tiles;
    var y = Math.floor(i / width_in_tiles);
    tiles.set(x, y, map_data[i - 1]);
  }

  function generate_collider() {
    collider.for_each(b -> b.remove());
    collider.clear();
    for (i in 0...map_data.length) {
      var index = map_data[i];
      if (index != -1 && index != start_index && tiles.properties[index].solid) {
        var b = new Body({
          x: (i % width_in_tiles) * tiles.tile_width,
          y: Math.floor(i / width_in_tiles) * tiles.tile_height,
          mass: 0,
          shape: {
            type: RECT,
            width: tiles.tile_width,
            height: tiles.tile_height,
            offset_x: tiles.tile_width * 0.5,
            offset_y: tiles.tile_height * 0.5
          }
        });
        if (world != null) world.add(b);
        collider.add(b);
      }
    }
  }

  override function set_x(value:Float):Float {
    return super.set_x(value);
    collider.for_each(b -> b.refresh_cache());
    refresh_cache();
  }

  override function set_y(value:Float):Float {
    return super.set_y(value);
    collider.for_each(b -> b.refresh_cache());
    refresh_cache();
  }
}
