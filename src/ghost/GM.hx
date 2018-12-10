package ghost;

import h2d.Layers;
import h2d.system.*;
import ghost.Game;
import hxd.component.States;
import ghost.util.Log;
import ecs.entity.Entity;
import h3d.Engine;
import hxd.Window;

using tink.CoreApi;
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
   * The current frames per second that the game is rendering at.
   */
  public static var framerate(get, null):Float;
  /**
   * The target frames per second that the game is updating its fixed timestep at.
   */
  public static var fixed_framerate(get, set):Int;
  /**
   *
   */
  public static var residue(get, null):Float;
  public static var world(get, null):BroadPhaseSystem;
  public static var collisions(get, null):CollisionSystem;
  public static var physics(get, null):PhysicsSystem;
  /**
   * An Object available to act as a Global UI that persists between GameStates.
   *
   * Use the `ui` Object in a GameState to create UIs that only last during a single GameState.
   */
  public static var ui(default, null):h2d.Object;
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

  public static function overlap(object1:ghost.GameObject, object12:ghost.GameObject) {
    // Query Broaphase system, then query Collision System
  }

  public static function collide(object1:ghost.GameObject, object12:ghost.GameObject) {}
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

  static function get_framerate() return engine.fps;

  static function get_fixed_framerate() return game.framerate;

  static function get_residue() return game.ecs.residue;

  static function get_world() return game.world;

  static function get_collisions() return game.collisions;

  static function get_physics() return game.physics;

  // setters
  static function set_fixed_framerate(value:Int) return game.framerate = value;

  static function set_background_color(value:Int) return engine.backgroundColor = value;
}
