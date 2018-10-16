package boost.ecs.system.render;

import boost.ecs.component.h2d.Graphic2D;
import boost.util.DataUtil;
import ecs.node.Node;
import ecs.Engine;
import ecs.system.System;
import tink.CoreApi.CallbackLink;

/**
 * System for handling the rendering of 2D Graphics
 * TODO: Add in animations
 */
class Render2D extends System {
    @:nodes var nodes:Node<Graphic2D>;

    override function update(dt:Float) {
		for(node in nodes) {
			var g = node.graphic2D;
			g.bitmap.tile = g.frames[g.current_frame];
		}
	}
}