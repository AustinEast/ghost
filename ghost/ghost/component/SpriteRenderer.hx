package ghost.component;

import hxmath.math.Vector2;
import echo.util.JSON;
import echo.shape.Rect;
import ghost.data.Animations;
import ghost.util.Color;
#if heaps
import h2d.Bitmap;
import h2d.Tile;
import hxd.res.Image;
#elseif openfl
import openfl.display.BitmapData;
import openfl.display.Tilemap;
import openfl.display.Tile;
import openfl.geom.Rectangle;
#end
typedef SpriteRendererOptions = {
  ?asset:#if heaps Image #elseif openfl BitmapData #end,
  ?animated:Bool,
  ?width:Int,
  ?height:Int,
  ?offset_x:Float,
  ?offset_y:Float,
  ?scale_x:Float,
  ?scale_y:Float,
  ?flip_x:Bool,
  ?flip_y:Bool,
  ?animations:Array<Animation>
}

typedef SpriteFrame = #if heaps Tile #elseif openfl {

}
#end

/**
 * Sprite Renderer Component
 */
class SpriteRenderer extends Component {
  /**
   * Default Sprite Renderer Options
   */
  public static var defaults(get, null):SpriteRendererOptions;

  public var animations:Animations;
  /**
   * Array of frames that this `SpriteRenderer` can display.
   * Each item can be thought of as a frame of an animation.
   */
  public var frames:Array<SpriteFrame>;
  /**
   * The index of the Tile (from `frames`) that is being displayed.
   */
  public var current_frame:Int;
  /**
   * Flag to set if this `SpriteRenderer` will be displayed.
   * Alias for `bitmap.visible`.
   */
  public var visible(get, set):Bool;
  /**
   * Width of the `SpriteRenderer`. Can change depending on the current frame.
   * Alias for `bitmap.tile.width`.
   */
  public var width(get, null):Float;
  /**
   * Height of the `SpriteRenderer`. Can change depending on the current frame.
   * Alias for `bitmap.tile.height`.
   */
  public var height(get, null):Float;
  /**
   * The X offset of the `SpriteRenderer` from it's `Transform`.
   */
  public var dx(default, set):Float;
  /**
   * The Y offset of the `SpriteRenderer` from it's `Transform`.
   */
  public var dy(default, set):Float;

  public var scale_x(get, set):Float;
  public var scale_y(get, set):Float;
  public var flip_x(default, set):Bool = false;
  public var flip_y(default, set):Bool = false;
  #if heaps
  public var bitmap(default, null):Bitmap;
  #elseif openfl
  var tilemap:Tilemap;
  var tile:Tile;
  #end

  public function new(?options:SpriteRendererOptions) {
    options = JSON.copy_fields(options, defaults);
    bitmap = new Bitmap();
    frames = [];
    dx = options.offset_x != null ? options.offset_x : 0;
    dy = options.offset_y != null ? options.offset_y : 0;
    if (options.scale_x != null) scale_x = options.scale_x;
    if (options.scale_y != null) scale_y = options.scale_y;
    if (options.flip_x != null) flip_x = options.flip_x;
    if (options.flip_y != null) flip_x = options.flip_y;
    if (options.asset != null) load(options.asset, options.animated, options.width, options.height);
    current_frame = 0;
    animations = new Animations(options.animations);
  }

  override function added(component) {
    super.added(component);
    entity.display.addChild(bitmap);
  }
  /**
   * Loads an Image asset to be displayed by the Entity.
   * @param asset The Image asset to load.
   * @param sprite_sheet Flag to set whether the Image is a Sprite Sheet or just a single frame.
   * @param width Width of the Sprite. This only needs to be set if the Image is a Sprite Sheet.
   * @param height Height of the Sprite. This only needs to be set if the Image is a Sprite Sheet.
   */
  public function load(asset:Image, sprite_sheet:Bool = false, width:Int = 0, height:Int = 0) {
    clear_frames();
    current_frame = 0;
    var t = asset.toTile();
    if (sprite_sheet) {
      frames = [
        for (y in 0...Std.int(t.height / height)) {
          for (x in 0...Std.int(t.width / width)) {
            t.sub(x * width, y * height, width, height);
          }
        }
      ];
    }
    else frames[0] = t;
    update_frames();
    #if heaps bitmap.tile #elseif openfl tile.rect #end = frames[current_frame];
  }

  #if heaps
  public function from_tile(tile:Tile) {
    clear_frames();
    current_frame = 0;
    frames[0] = tile;
    update_frames();
    bitmap.tile = frames[current_frame];
  }

  public function from_tiles(tiles:Array<Tile>) {
    clear_frames();
    current_frame = 0;
    frames = tiles;
    update_frames();
    bitmap.tile = frames[current_frame];
  }
  #end
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
    update_frames();
    bitmap.tile = frames[current_frame];
  }

  public inline function set_offset(dx:Float, dy:Float, update_position:Bool = false) {
    this.dx = dx;
    this.dy = dy;

    if (update_position) {
      entity.x += dx;
      entity.y += dy;
    }
  }
  /**
   * Centers the Sprite's offset.
   */
  public inline function center_offset(update_position:Bool = false) {
    set_offset(-width * 0.5, -height * 0.5, update_position);
  }

  public inline function bounds():Rect return Rect.get(dx, dy, width, height);

  public inline function center():Vector2 return new Vector2(dx, dy);

  inline function clear_frames() while (frames.length > 0) {
    var f = frames.pop();
    #if heaps
    if (f != null) f.dispose();
    #end
  }

  inline function update_frames() for (frame in frames) if (frame != null) {
    frame.dx = dx;
    frame.dy = dy;
    if (flip_x) frame.flipX();
    if (flip_y) frame.flipY();
  }

  // getters
  inline function get_visible():Bool return bitmap.visible;

  inline function get_width():Float return bitmap.tile == null ? 0 : bitmap.tile.width;

  inline function get_height():Float return bitmap.tile == null ? 0 : bitmap.tile.height;

  inline function get_scale_x() return bitmap.scaleX;

  inline function get_scale_y() return bitmap.scaleY;

  // setters
  inline function set_visible(value:Bool):Bool return bitmap.visible = value;

  inline function set_dx(value:Float) {
    for (frame in frames) frame.dx = value;
    return dx = value;
  }

  inline function set_dy(value:Float) {
    for (frame in frames) frame.dy = value;
    return dy = value;
  }

  inline function set_scale_x(value:Float) return bitmap.scaleX = value;

  inline function set_scale_y(value:Float) return bitmap.scaleY = value;

  inline function set_flip_x(value:Bool) {
    if (flip_x != value) for (frame in frames) frame.flipX();
    return flip_x = value;
  }

  inline function set_flip_y(value:Bool) {
    if (flip_y != value) for (frame in frames) frame.flipY();
    return flip_y = value;
  }

  inline static function get_defaults():SpriteRendererOptions return {
    animated: false,
    width: 0,
    height: 0
  }
}
