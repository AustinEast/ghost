package boost.system.sys;

import boost.component.sys.States;
import boost.component.sys.Engine;
import boost.component.sys.Game;
import ecs.node.Node;
import ecs.system.System;

/**
 * System for scaling the Viewport to maintain the ratio defined in the Game's options parameter
 */
class ScaleSystem extends System {
    @:nodes var nodes:Node<Engine,Game>;

	override function update(dt:Float) {
		for(node in nodes) {
			if (node.game.resized) {
                var e = node.engine;
                var g = node.game;

                var scaleFactorX:Float = e.width / g.width;
                var scaleFactorY:Float = e.height / g.height;
                var scaleFactor:Float = Math.min(scaleFactorX, scaleFactorY);
                if (scaleFactor < 1) scaleFactor = 1;

                g.mask2d.setScale(scaleFactor);
                g.mask2d.setPosition(e.width * 0.5 - (g.width * scaleFactor) * 0.5, e.height * 0.5 - (g.height * scaleFactor) * 0.5);

                g.resized = false;
            }
		}
	}
}