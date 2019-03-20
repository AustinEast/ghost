package h2d.ghost;

import h2d.component.Tiles;

class TileMap extends Entity {
  public var width_in_tiles(default, null):Int;
  public var height_in_tiles(default, null):Int;

  var tiles:Tiles;
  var map_data:Array<Array<Int>>;
  var start_index:Int;

  public function new(x:Float = 0, y:Float = 0) {
    super({
      mass: 0
    });
    tiles = new Tiles();
    components.add(tiles);
    map_data = [];
  }

  public function load_from_2D_Array(data:Array<Array<Int>>, tile_graphic:Tile, ?tile_width:Int, ?tile_height:Int, start_index:Int = 0,
      collides:Bool = true) {
    tiles.load({
      tile_graphic: tile_graphic,
      tile_width: tile_width,
      tile_height: tile_height
    });
    map_data = data;
    this.start_index = start_index;
    for (y in 0...data.length) for (x in 0...data[y].length) if (data[y][x] > start_index) tiles.set(x, y, data[y][x]);
    if (collides) generate_collider();
  }
  /**
   * TODO optimize generated rects on the y-axis
   */
  function generate_collider() {
    inline function generate_rect(y, start, len) {
      add_shape({
        offset_x: start * tiles.tile_width + ((tiles.tile_width * len) * 0.5),
        offset_y: y * tiles.tile_height + (tiles.tile_height * 0.5),
        type: RECT,
        width: tiles.tile_width * len,
        height: tiles.tile_height
      });
    }
    var tmp = [for (i in 0...map_data.length) [for (j in 0...map_data[i].length) map_data[i][j]]];
    for (y in 0...tmp.length) {
      var start = -1;
      var len = 0;
      for (x in 0...tmp[y].length) {
        var i = tmp[y][x];
        if (i != -1 && i != start_index && tiles.properties[i].solid) {
          if (start == -1) start = x;
          len += 1;
          tmp[y][x] = -1;
        }
        else {
          if (start != -1) {
            generate_rect(y, start, len);
            start = -1;
            len = 0;
          }
        }
      }
      if (start != -1) {
        generate_rect(y, start, len);
        start = -1;
        len = 0;
      }
      refresh_cache();
    }
  }

  override function set_x(value:Float):Float {
    return super.set_x(value);
    refresh_cache();
  }

  override function set_y(value:Float):Float {
    return super.set_y(value);
    refresh_cache();
  }
}
