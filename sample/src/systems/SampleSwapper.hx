package systems;

import hxd.Key;
import boost.GM;
import boost.ecs.component.sys.States;
import ecs.node.Node;
import ecs.Engine;
import ecs.system.System;
import tink.CoreApi.CallbackLink;

/**
 * System for Swapping out the Different Sample GameStates
 */
class SampleSwapper extends System {
    @:nodes var nodes:Node<States>;



    override function update(dt:Float) {
		for(node in nodes) {
            // TODO: add in state swapper once we have more than one sample state ;)
            if (Key.isPressed(Key.ENTER)) {
                node.states.reset = true;
            }
		}
	}
}