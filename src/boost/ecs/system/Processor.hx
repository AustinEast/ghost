package boost.ecs.system;

import ecs.node.Node;
import ecs.system.System;

/**
 * Process Runner.
 */
class Processor extends System {
    @:nodes var nodes:Node<Process>;

    override function update(dt:Float) {
		for(node in nodes) {
			var process = node.process;
			if (process.active) process.task();
            if (!process.loop) process.active = false;
		}
	}
}