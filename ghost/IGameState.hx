package ghost;

import ghost.util.FSM;

interface IGameState<T:IGame> extends State<IGame> {
  public var levels:Array<Level>;
}
