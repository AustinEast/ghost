package boost.ecs.system.render;

import boost.ecs.component.h2d.Graphic2D;
import boost.system.ds.Animations;
import ecs.node.Node;
import ecs.Engine;
import ecs.system.System;

/**
 * System for handling the rendering of 2D Graphics.
 */
class Render2D extends System {
    @:nodes var nodes:Node<Graphic2D>;

    override function update(dt:Float) {
		for(node in nodes) {
			var g = node.graphic2D;
			var a = g.animations;
			
			if (a.current != null && a.delay != 0 && !a.paused) update_animation(dt, g, a);
			g.bitmap.tile = g.frames[g.current_frame];
		}
	}

	function update_animation(dt:Float, g:Graphic2D, a:Animations) {
		a.timer += dt;
		if (a.current.looped && a.finished && a.timer > a.delay) {
			a.finished = false;
			a.index = a.reversed ? a.current.frames.length - 1 : 0;
		}
		while (a.timer > a.delay && !a.finished) {
			a.timer -= a.delay;
			a.index +=  a.reversed ? -1 : 1;
			switch (a.current.direction) {
				case FORWARD:
				if (a.index >= a.current.frames.length - 1) finish_animation(a);
				case REVERSE:
				if (a.index <= 0) finish_animation(a);
				case PINGPONG:
				if (a.reversed && a.index <= 0) {
					a.reversed = false;
					finish_animation(a);
				} else if (!a.reversed && a.index >= a.current.frames.length) {
					a.index = a.current.frames.length - 1;
					a.reversed = true;
				}
			}
			g.current_frame = a.current.frames[a.index];
		}
	}

	inline function finish_animation(a:Animations) {
		a.finished = true;
		if (a.current.looped) a.timer -= a.current.loop_delay;
	}
}