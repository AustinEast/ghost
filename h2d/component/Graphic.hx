package h2d.component;

import echo.shape.Rect;
import ghost.Color;
import ghost.Data;
import h2d.Bitmap;
import h2d.Tile;
import hxd.res.Image;
import ecs.component.Component;
/**
 * Graphic Component
 *
 * TODO: Default Graphic
 */
class Graphic extends Component {
  /**
   * Default Graphic Options
   *
   */
  public static var defaults(get, null):GraphicOptions;
  /**
   * Array of Tiles that this `Graphic` can display.
   * Each Tile can be thought of as a frame of an animation.
   */
  public var frames:Array<Tile>;
  /**
   * The index of the Tile (from `frames`) that is being displayed.
   */
  public var current_frame:Int;
  /**
   * Flag to set if this `Graphic` will be displayed.
   * Alias for `bitmap.visible`.
   */
  public var visible(get, set):Bool;
  /**
   * Width of the `Graphic`. Can change depending on the current frame.
   * Alias for `bitmap.tile.width`.
   */
  public var width(get, null):Int;
  /**
   * Height of the `Graphic`. Can change depending on the current frame.
   * Alias for `bitmap.tile.height`.
   */
  public var height(get, null):Int;
  /**
   * The X offset of the `Graphic` from it's `Transform`.
   */
  public var dx(default, set):Int;
  /**
   * The Y offset of the `Graphic` from it's `Transform`.
   */
  public var dy(default, set):Int;
  public var flip_x(default, set):Bool = false;
  public var flip_y(default, set):Bool = false;
  public var bitmap(default, null):Bitmap;

  public function new(?options:GraphicOptions) {
    options = Data.copy_fields(options, defaults);
    bitmap = options.bitmap;
    bitmap.tile != null ? frames = [bitmap.tile] : frames = [];
    center_offset();
    current_frame = 0;
  }
  /**
   * Loads an Image asset to be displayed by the Entity.
   * @param asset The Image asset to load.
   * @param Graphic_sheet Flag the set whether the Image is a Sprite Sheet.
   * @param width Width of the Graphic. This only needs to be set if the Image is a Sprite Sheet.
   * @param height Height of the Graphic. This only needs to be set if the Image is a Sprite Sheet.
   */
  public function load(asset:Image, sprite_sheet:Bool = false, width:Int = 0, height:Int = 0) {
    clear_frames();
    current_frame = 0;
    if (sprite_sheet) {
      var t = asset.toTile();
      frames = [
        for (y in 0...Std.int(t.height / height)) {
          for (x in 0...Std.int(t.width / width)) {
            t.sub(x * width, y * height, width, height);
          }
        }
      ];
    }
    else frames[0] = asset.toTile();
    bitmap.tile = frames[0];
    center_offset();
  }

  public function from_tile(tile:Tile) {
    clear_frames();
    current_frame = 0;
    frames[0] = tile;
  }

  public function from_tiles(tiles:Array<Tile>) {
    clear_frames();
    current_frame = 0;
    frames = tiles;
  }
  /**
   * Creates a Colored Rectangle to be displayed by the Entity.
   * @param width Width of the Graphic.
   * @param height Height of the Graphic.
   * @param color Color of the Graphic.
   * @param alpha Alpha of the Graphic.
   */
  public function make(width:Int, height:Int, color:Int = Color.WHITE, alpha:Float = 1) {
    clear_frames();
    current_frame = 0;
    frames[current_frame] = Tile.fromColor(color, width, height, alpha);
    bitmap.tile = frames[current_frame];
    center_offset();
  }
  /**
   * Centers the Graphic's offset.
   */
  public function center_offset() {
    dx = -Math.floor(width * 0.5);
    dy = -Math.floor(height * 0.5);
  }

  public function bounds():Rect return Rect.get(0, 0, width, height);

  inline function clear_frames() while (frames.length > 0) frames.pop().dispose();

  inline function update_frames() for (frame in frames) {
    frame.dx = dx;
    frame.dy = dy;
  }

  // getters
  function get_visible():Bool return bitmap.visible;

  function get_width():Int return bitmap.tile == null ? 0 : bitmap.tile.width;

  function get_height():Int return bitmap.tile == null ? 0 : bitmap.tile.height;

  // setters
  function set_visible(value:Bool):Bool return bitmap.visible = value;

  function set_dx(value:Int) {
    for (frame in frames) frame.dx = value;
    return dx = value;
  }

  function set_dy(value:Int) {
    for (frame in frames) frame.dy = value;
    return dy = value;
  }

  function set_flip_x(value:Bool) {
    if (flip_x != value) for (frame in frames) frame.flipX();
    return flip_x = value;
  }

  function set_flip_y(value:Bool) {
    if (flip_y != value) for (frame in frames) frame.flipY();
    return flip_y = value;
  }

  static function get_defaults():GraphicOptions return {
    bitmap: new Bitmap()
  }
}

typedef GraphicOptions = {
  var ?bitmap:Bitmap;
}
