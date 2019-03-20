package h2d.data;

typedef TileData = {
  var graphic:Tile;
  var solid:Bool;
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
