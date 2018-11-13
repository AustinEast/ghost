package;

import boost.GM;
import boost.Game;
import boost.State;
import states.*;
import systems.SampleSwapperSystem;

class Main {
  var sample_states:Array<Class<State>> = [SampleState3, SampleState2, SampleState1];

  static function main() {
    new Main();
  }

  function new() {
    // Create our Game with an Initial State and Options
    var game = new Game(sample_states[0], EMBED, {
      name: "Sample App",
      version: "0.0.1",
      width: 320,
      height: 180
    });

    game.on_init = () -> {
      // Set the window's Background Color to something a little more pleasing ;)
      GM.background_color = 0xff222034;
      // Add a custom System to the Game's top-level ECS Engine
      // Systems added to the Game's ECS Engine will persist between states
      // This is useful for Level managers, Save managers, etc.
      game.add_system(new SampleSwapperSystem(sample_states));
    }
  }
}

enum Event {}
