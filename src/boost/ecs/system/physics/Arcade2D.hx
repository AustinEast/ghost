package boost.ecs.system.physics;

import h2d.col.Point;
import boost.util.DataUtil;
import boost.ecs.component.h2d.Transform2D;
import boost.ecs.component.h2d.Motion2D;
import ecs.node.Node;
import ecs.system.System;

/**
 * System for providing simple "Arcadey" 2D physics.
 */
class Arcade2D extends System {
	@:nodes var nodes:Node<Transform2D, Motion2D>;

	public static var defaults(get, null):Arcade2DOptions;

	public var gravity:Point;

	public function new(?options:Arcade2DOptions) {
		super();
        options = DataUtil.copy_fields(options, defaults); 
		gravity = new Point(options.gravity.x, options.gravity.y);
	}
	
	override function update(dt:Float) {
		for(node in nodes) {
			var transform = node.transform2D;
			var motion = node.motion2D;
			
			// Apply Velocity
			transform.position.x += motion.velocity.x * dt;
			transform.position.y += motion.velocity.y * dt;
			transform.rotation += motion.rotational_velocity * dt;

			// Apply Gravity
			if (!motion.kinematic) {
				transform.position.x += gravity.x * dt;
				transform.position.y += gravity.y * dt;
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

typedef Arcade2DOptions = {
    ?gravity: {
		?x: Float,
		?y: Float
	}
}