package boost.ecs.component.h2d;

import boost.util.DataUtil;
import h2d.col.Point;
import ecs.component.Component;

class Transform2D extends Component {

    /**
	 * Default Transform2D Options
	 */
	public static var defaults(get, null): Transform2DOptions;

    public var x(default, set): Float;
    public var y(default, set): Float;
    public var rotation(default, set): Float;
    public var scale_x(default, set): Float;
    public var scale_y(default, set): Float;
    public var dirty:Bool;

    public function new (?options:Transform2DOptions) {
        options = DataUtil.copy_fields(options, defaults);
        set_position(options.x, options.y);
        rotation = options.rotation;
        set_scale(options.scale_x, options.scale_y);
    }

    public function set_position(x:Float, y:Float) {
        this.x = x;
        this.y = y;
    }

    public function set_scale(x:Float, y:Float) {
        this.scale_x = x;
        this.scale_y = y;
    }

    function set_x(value:Float):Float {
        if (x != value) dirty = true;
        return x = value;
    }

    function set_y(value:Float):Float {
        if (y != value) dirty = true;
        return y = value;
    }

    function set_rotation(value:Float):Float {
        if (rotation != value) dirty = true;
        return rotation = value;
    }

    function set_scale_x(value:Float):Float {
        if (scale_x != value) dirty = true;
        return scale_x = value;
    }

    function set_scale_y(value:Float):Float {
        if (scale_y != value) dirty = true;
        return scale_y = value;
    }

    static function get_defaults():Transform2DOptions return {
        x: 0,
        y: 0,
        rotation: 0,
        scale_x: 1,
        scale_y: 1
    }
}

typedef Transform2DOptions = {
    ?x:Float, 
    ?y:Float,
    ?rotation:Float,
    ?scale_x:Float, 
    ?scale_y:Float
}