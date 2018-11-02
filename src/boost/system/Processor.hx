package boost.system;

import boost.component.Process;
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
			if (process.task != null && process.active) process.task(dt);
            if (!process.loop) process.active = false;
		}
	}
}