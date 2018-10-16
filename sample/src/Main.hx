package;

import boost.Game;
import states.SampleState1;
import systems.SampleSwapper;

class Main {
	
	static function main() {
		new Main();
	}

	function new() {
		// Create our Game with an Initial State and Options
		var game = new Game(SampleState1, EMBED, {
			name: "Test App",
			version: "0.0.1",
			width: 320,
			height: 180,
			framerate: 60
		});

        // Add in a custom top-level system to persist between states
        game.add_system(new SampleSwapper());
	}
}