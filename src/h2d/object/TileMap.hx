package h2d.object;

import ecs.entity.Entity;
/**
 * TODO: An Entity preconfigured to be a TileMap.
 * Look into h2d.TileGroup for this
 */
class TileMap extends Entity {}

@:enum
abstract TileSlope(Int) {
  var NONE = 0;
  var NE = 1;
  var SE = 2;
  var SW = 3;
  var NW = 4;
}
