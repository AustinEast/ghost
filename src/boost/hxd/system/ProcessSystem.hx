package boost.hxd.system;

import boost.hxd.component.Process;
import boost.sys.Event;
import ecs.node.Node;
import ecs.system.System;
/**
 * Process Runner System.
 */
class ProcessSystem extends System<Event> {
  @:nodes var nodes:Node<Process>;

  override function update(dt:Float) {
    for (node in nodes) {
      var process = node.process;
      if (process.task != null && process.active) process.task(dt);
      if (!process.loop) process.active = false;
    }
  }
}
