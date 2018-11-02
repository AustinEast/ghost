package boost.system.h2d;

import boost.util.DataUtil;
import boost.component.h2d.Transform;
import boost.component.h2d.Collider;
import ecs.node.Node;
import ecs.system.System;

class Collision extends System {
    @:nodes var nodes:Node<Transform, Collider>;

    public static var defaults(get, null):DifferOptions;

    public function new(?options:DifferOptions) {
		super();
        options = DataUtil.copy_fields(options, defaults); 
	}
	
	override function update(dt:Float) {
		for(node in nodes) {
			
		}
	}
    
	static function get_defaults() return {
		dummy: 0
    }
}

typedef DifferOptions = {
    ?dummy:Int
}