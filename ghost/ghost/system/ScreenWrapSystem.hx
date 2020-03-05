package system;

import ghost.Node;
import ghost.System;
import ghost.component.ScreenWrap;

class ScreenWrapSystem extends System {
  @:dox(hide)
  @:nodes var nodes:Node<ScreenWrap>;

  @:dox(hide)
  override function step(dt:float) {
    super.step(dt);

    for (node in nodes) {
      // if (node.entity.x > game.width + node.screenwrap.width) node.entity.x = -node.screenwrap.width;
      // if (node.entity.x < -width) entity.display.x = GM.width + width;
      // if (node.entity.y > GM.height + height) entity.display.y = -height;
      // if (node.entity.y < -height) entity.display.y = GM.height + height;
    }
  }
}
