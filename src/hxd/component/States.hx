package hxd.component;

import ecs.component.Component;
import ghost.GameState;
/**
 * Component for handling States.
 */
class States extends Component {
  /**
   * The original State loaded by the Game.
   * Stored so it can be reloaded if the Game is reset by the Game Manager (see `GM.reset()`).
   */
  public var initial:Class<GameState>;
  /**
   * The current State.
   */
  public var active:Array<GameState>;
  /**
   * The next States to load.
   * Set by the Game Manager (see `GM.load_state()`).
   */
  public var requested:Array<GameState>;
  /**
   * Flag to check if a game reset is request.
   * Set by the Game Manager (see `GM.reset()`).
   */
  public var reset:Bool;

  public function new(initial:Class<GameState>) {
    this.initial = initial;
    active = [];
    requested = [];
    reset = true;
  }
}
