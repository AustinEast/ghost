package ghost;

@:autoBuild(ghost.util.Macros.build_system())
class System {
  var game:Game;

  public function new() {}

  public function step(dt:Float) {}

  public function added(game:Game) {
    this.game = game;
    add_nodes();
  }

  public function removed() {
    game = null;
    remove_nodes();
  }

  function add_nodes() {}

  function remove_nodes() {}
}
