package;

import hxd.GM;
import hxd.Game;
import hxd.debug.plugins.Stats;

using h2d.ext.ObjectExt;

class Main {
  static function main() new Main();

  function new() {
    // Create our Game with an Initial GameState and Options
    var game = new Game(LOCAL, {
      name: "Demo App",
      version: "0.0.1",
      width: 320,
      height: 180,
    });

    game.create = () -> {
      // Set the window's Background Color to something a little more pleasing ;)
      GM.background_color = 0xffd95763;

      #if debug
      // Add a debugger plugin to display basic stats
      GM.debugger.add(new Stats());
      // Add hot resource loading
      hxd.res.Resource.LIVE_UPDATE = true;
      hxd.Res.dat.garage.watch(() -> {
        GM.reset();
        new GarageState();
      });
      #end

      // Add a `Pixel Perfect` filter to the 2D viewport
      game.viewport.pixel_perfect();

      // Load the First Level
      new GarageState();
    }
  }
}
