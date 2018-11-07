package boost.system.sys;

import boost.Event;
import ecs.node.Node;
import ecs.system.System;
/**
 * TODO
 */
class HeapsSystem extends System<Event> {
  @:nodes var nodes:Node<Engine>;

  override function update(dt:Float) {
    for (node in nodes) {}
  }
}
