package ghost.component;

import ghost.util.Log;
#if heaps
import h2d.Tile;
import h2d.TileGroup;
#elseif openfl
import openfl.display.BitmapData;
import openfl.display.Tileset;
import openfl.display.Tilemap;
import openfl.geom.Rectangle;
#end
typedef TileRendererOptions = {
  tile_graphic:#if heaps Tile#elseif openfl BitmapData#end,
  ?tile_width:Int,
  ?tile_height:Int,
  ?tiles:Map<Int, #if heaps Tile #elseif openfl Rectangle #end>  
}
/**
 * TODO - move tile collision data into tilemap
 */
class TileRenderer extends Component {
  public var tile_width(default, null):Int;
  public var tile_height(default, null):Int;
  #if heaps
  public var tiles:Map<Int, Tile>;
  public var group:Null<TileGroup>;
  #elseif openfl
  public var tileset:Tileset;
  public var tilemap:Tilemap;
  #end

  public function new(?options:TileRendererOptions) {
    tiles = new Map();
    if (options != null) load(options);
  }

  override function added(component) {
    super.added(component);
    #if heaps
    if (group != null) entity.display.addChild(group);
    #elseif openfl
    #end
  }

  public function set(x:Int, y:Int, i:Int) {
    if (!tiles.exists(i)) return;
    #if heaps
    group.add(x * tile_width, y * tile_height, tiles.get(i));
    #end
  }

  public function load(options:TileRendererOptions) {
    if (options.tile_width == null) options.tile_width = Std.int(options.tile_graphic.height);
    if (options.tile_height == null) options.tile_height = options.tile_width;
    tile_width = options.tile_width;
    tile_height = options.tile_height;

    #if heaps
    if (group != null) {
      group.clear();
      group.tile = options.tile_graphic;
    }
    else group = new TileGroup(options.tile_graphic);

    if (entity != null) entity.display.addChild(group);

    tiles = [];
    var rows = Math.ceil(group.tile.height / tile_height);
    var columns = Math.ceil(group.tile.width / tile_width);
    var y = rows;
    while (y >= 0) {
      y--;
      var x = columns;
      while (x >= 0) {
        x--;
        tiles.set((y * columns) + x, group.tile.sub(x * tile_width, y * tile_height, tile_width, tile_height));
      }
    }
    if (options.tiles != null) {
      for (i => tile in options.tiles) {
        if (tile != null) tiles.set(i, tile);
      }
    }
    #end
  }
}
