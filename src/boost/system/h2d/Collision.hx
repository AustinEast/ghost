package boost.system.h2d;

import boost.Event;
import boost.util.ds.QuadTree;
import boost.util.DataUtil;
import boost.component.h2d.Transform;
import boost.component.h2d.Collider;
import boost.component.h2d.Motion;
import ecs.Engine;
import ecs.node.Node;
import ecs.system.System;
import tink.CoreApi.CallbackLink;

class Collision extends System<Event> {
    @:nodes var statics:Node<Transform,Collider>;
	@:nodes var dynamics:Node<Transform,Collider,Motion>;

    public static var defaults(get, null):CollisionOptions;
	/**
	 * QuadTree Structure to perform broad-phase overlap checks.
	 */
	var quadtree:QuadTree;
	/**
	 * Store of the Collisions from the previous frame.
	 * Used to determine if an overlap from the current frame should trigger the enter, stay, or exit callback in an entity.
	 */
	var last_shape_cols:Array<CollisionData>;
	/**
	 * Store of the Collisions from the current frame.
	 */
	var shape_cols:Array<CollisionData>;
	/**
	 * TODO
	 */
	var listeners:CallbackLink;

    public function new(?options:CollisionOptions) {
		super();
        options = DataUtil.copy_fields(options, defaults); 
	}

	override function onAdded(engine:Engine<Event>) {
		super.onAdded(engine);
		// for(node in statics) add_collider
		for(node in dynamics)
		listeners = [
			// objects.nodeAdded.handle(addObjectToDisplay),
			// objects.nodeRemoved.handle(removeObjectFromDisplay),
			// graphics.nodeAdded.handle(addGraphicToDisplay),
			// graphics.nodeRemoved.handle(removeGraphicFromDisplay),
		];
	}
	
	override function onRemoved(engine:Engine<Event>) {
		super.onRemoved(engine);
		quadtree.put();
		listeners.dissolve();
		listeners = null;
	}
	
	function add_collider() {

	}
	
	override function update(dt:Float) {
		// TODO: Add in broad phase collision check
		for(node in dynamics) {
			// for (node2 in dynamics) {
				// var shape_col = differ.Collision.shapeWithShape(node.collider.shape, node2.collider.shape);
				// if (shape_col != null) {
					// If not static or kinematic, separate
					// if ()

					// if has motion component, do the velocity stuff

					// Send the other entity back to the tested entities for callbacks
					// node.entity.
			// 	}
			// }
		}
	}
    
	static function get_defaults() return {
		dummy: 0
    }
}

typedef CollisionOptions = {
    ?dummy:Int
}

typedef CollisionData = {
	seperation: {
		x:Int,
		y:Int
	}
}