package ghost.component;

typedef TileRendererOptions = {
  asset:String,
  tile_width:Int,
  ?tile_height:Int
}

class TileRenderer extends Component {
  public var tile_width(default, null):Int;
  public var tile_height(default, null):Int;

  public function new(?options:TileRendererOptions) {
    // tiles = new Map();
    if (options != null) load(options);
  }

  public function set(x:Int, y:Int, i:Int) {}

  public function load(options:TileRendererOptions) {
    if (options.tile_height == null) options.tile_height = options.tile_width;
    tile_width = options.tile_width;
    tile_height = options.tile_height;
  }
}
