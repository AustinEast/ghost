package ghost.component;

import hxmath.math.Vector2;
import echo.util.JSON;
import echo.shape.Rect;
import ghost.util.Color;

typedef SpriteRendererOptions = {
  ?asset:String,
  ?animated:Bool,
  ?width:Int,
  ?height:Int,
  ?offset_x:Float,
  ?offset_y:Float,
  ?scale_x:Float,
  ?scale_y:Float,
  ?flip_x:Bool,
  ?flip_y:Bool,
}
/**
 * Sprite Renderer Component
 */
class SpriteRenderer extends Component {
  /**
   * Default Sprite Renderer Options
   */
  public static var defaults(get, null):SpriteRendererOptions;
  /**
   * Flag to set if this `SpriteRenderer` will be displayed.
   */
  public var visible(get, set):Bool;
  /**
   * Width of the `SpriteRenderer`. Can change depending on the current frame.
   */
  public var width(get, null):Float;
  /**
   * Height of the `SpriteRenderer`. Can change depending on the current frame.
   */
  public var height(get, null):Float;
  /**
   * The X offset of the `SpriteRenderer` from it's Entity.
   */
  public var offset_x(default, set):Float;
  /**
   * The Y offset of the `SpriteRenderer` from it's Entity.
   */
  public var offset_y(default, set):Float;

  public var scale_x(get, set):Float;
  public var scale_y(get, set):Float;
  public var flip_x(default, set):Bool = false;
  public var flip_y(default, set):Bool = false;

  public var dirty:Bool;

  var last_x:Float;
  var last_y:Float;

  public function new(?options:SpriteRendererOptions) {
    options = JSON.copy_fields(options, defaults);
    offset_x = options.offset_x != null ? options.offset_x : 0;
    offset_y = options.offset_y != null ? options.offset_y : 0;
    if (options.scale_x != null) scale_x = options.scale_x;
    if (options.scale_y != null) scale_y = options.scale_y;
    if (options.flip_x != null) flip_x = options.flip_x;
    if (options.flip_y != null) flip_x = options.flip_y;
    if (options.asset != null) load(options.asset, options.animated, options.width, options.height);
  }
  /**
   * Loads an Image asset to be displayed by the Entity.
   * @param asset The path to the asset.
   * @param sprite_sheet Flag to set whether the Image is a Sprite Sheet or just a single frame.
   * @param width Width of the Sprite. This only needs to be set if the Image is a Sprite Sheet.
   * @param height Height of the Sprite. This only needs to be set if the Image is a Sprite Sheet.
   */
  public function load(asset:String, sprite_sheet:Bool = false, width:Int = 0, height:Int = 0) {}
  /**
   * Creates a Colored Rectangle to be displayed by the Entity.
   * @param width Width of the Sprite.
   * @param height Height of the Sprite.
   * @param color Color of the Sprite.
   * @param alpha Alpha of the Sprite.
   */
  public function make(width:Int, height:Int, color:Int = Color.WHITE, alpha:Float = 1) {}

  public inline function set_offset(offset_x:Float, offset_y:Float, update_position:Bool = false) {
    this.offset_x = offset_x;
    this.offset_y = offset_y;

    if (update_position) {
      entity.x += offset_x;
      entity.y += offset_y;
    }
  }
  /**
   * Centers the Sprite's offset.
   */
  public inline function center_offset(update_position:Bool = false) {
    set_offset(-width * 0.5, -height * 0.5, update_position);
  }

  public inline function bounds():Rect return Rect.get(offset_x, offset_y, width, height);

  public inline function center():Vector2 return new Vector2(offset_x, offset_y);

  // getters
  function get_visible():Bool return false;

  function get_width():Float return 0;

  function get_height():Float return 0;

  function get_scale_x():Float return 0;

  function get_scale_y():Float return 0;

  // setters
  function set_visible(value:Bool) return value;

  function set_offset_x(value:Float) return value;

  function set_offset_y(value:Float) return value;

  function set_scale_x(value:Float) return value;

  function set_scale_y(value:Float) return value;

  function set_flip_x(value:Bool) return value;

  function set_flip_y(value:Bool) return value;

  inline static function get_defaults():SpriteRendererOptions return {
    animated: false,
    width: 0,
    height: 0
  }
}
