package boost.ecs.system.sys;

import ecs.node.Node;
import ecs.system.System;

/**
 * TODO
 */
class HeapsSystem extends System {
    @:nodes var nodes:Node<Engine>;


	override function update(dt:Float) {
		for(node in nodes) {
			
		}
	}
}