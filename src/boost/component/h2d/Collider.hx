package boost.component.h2d;

import boost.util.DataUtil;
import h2d.col.Bounds;
import h2d.col.Circle;
import h2d.col.Polygon;
import ecs.entity.Entity;
import ecs.component.Component;

class Collider extends Component {
    /**
	 * Default `Collider` Options
	 */
	public static var defaults(get, null): ColliderOptions;
    /**
     * Flag to set whether this collider is solid.
     * If set to false, collisions with this `Component`'s `Entity` will not separate, but it will
     * trigger the `Collider`'s Callback functions (`on_enter`, `on_stay`, `on_exit`).
     */
    public var solid:Bool;
    /**
     * The X offset of the `Collider` from it's `Transform`.
     */
    public var dx:Int;
    /**
     * The Y offset of the `Collider` from it's `Transform`.
     */
	public var dy:Int;
    /**
     * The `Bounds` of the `Collider`.
     */
    public var bounds:Bounds;
    /**
     * The Collision Group of the `Collider`.
     */
    public var group:String;
    /**
     * Callback Function that is triggered when this `Collider` first collides with another `Collider`.
     */
    public var on_enter:Entity->Void;
    /**
     * Callback Function that is triggered when this `Collider` collides with another `Collider` for multiple frames.
     */
    public var on_stay:Entity->Void;
    /**
     * Callback Function that is triggered when this `Collider` ends it's collision with another `Collider`.
     */
    public var on_exit:Entity->Void;

    public function new(?bounds:Bounds, ?options:ColliderOptions) {
        options = DataUtil.copy_fields(options, defaults);
        this.bounds = bounds == null ? new Bounds() : bounds;
		dx = options.offset.x;
		dy = options.offset.y;
        solid = options.solid;
        group = options.group;
	}

    static function get_defaults():ColliderOptions return {
        offset: {
            x: 0,
            y: 0
        },
        solid: true,
        group: 'Default'
    }
}

typedef ColliderOptions = {
    ?offset: { ?x:Int, ?y:Int },
    ?solid:Bool,
    ?group:String
}