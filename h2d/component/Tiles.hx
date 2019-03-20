package h2d.component;

import h2d.data.Data;
import h2d.data.Options;

class Tiles extends Component {
  public var tile_width(default, null):Int;
  public var tile_height(default, null):Int;
  public var properties:Array<TileData>;
  public var group:Null<TileGroup>;

  public function new(?options:TilesOptions) {
    super("tiles");
    properties = [];
    if (options != null) load(options);
  }

  override function added(component) {
    super.added(component);
    if (group != null) owner.base.addChild(group);
  }

  public function set(x:Int, y:Int, i:Int) {
    group.add(x * tile_width, y * tile_height, properties[i].graphic);
  }

  public function load(options:TilesOptions) {
    if (options.tile_width == null) options.tile_width = Std.int(options.tile_graphic.height);
    if (options.tile_height == null) options.tile_height = options.tile_width;
    tile_width = options.tile_width;
    tile_height = options.tile_height;
    if (group != null) {
      group.clear();
      group.tile = options.tile_graphic;
    }
    else group = new TileGroup(options.tile_graphic);
    if (owner != null) owner.base.addChild(group);
    properties = [];
    for (y in 0...Std.int(group.tile.height / tile_height)) for (x in 0...Std.int(group.tile.width / tile_width)) properties.push({
      graphic: group.tile.sub(x * tile_width, y * tile_height, tile_width, tile_height),
      solid: (y == 0 && x == 0) ? false : true
    });
  }
}
