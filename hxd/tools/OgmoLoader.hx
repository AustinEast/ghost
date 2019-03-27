package hxd.tools;

import h2d.ghost.TileMap;
import ghost.Disposable;

class OgmoLoader {
  public var width(get, null):Int;
  public var height(get, null):Int;

  var level:OgmoLevel;

  public function new(level:String) {
    this.level = haxe.Json.parse(level);
  }

  public function load_entities(loader:OgmoEntity->Void, layer:String) {
    var l = get_layer(layer);
    if (l.entities == null) throw('Layer ${layer} - Not An Entity Layer');
    for (entity in l.entities) loader(entity);
  }

  public function load_tilemap(tileset:h2d.Tile, tile_width:Int, tile_height, layer:String, collides:Bool = true):TileMap {
    var l = get_layer(layer);
    if (l.tileset == null || l.data == null) throw('Layer ${layer} - Not A Tile Layer');

    switch (l.exportMode) {
      case "Array2D":
        var map = new TileMap();
        map.load_from_2d_array(l.data, tileset, tile_width, tile_height, collides, -1);
        return map;
      default:
        throw('Export Mode ${l.exportMode} Is Not Supported');
    }
  }

  public function get_layer(layer:String):OgmoLayer {
    for (l in level.layers) {
      if (l.name.toLowerCase() == layer.toLowerCase()) return l;
    }
    throw('Layer ${layer} - Not Found');
  }

  inline function get_width():Int return level.width;

  inline function get_height():Int return level.height;
}

typedef OgmoLevel = {
  width:Int,
  height:Int,
  layers:Array<OgmoLayer>
}

typedef OgmoLayer = {
  name:String,
  ?tileset:String,
  ?exportMode:String,
  ?data:Dynamic,
  ?entities:Array<OgmoEntity>
}

typedef OgmoEntity = {
  name:String,
  id:Int,
  x:Int,
  y:Int
}
