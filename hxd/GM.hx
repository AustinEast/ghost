package hxd;

import h2d.Layers;
import hxd.Game;
import ghost.Log;
import h3d.Engine;
import hxd.Window;
/**
 * Game Manager (GM).
 * Contains handy global references for many systems and properties.
 */
class GM {
  /**
   * The name of the Game.
   */
  public static var name(get, null):String;
  /**
   * The version of the Game.
   */
  public static var version(get, null):String;
  /**
   * The width of the screen in game pixels.
   */
  public static var width(get, null):Int;
  /**
   * The height of the screen in game pixels.
   */
  public static var height(get, null):Int;
  /**
   * The Background Color of the Game's window.
   */
  public static var background_color(get, set):Int;
  /**
   * How fast or slow time should pass in the Game; default is `1.0`.
   */
  public static var time_scale:Float;
  /**
   * The target frames per second that the game logic will update.
   */
  public static var framerate(get, set):Float;
  /**
   * The current frames per second that the game is rendering at.
   */
  public static var render_framerate(get, null):Float;
  /**
   * An Object available to act as a Global UI that persists between States.
   *
   * Use the `ui` Object in a `GameState` instead to create UIs that only last during a single `GameState`.
   */
  public static var ui(default, null):h2d.Object;
  /**
   * Window Instance.
   */
  public static var window(default, null):Window;
  /**
   * Logger Instance.
   */
  public static var log(default, null):Log;
  /**
   * Called before the game quits.
   * Useful for saving, cleanup, etc.
   */
  public static var quit_game_callback:Void->Void;
  /**
   * Game Instance.
   */
  public static var game(default, null):Game;
  /**
   * Heaps Engine Instance.
   */
  public static var engine(default, null):Engine;
  /**
   * Quits the Game.
   *
   * First, it calls the optional `GM.quit_game_callback` function.
   * Second, it closes the `Game` instance.
   * TODO: Finally - depending on the what argument is passed in - it will attempt to quit the Applicaton.
   * @param exit_application If false, this function will dispose the `Game` instance but not attempt to quit the Application.
   */
  public static function quit(exit_application:Bool = true) {
    quit_game_callback();
    game.close();
  }
  /**
   * Called by `Game` during it's initialization to set up the Game Manager (`GM`).
   * @param game_entity the Game Entity.
   */
  @:allow(hxd.Game.init)
  static function init(game:Game, engine:Engine):Void {
    GM.game = game;
    GM.engine = engine;

    // Init other properties
    time_scale = 1;
    // TODO: See if we can migrate these to Game Components/Systems
    log = new Log();
    window = Window.getInstance();
    ui = new h2d.Object(game.ui);

    log.info(':: :: :: :: ::');
    log.info(':: $name');
    log.info(':: Version - $version');
    log.info(':: Initialized...');
    log.info(':: :: :: :: ::');
  }

  // getters
  static function get_name() return game.name;

  static function get_version() return game.version;

  static function get_width() return game.width;

  static function get_height() return game.height;

  static function get_background_color() return engine.backgroundColor;

  static function get_render_framerate() return engine.fps;

  static function get_framerate() return hxd.Timer.wantedFPS;

  // setters
  static function set_framerate(value:Float) return hxd.Timer.wantedFPS = value;

  static function set_background_color(value:Int) return engine.backgroundColor = value;
}
