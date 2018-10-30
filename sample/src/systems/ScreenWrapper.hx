package systems;

import boost.GM;
import boost.ecs.component.h2d.Transform2D;
import boost.ecs.component.h2d.Graphic2D;
import boost.util.DataUtil;
import ecs.node.Node;
import ecs.Engine;
import ecs.system.System;
import tink.CoreApi.CallbackLink;

/**
 * System for wrapping GameObjects around the screen.
 */
class ScreenWrapper extends System {
    @:nodes var nodes:Node<Transform2D, Graphic2D>;

    override function update(dt:Float) {
		for(node in nodes) {
            if (node.transform2D.x > GM.width + node.graphic2D.width) {
                node.transform2D.x = -node.graphic2D.width;
            }
		}
	}
}