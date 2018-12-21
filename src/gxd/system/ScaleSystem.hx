package gxd.system;

import gxd.Game;
import gxd.sys.Event;
import ecs.system.System;
import h3d.Engine;
/**
 * System for scaling the Viewport to maintain the ratio defined in the Game's options parameter
 */
class ScaleSystem extends System<Event> {
  var game:Game;
  var heaps:Engine;

  public function new(game:Game, engine:Engine) {
    super();
    this.game = game;
    this.heaps = engine;
  }

  override function update(dt:Float) {
    if (game.resized) {
      var scaleFactorX:Float = heaps.width / game.width;
      var scaleFactorY:Float = heaps.height / game.height;
      var scaleFactor:Float = Math.min(scaleFactorX, scaleFactorY);
      if (scaleFactor < 1) scaleFactor = 1;

      game.root2d.setScale(scaleFactor);
      game.root2d.setPosition(heaps.width * 0.5 - (game.width * scaleFactor) * 0.5, heaps.height * 0.5 - (game.height * scaleFactor) * 0.5);

      game.resized = false;
    }
  }
}
