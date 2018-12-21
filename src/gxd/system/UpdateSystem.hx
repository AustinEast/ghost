package gxd.system;

import gxd.component.Process;
import gxd.sys.Event;
import ecs.node.Node;
import ecs.system.System;
/**
 * Process Runner System.
 */
class UpdateSystem extends System<Event> {
  @:nodes var nodes:Node<Process>;

  override function update(dt:Float) {
    for (node in nodes) {
      var process = node.process;
      if (process.task != null && process.active) process.task(dt);
      if (!process.loop) process.active = false;
    }
  }
}
