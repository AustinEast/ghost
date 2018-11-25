package ghost.h2d.component;

import h2d.Bitmap;
import h2d.Tile;
import hxd.res.Image;
import ghost.util.Color;
import ecs.component.Component;

class Sprite extends Component {
  // public static var default_frame:Tile = DefaultFont.get()
  /**
   * Array of Tiles that this `Sprite` can display.
   * Each Tile can be thought of as a frame of an animation.
   */
  public var frames:Array<Tile>;
  /**
   * The index of the Tile (from `frames`) that is being displayed.
   */
  public var current_frame:Int;
  /**
   * Flag to set if this `Sprite` will be displayed.
   * Alias for `bitmap.visible`.
   */
  public var visible(get, set):Bool;
  /**
   * Width of the `Sprite`. Can change depending on the current frame.
   * Alias for `bitmap.tile.width`.
   */
  public var width(get, null):Int;
  /**
   * Height of the `Sprite`. Can change depending on the current frame.
   * Alias for `bitmap.tile.height`.
   */
  public var height(get, null):Int;
  /**
   * The X offset of the `Sprite` from it's `Transform`.
   */
  public var dx(default, set):Int;
  /**
   * The Y offset of the `Sprite` from it's `Transform`.
   */
  public var dy(default, set):Int;
  public var bitmap:Bitmap;

  public function new(?bitmap:Bitmap) {
    this.bitmap = bitmap == null ? new Bitmap() : bitmap;
    this.bitmap.tile != null ? frames = [this.bitmap.tile] : frames = [];
    center_offset();
    current_frame = 0;
  }
  /**
   * Loads an Image asset to be displayed by the Entity.
   * @param asset The Image asset to load.
   * @param sprite_sheet Flag the set whether the Image is a Sprite Sheet.
   * @param width Width of the Sprite. This only needs to be set if the Image is a Sprite Sheet.
   * @param height Height of the Sprite. This only needs to be set if the Image is a Sprite Sheet.
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
    } else frames[0] = asset.toTile();
    bitmap.tile = frames[0];
    center_offset();
  }
  /**
   * Creates a Colored Rectangle to be displayed by the Entity.
   * @param width Width of the Sprite.
   * @param height Height of the Sprite.
   * @param color Color of the Sprite.
   * @param alpha Alpha of the Sprite.
   */
  public function make(width:Int, height:Int, color:Int = Color.WHITE, alpha:Float = 1) {
    clear_frames();
    current_frame = 0;
    frames[current_frame] = Tile.fromColor(color, width, height, alpha);
    bitmap.tile = frames[current_frame];
    center_offset();
  }
  /**
   * Centers the Sprite's offset.
   */
  public function center_offset() {
    dx = -Math.floor(width * 0.5);
    dy = -Math.floor(height * 0.5);
  }

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
}
