package ghost;

import ghost.h2d.system.*;
import ghost.Game;
import ghost.hxd.component.States;
import ghost.util.Log;
import ecs.entity.Entity;
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
   * The target framerate.
   * TODO: Make this set-able
   */
  public static var fps(get, null):Float;
  public static var world(get, null):BroadPhaseSystem;
  public static var collisions(get, null):CollisionSystem;
  public static var physics(get, null):PhysicsSystem;
  /**
   * Internal tracker for Window.
   */
  public static var window(default, null):Window;
  /**
   * Internal tracker for Log object.
   */
  public static var log(default, null):Log;
  /**
   * Called before the game quits.
   * Useful for saving, cleanup, etc.
   */
  public static var quit_game_callback:Void->Void;
  /**
   * Internal instance of Game Component.
   */
  @:allow(ghost.Game)
  static var game(default, null):Game;
  /**
   * Internal instance of Engine Component.
   */
  @:allow(ghost.Game)
  static var engine(default, null):Engine;
  /**
   * Internal instance of States Component.
   */
  @:allow(ghost.Game)
  static var states(default, null):States;
  /**
   * Loads a new State.
   * @param state The new State to load.
   * @param close_others If false, other open states will not be closed.
   */
  public static function load_state(state:GameState, close_others:Bool = true) {
    if (close_others) for (state in states.active) state.close();
    states.requested.push(state);
  }
  /**
   * Requests the game to be reset.
   */
  public static function reset() {
    log.info('Resetting Game..');
    for (state in states.active) state.close();
    states.reset = true;
  }
  /**
   * TODO:
   * Quits the Game.
   * First, it calls the optional `GM.quit_game_callback` function.
   * Second, it destroys the `Game` instance.
   * Finally - depending on the what argument is passed in - it will attempt to quit the Applicaton.
   * @param exit_application If false, this function will destroy the `Game` instance but not attempt to quit the Application.
   */
  public static function quit(exit_application:Bool = true) {
    quit_game_callback();
    // game.destroy();
  }
  /**
   * Called by `Game` during it's initialization to set up the Game Manager (`GM`).
   * @param game_entity the Game Entity.
   */
  @:allow(ghost.Game.init)
  static function init(game:Game, engine:Engine, entity:Entity):Void {
    GM.game = game;
    GM.engine = engine;
    states = entity.get(States);

    // Init other properties

    // TODO: See if we can migrate these to Game Components/Systems
    log = new Log();
    window = Window.getInstance();

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

  static function get_fps() return engine.fps;

  static function get_world() return game.world;

  static function get_collisions() return game.collisions;

  static function get_physics() return game.physics;

  // setters
  // static function set_framerate(value:Int) return game.framerate = value;
  static function set_background_color(value:Int) return engine.backgroundColor = value;
}
