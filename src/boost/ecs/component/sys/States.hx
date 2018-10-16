package boost.ecs.component.sys;

import ecs.component.Component;

/**
 * Component for handling States
 */
class States extends Component {
    /**
	 * The original GameState loaded by the Game
	 * Stored so it can be reloaded if the Game is reset by the Game Manager (see `GM.reset_game()`)
	 */
    public var initial:Class<GameState>;
    /**
	 * The current GameState
	 */
    public var active:GameState;
    /**
	 * The next GameState to load
	 * Set by the Game Manager (see `GM.switch_state()`)
	 */
    public var requested:GameState;
    /**
	 * Flag to check if a game reset is request 
	 * Set by the Game Manager (see `GM.reset_game()`)
	 */
    public var reset:Bool;

    public function new(initial:Class<GameState>) {
        this.initial = initial;
        reset = true;
    }

}