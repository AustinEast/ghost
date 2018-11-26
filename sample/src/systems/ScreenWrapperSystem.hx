package systems;

import ghost.GM;
import ghost.h2d.component.Transform;
import ghost.h2d.component.Sprite;
import ecs.node.Node;
import ecs.Engine;
import ecs.system.System;
/**
 * System for wrapping GameObjects around the screen.
 */
class ScreenWrapperSystem<Event> extends System<Event> {
  @:nodes var nodes:Node<Transform, Sprite>;

  override function update(dt:Float) {
    for (node in nodes) {
      if (node.transform.x > GM.width + node.sprite.width) {
        node.transform.x = -node.sprite.width;
      }
      if (node.transform.x < -node.sprite.width) {
        node.transform.x = GM.width + node.sprite.width;
      }
      if (node.transform.y > GM.height + node.sprite.height) {
        node.transform.y = -node.sprite.height;
      }
      if (node.transform.y < -node.sprite.height) {
        node.transform.y = GM.height + node.sprite.height;
      }
    }
  }
}
