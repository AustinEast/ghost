package systems;

import boost.GM;
import boost.h2d.component.Transform;
import boost.h2d.component.Graphic;
import ecs.node.Node;
import ecs.Engine;
import ecs.system.System;
/**
 * System for wrapping GameObjects around the screen.
 */
class ScreenWrapperSystem<Event> extends System<Event> {
  @:nodes var nodes:Node<Transform, Graphic>;

  override function update(dt:Float) {
    for (node in nodes) {
      if (node.transform.x > GM.width + node.graphic.width) {
        node.transform.x = -node.graphic.width;
      }
    }
  }
}
