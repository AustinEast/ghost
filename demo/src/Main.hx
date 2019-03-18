package;

import hxd.GM;
import hxd.Game;
import hxd.debug.plugins.Stats;

using h2d.ext.ObjectExt;

class Main {
  static function main() {
    new Main();
  }

  function new() {
    // Create our Game with an Initial GameState and Options
    var game = new Game(EMBED, {
      name: "Demo App",
      version: "0.0.1",
      width: 320,
      height: 180
    });

    game.create = () -> {
      // Set the window's Background Color to something a little more pleasing ;)
      GM.background_color = 0xffd95763;
      GM.debugger.add(new Stats());
      // Add a `Pixel Perfect` filter to the 2D viewport
      // game.viewport.pixel_perfect();
      // Load the First Level
      new GarageState();
    }
  }
}
