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
			var a = g.animations;
			
			if (a.current != null && a.delay != 0 && !a.paused && !a.finished) {
				a.timer += dt;
				while (a.timer > a.delay && !a.finished) {
					// if (a.current.frames[a.index] != null)
					a.timer -= a.delay;
					switch (a.current.direction) {
						case FORWARD:
						a.index += 1;
						if (a.index >= a.current.frames.length) {
							if (a.current.looped) a.index = 0;
							a.finished = true;
						}

						case REVERSE:

						case PINGPONG:
					}
					g.current_frame = a.current.frames[a.index];
				}
				if (a.current.looped) a.finished = false;
			}
			g.bitmap.tile = g.frames[g.current_frame];
		}
	}
}