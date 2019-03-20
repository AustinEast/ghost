package h2d.ui;

import ghost.Data;
import ghost.Color;
import h2d.Flow;
import h2d.Font;
import h2d.Text;
import h2d.Tile;
import hxd.res.DefaultFont;
import hxd.Pixels;

class Styles {
  /**
   * Default TextStyle.
   */
  public static var text_defaults(get, null):TextStyle;
  /**
   * Default TextStyle.
   */
  public static var flow_defaults(get, null):FlowStyle;
  /**
   * Default TextStyle.
   */
  public static var button_defaults(get, null):ButtonStyle;
  /**
   * Custom Default TextStyle. If set, these will be applied to any new text objects created across the framework.
   */
  public static var text:TextStyle;
  /**
   * Custom Default FlowStyle. If set, these will be applied to any new flow objects created across the framework.
   */
  public static var flow:FlowStyle;
  /**
   * Custom Default ButtonStyle. If set, these will be applied to any new button objects created across the framework.
   */
  public static var button:ButtonStyle;

  public static function apply_flow_styles(flow:Flow, ?styles:FlowStyle):Flow {
    var nstyles:FlowStyle = Data.copy_fields(Styles.flow, Styles.flow_defaults);
    styles = Data.copy_fields(styles, nstyles);

    flow.backgroundTile = styles.background;
    flow.borderWidth = styles.border.width;
    flow.borderHeight = styles.border.height;
    if (styles.padding != null) {
      flow.paddingTop = styles.padding.top == null ? 0 : styles.padding.top;
      flow.paddingBottom = styles.padding.bottom == null ? 0 : styles.padding.bottom;
      flow.paddingLeft = styles.padding.left == null ? 0 : styles.padding.left;
      flow.paddingRight = styles.padding.right == null ? 0 : styles.padding.right;
    }
    flow.verticalSpacing = styles.spacing.vertical;
    flow.horizontalSpacing = styles.spacing.horizontal;
    flow.layout = Vertical;
    if (styles.width != null) {
      flow.minWidth = styles.width.min;
      flow.maxWidth = styles.width.max;
    }
    if (styles.height != null) {
      flow.minHeight = styles.height.min;
      flow.maxHeight = styles.height.max;
    }
    if (styles.align != null) {
      flow.verticalAlign = styles.align.vertical;
      flow.horizontalAlign = styles.align.horizontal;
    }

    return flow;
  }

  public static function apply_text_styles(text:Text, ?styles:TextStyle):Text {
    var nstyles:TextStyle = Data.copy_fields(Styles.text, Styles.text_defaults);
    styles = Data.copy_fields(styles, nstyles);

    text.font = styles.font;
    text.textColor = styles.color == null ? Color.WHITE : styles.color;
    text.textAlign = styles.align == null ? Left : styles.align;
    text.letterSpacing = styles.letter_spacing == null ? 1 : styles.letter_spacing;
    text.lineSpacing = styles.line_spacing == null ? 0 : styles.line_spacing;
    if (styles.dropShadow != null) {
      text.dropShadow.dx = styles.dropShadow.dx == null ? 0 : styles.dropShadow.dx;
      text.dropShadow.dy = styles.dropShadow.dy == null ? 0 : styles.dropShadow.dy;
      text.dropShadow.color = styles.dropShadow.color == null ? Color.BLACK : styles.dropShadow.color;
      text.dropShadow.alpha = styles.dropShadow.alpha == null ? 0 : styles.dropShadow.alpha;
    }

    return text;
  }

  public static function make_background(color:Int, ?border_color:Int, border_width:Int = 2, rounded:Bool = false):Tile {
    var pad = border_width * 2;
    var p = Pixels.alloc(1 + pad, 1 + pad, RGBA);
    p.clear(color);
    if (border_color != null) Tile.fromPixels(p);
    for (i in 0...border_width) {
      for (j in 0...p.width) {
        p.setPixel(j, i, border_color);
        p.setPixel(j, p.width - 1 - i, border_color);
      }
      for (j in 0...p.height) {
        p.setPixel(i, j, border_color);
        p.setPixel(p.height - 1 - i, j, border_color);
      }
    }
    return Tile.fromPixels(p);
  }

  static function get_text_defaults():TextStyle return {
    font: DefaultFont.get(),
    color: Color.WHITE,
    align: Left,
    letter_spacing: 1,
    line_spacing: 0,
    dropShadow: null
  }

  static function get_flow_defaults():FlowStyle return {
    background: null,
    border: {
      width: 0,
      height: 0
    },
    spacing: {
      vertical: 0,
      horizontal: 0
    },
    vertical: false,
    padding: {
      top: 0,
      bottom: 0,
      left: 0,
      right: 0
    }
  }

  static function get_button_defaults():ButtonStyle return {
    text: text_defaults,
    flow: {
      background: make_background(0xff847e87, 0xff696a6a),
      border: {
        width: 2,
        height: 2
      },
      align: {
        vertical: Middle,
        horizontal: Middle
      },
      padding: {
        left: 2,
        right: 2,
        bottom: 3
      },
      width: {
        min: 8,
      },
      height: {
        min: 4,
      }
    },
    on_over: {
      background: make_background(0xff9badb7, 0xff696a6a)
    },
    on_click: {
      background: make_background(0xff595652, 0xff696a6a)
    },
    on_out: {
      background: make_background(0xff847e87, 0xff696a6a)
    }
  }
}

typedef TextStyle = {
  var ?font:Font;
  var ?color:Int;
  var ?align:Align;
  var ?letter_spacing:Int;
  var ?line_spacing:Int;
  var ?dropShadow:{
    var ?dx:Float;
    var ?dy:Float;
    var ?color:Int;
    var ?alpha:Float;
  }
}

typedef FlowStyle = {
  var ?background:Tile;
  var ?border:{
    var ?width:Int;
    var ?height:Int;
  }
  var ?align:{
    var ?vertical:FlowAlign;
    var ?horizontal:FlowAlign;
  }
  var ?padding:{
    var ?top:Int;
    var ?bottom:Int;
    var ?left:Int;
    var ?right:Int;
  }
  var ?spacing:{
    var ?vertical:Int;
    var ?horizontal:Int;
  }
  var ?vertical:Bool;
  var ?width:{
    var ?min:Int;
    var ?max:Int;
  }
  var ?height:{
    var ?min:Int;
    var ?max:Int;
  }
}

typedef ButtonStyle = {
  var ?text:TextStyle;
  var ?flow:FlowStyle;
  var ?on_over:{
    var ?color:Int;
    var ?background:Tile;
  }
  var ?on_click:{
    var ?color:Int;
    var ?background:Tile;
  }
  var ?on_out:{
    var ?color:Int;
    var ?background:Tile;
  }
}

typedef CheckBoxStyle = {
  var ?text:TextStyle;
  var ?flow:FlowStyle;
}

typedef SliderStyle = {
  var width:Int;
  var height:Int;
  var background:Tile;
  var cursor:Tile;
}
