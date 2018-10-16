package boost.ecs.component.h2d;

import boost.util.DataUtil;
import h2d.col.Point;
import ecs.component.Component;

class Transform2D extends Component {

    /**
	 * Default Transform2D Options
	 */
	public static var defaults(get, null): Transform2DOptions;

    public var position(default, default): Point;
    public var rotation(default, default): Float;
    public var scale(default, default): Point;

    public function new (?options:Transform2DOptions) {
        options = DataUtil.copy_fields(options, defaults);
        position = new Point(options.position.x, options.position.y);
        rotation = options.rotation;
        scale = new Point(options.scale.x, options.scale.y);
    }

    static function get_defaults():Transform2DOptions return {
        position: { x: 0, y: 0 },
        rotation: 0,
        scale: { x: 1, y: 1 }
    }
}

typedef Transform2DOptions = {
    ?position: { ?x:Float, ?y:Float },
    ?rotation:Float,
    ?scale: { ?x:Float, ?y:Float }
}