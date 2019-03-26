package h2d.ghost;

import echo.Body;
import echo.Group;
import h2d.component.Tiles;

class TileMap extends Entity {
  public var width(get, null):Float;
  public var height(get, null):Float;
  public var width_in_tiles(default, null):Int;
  public var height_in_tiles(default, null):Int;
  public var collider(default, null):Group;
  public var tiles:Tiles;

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
    if (collides) generate_collider_optimized();
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
    if (collides) generate_collider_optimized();
  }

  public function set_tiles() for (i in 0...map_data.length) {
    if (map_data[i] > start_index) {
      var x = i % width_in_tiles;
      var y = Math.floor(i / width_in_tiles);
      tiles.set(x, y, map_data[i]);
    }
  }

  function generate_collider_optimized() {
    inline function generate_rect(x:Float, y:Float, width:Int, height:Int) {
      var b = new Body({
        x: x * tiles.tile_width + ((tiles.tile_width * width) * 0.5),
        y: y * tiles.tile_height + (tiles.tile_height * height * 0.5),
        mass: 0,
        shape: {
          type: RECT,
          width: tiles.tile_width * width,
          height: tiles.tile_height * height
        }
      });
      if (world != null) world.add(b);
      collider.add(b);
    }
    collider.for_each(b -> b.remove());
    collider.clear();
    var tmp = new Array<Array<Int>>();
    for (i in 0...map_data.length) {
      var x = i % width_in_tiles;
      var y = Math.floor(i / width_in_tiles);
      if (tmp[y] == null) tmp[y] = [];
      tmp[y][x] = map_data[i];
    }
    for (y in 0...tmp.length) {
      var start_x = -1;
      var width = 0;
      var height = 1;
      for (x in 0...tmp[y].length) {
        var i = tmp[y][x];
        if (i != -1 && i != start_index && tiles.properties[i].solid) {
          if (start_x == -1) start_x = x;
          width += 1;
          tmp[y][x] = -1;
        }
        else {
          if (start_x != -1) {
            var yy = y + 1;
            var flag = false;
            while (yy < tmp.length - 1) {
              if (flag) {
                yy = tmp.length;
                continue;
              }
              for (j in 0...width) {
                if (tmp[yy][j + start_x] <= start_index || !tiles.properties[tmp[yy][j + start_x]].solid) flag = true;
              }
              if (!flag) {
                for (j in 0...width) {
                  tmp[yy][j + start_x] = -1;
                }
                height += 1;
              }
              yy += 1;
            }
            generate_rect(start_x, y, width, height);
            start_x = -1;
            width = 0;
            height = 1;
          }
        }
      }
      if (start_x != -1) {
        var yy = y + 1;
        var flag = false;
        while (yy < tmp.length - 1) {
          if (flag) {
            yy = tmp.length;
            continue;
          }
          for (j in 0...width) {
            if (tmp[yy][j + start_x] <= start_index || !tiles.properties[tmp[yy][j + start_x]].solid) flag = true;
          }
          if (!flag) {
            for (j in 0...width) {
              tmp[yy][j + start_x] = -1;
            }
            height += 1;
          }
          yy += 1;
        }
        generate_rect(start_x, y, width, height);
        start_x = -1;
        width = 0;
        height = 1;
      }
      refresh_cache();
    }
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

  function get_width():Float return width_in_tiles * tiles.tile_width;

  function get_height():Float return width_in_tiles * tiles.tile_height;

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
