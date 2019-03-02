package g2d;

h2d.TileGroup;
/**
 * TODO: An Entity preconfigured to be a TileMap.
 * Look into h2d.TileGroup for this
 */
class TileMap extends TileGroup {}

@:enum
abstract TileSlope(Int) {
  var NONE = 0;
  var NE = 1;
  var SE = 2;
  var SW = 3;
  var NW = 4;
}

class TileData {
  slope:TileSlope;
}
