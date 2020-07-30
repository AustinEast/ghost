import ghost.Game;

class Main {
  static function main() {
    var game = new Game(320, 180);

    new haxe.Timer(16).run = () -> {
      game.update(16 / 1000);
    }
  }
}
