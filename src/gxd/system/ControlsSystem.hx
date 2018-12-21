package gxd.system;

import gxd.sys.Event;
import ecs.node.Node;
import ecs.system.System;
/**
 * Player/Gamepad Manager.
 */
class ControlsSystem extends System<Event> {
  @:nodes var nodes:Node<Controller>;
}
