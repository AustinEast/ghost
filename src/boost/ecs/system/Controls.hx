package boost.ecs.system;

import ecs.node.Node;
import ecs.system.System;

/**
 * Player/Gamepad Manager
 */
class Controls extends System {
    @:nodes var nodes:Node<Controller>;
}