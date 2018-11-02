package boost.system.h2d;

import h2d.col.Point;
import boost.util.DataUtil;
import boost.component.h2d.Transform;
import boost.component.h2d.Motion;
import ecs.node.Node;
import ecs.system.System;

/**
 * System for providing simple "Arcadey" 2D physics.
 */
class Arcade extends System {
	@:nodes var nodes:Node<Transform, Motion>;

	public static var defaults(get, null):ArcadeOptions;

	public var gravity:Point;

	public function new(?options:ArcadeOptions) {
		super();
        options = DataUtil.copy_fields(options, defaults); 
		gravity = new Point(options.gravity.x, options.gravity.y);
	}
	
	override function update(dt:Float) {
		for(node in nodes) {
			var transform = node.transform;
			var motion = node.motion;
			
			// Apply Velocity
			transform.x += motion.velocity.x * dt;
			transform.y += motion.velocity.y * dt;
			transform.rotation += motion.rotational_velocity * dt;

			// Apply Gravity
			if (!motion.kinematic) {
				transform.x += gravity.x * dt;
				transform.y += gravity.y * dt;
			}

			// Apply Drag
			
		}
	}
    
	static function get_defaults() return {
        gravity: {
			x: 0.,
			y: 0.
		}
    }
}

typedef ArcadeOptions = {
    ?gravity: {
		?x: Float,
		?y: Float
	}
}