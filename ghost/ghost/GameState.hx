package ghost;

import ghost.util.FSM;
import echo.World;
import echo.data.Options;
import ogmo.Project;

class GameState implements State<Game> {
  public var levels:Array<Level>;

  public function enter(game:Game):Void {}

  public function step(game:Game, dt:Float):Void {}

  public function exit(game:Game):Void {}
}
