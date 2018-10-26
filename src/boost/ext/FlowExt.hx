package boost.ext;

import boost.util.Color;
import boost.ui.Button;
import boost.util.DataUtil;
import h2d.Tile;
import h2d.Text;
import h2d.Font;
import h2d.Flow;
import hxd.res.DefaultFont;

/**
 * Static Extension class for `h2d.Flow`. Adds in various methods to quickly create UI Elements.
 */
class FlowExt {
    /**
     * Default TextOptions. If set, these will be applied to any new text objects created by this class.
     */
    public static var text_options:TextOptions;
    /**
     * Default ContainerOptions. If set, these will be applied to any new container objects created by this class.
     */
    public static var container_options:ContainerOptions;
    /**
     * Default ButtonOptions. If set, these will be applied to any new button objects created by this class.
     */
    public static var button_options:ButtonOptions;

    public static function add_container(container:Flow, x:Int = 0, y:Int = 0, ?container_options:ContainerOptions):Flow {
        var options = FlowExt.container_options;
        DataUtil.copy_fields(container_options, options);
        
        var c = new Flow(container);
        c.x = x;
        c.y = y;
        c.backgroundTile = options.background;
        c.borderWidth = options.border_width == null ? 0 : options.border_width;
        c.borderHeight = options.border_height == null ? 0 : options.border_height;
        if (options.padding != null) {
            c.paddingTop = options.padding.top == null ? 0 : options.padding.top;
            c.paddingBottom = options.padding.bottom == null ? 0 : options.padding.bottom;
            c.paddingLeft = options.padding.left == null ? 0 : options.padding.left;
            c.paddingRight = options.padding.right == null ? 0 : options.padding.right;
        }
        return c;
    }

    public static function add_text(container:Flow, text:String = '', x:Int = 0, y:Int = 0, ?text_options):Text {
        var options = FlowExt.text_options;
        DataUtil.copy_fields(text_options, options);
        if (options == null) options = {};
        
        var t = new Text(options.font == null ? DefaultFont.get() : options.font, container);
        t.x = x;
        t.y = y;
        t.text = text;
        t.textColor = options.color == null ? Color.WHITE : options.color;
        t.textAlign = options.align == null ? Left : options.align;
        t.letterSpacing = options.letter_spacing == null ? 1 : options.letter_spacing;
        t.lineSpacing = options.line_spacing == null ? 0 : options.line_spacing;
        if (options.dropShadow != null) {
            t.dropShadow.dx = options.dropShadow.dx == null ? 0 : options.dropShadow.dx;
            t.dropShadow.dy = options.dropShadow.dy == null ? 0 : options.dropShadow.dy;
            t.dropShadow.color = options.dropShadow.color == null ? Color.BLACK : options.dropShadow.color;
            t.dropShadow.alpha = options.dropShadow.alpha == null ? 0 : options.dropShadow.alpha;
        }
        return t;
    }

    public static function add_button(container:Flow, x:Int = 0, y:Int = 0, ?text:String):Button {

        var b = new Button();
        return b;
    }
}

typedef TextOptions = {
    ?font:Font,
    ?color:Int,
    ?align:Align,
    ?letter_spacing:Int,
    ?line_spacing:Int,
    ?dropShadow : {
        ?dx:Float, 
        ?dy:Float, 
        ?color:Int, 
        ?alpha:Float 
    }
}

typedef ContainerOptions = {
    ?background:Tile,
    ?border_width:Int,
    ?border_height:Int,
    ?padding: {
        ?top:Int,
        ?bottom:Int,
        ?left:Int,
        ?right:Int
    }
}

typedef ButtonOptions = {
    ?text:TextOptions,
    ?container:ContainerOptions,
    ?on_over: {
        ?color:Int,
        ?graphic:Tile
    },
    ?on_click: {
        ?color:Int,
        ?graphic:Tile
    },
    ?on_out: {
        ?color:Int,
        ?graphic:Tile
    }
}