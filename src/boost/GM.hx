package boost;

import boost.ecs.component.sys.Game;
import boost.ecs.component.sys.Engine;
import boost.ecs.component.sys.States;
import ecs.entity.Entity;
import boost.system.Log;
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
	 * The current State of the Game.
	 */
	public static var state(get, null):State;
	/**
	 * The target framerate.
	 * TODO: Make this settable
	 */
	public static var fps(get, null):Float;
	/**
	 * How fast or slow time should pass in the game; default is `1.0`.
	 */
	public static var timeScale:Float = 1;
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
	@:allow(boost.Game)
	static var game(default, null):Game;
	/**
	 * Internal instance of Engine Component.
	 */
	 @:allow(boost.Game)
	static var engine(default, null):Engine;
	/**
	 * Internal instance of States Component.
	 */
	 @:allow(boost.Game)
	static var states(default, null):States;

	/**
	 * Requests the game to be reset.
	 */
	public static function reset() {
		log.info('Resetting Game..');
		states.reset = true;
	}

	/**
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
	@:allow(boost.Game.init)
	static function init(game_entity:Entity):Void
	{
		game = game_entity.get(Game);
		engine = game_entity.get(Engine);
		states = game_entity.get(States);

		// Init other properties
		// TODO: See if we can migrate these to Game Components
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
	static function get_state() return states.active;
	static function get_fps() return engine.fps;

	// setters
	// static function set_framerate(value:Int) return game.framerate = value;
}
