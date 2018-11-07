package boost.system;

import boost.Event;
import ecs.node.Node;
import ecs.system.System;

/**
 * Player/Gamepad Manager.
 */
class Controls extends System<Event> {
    @:nodes var nodes:Node<Controller>;
}