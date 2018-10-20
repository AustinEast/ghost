package boost.ecs.component.sys;

import ecs.component.Component;
import boost.State;

/**
 * Component for handling States
 */
class States extends Component {
    /**
	 * The original State loaded by the Game.
	 * Stored so it can be reloaded if the Game is reset by the Game Manager (see `GM.reset_game()`)
	 */
    public var initial:Class<State>;
    /**
	 * The current State
	 */
    public var active:State;
    /**
	 * The next State to load.
	 * Set by the Game Manager (see `GM.switch_state()`)
	 */
    public var requested:State;
    /**
	 * Flag to check if a game reset is request.
	 * Set by the Game Manager (see `GM.reset_game()`)
	 */
    public var reset:Bool;

    public function new(initial:Class<State>) {
        this.initial = initial;
        reset = true;
    }

}