package ghost.ext;

#if heaps
import ghost.ui.Button;
import h2d.Bitmap;
import h2d.Slider;
import h2d.Object;
import h2d.Tile;
import h2d.Text;
import h2d.Flow;
import hxd.res.DefaultFont;

using ghost.ui.Styles;
/**
 * Static Extension class for `h2d.Object`. Adds in various methods to quickly create UI and other Elements.
 *
 * TODO: DOCS!
 */
class ObjectExt {
  /**
   * Sets the `Object`'s filter to render as "pixel perfect".
   * @param object The `Object` to modify.
   * @return Object The modified `Object`
   */
  public static inline function pixel_perfect(object:Object):Object {
    object.filter = new h2d.filter.ColorMatrix(h3d.Matrix.I());
    return object;
  }
  /**
   * Creates and adds a new `Object` as a child of the passed in `Object`
   * @param parent
   * @param x
   * @param y
   * @return Object
   */
  public static inline function add_object(?parent:Object, x:Float = 0, y:Float = 0):Object {
    var c = new Object(parent);
    c.x = x;
    c.y = y;
    return c;
  }
  /**
   * Creates and adds a new `Flow` as a child of the passed in `Object`
   * @param parent
   * @param x
   * @param y
   * @param styles
   * @return Flow
   */
  public static inline function add_flow(?parent:Object, x:Float = 0, y:Float = 0, ?styles:FlowStyle):Flow {
    var c = new Flow(parent);
    c.x = x;
    c.y = y;
    c.apply_flow_styles(styles);
    return c;
  }
  /**
   * Creates and adds a new `Bitmap` as a child of the passed in `Object`
   * @param parent
   * @param tile
   * @param x
   * @param y
   * @return Bitmap
   */
  public static inline function add_bitmap(?parent:Object, ?tile:Tile, x:Float = 0, y:Float = 0):Bitmap {
    var b = new Bitmap(tile, parent);
    b.x = x;
    b.y = y;
    return b;
  }
  /**
   * Creates and adds a new `Text` as a child of the passed in `Object`
   * @param parent
   * @param text
   * @param x
   * @param y
   * @param styles
   * @return Text
   */
  public static inline function add_text(?parent:Object, text:String = '', x:Float = 0, y:Float = 0, ?styles:TextStyle):Text {
    var t = new Text(DefaultFont.get(), parent);
    t.x = x;
    t.y = y;
    t.text = text;
    t.apply_text_styles(styles);
    return t;
  }
  /**
   * Creates and adds a new `Button` as a child of the passed in `Object`
   * @param parent
   * @param x
   * @param y
   * @param text
   * @param on_click
   * @param styles
   * @return Button
   */
  public static inline function add_button(?parent:Object, x:Float = 0, y:Float = 0, ?text:String, ?on_click:Void->Void, ?styles:ButtonStyle):Button {
    var b = new Button(text, on_click, styles, parent);
    b.x = x;
    b.y = y;

    return b;
  }
  /**
   * Creates and adds a new `Slider` as a child of the passed in `Object`
   * @param parent
   * @param x
   * @param y
   * @param get
   * @param set
   * @param min
   * @param max
   * @return Slider
   */
  public static inline function add_slider(?parent:Object, x:Float = 0, y:Float = 0, get:Void->Float, set:Float->Void, min:Float = 0, max:Float = 1):Slider {
    var s = new Slider();
    return s;
  }
}
#end
