package boost.component.sys;

import h2d.Mask;
import boost.util.DataUtil;
import ecs.component.Component;
/**
 * Component for keeping reference to the Game properties.
 */
class Game extends Component {
  /**
   * Default Game Options.
   */
  public static var defaults(get, null):GameOptions;
  /**
   * The name of the Game.
   */
  public var name:String;
  /**
   * The version of the Game.
   */
  public var version:String;
  /**
   * The width of the screen in game pixels.
   */
  public var width(default, null):Int;
  /**
   * The height of the screen in game pixels.
   */
  public var height(default, null):Int;
  /**
   * The target framerate.
   */
  public var framerate:Int;
  /**
   * The root 2D Scene to be displayed.
   */
  public var s2d(default, null):h2d.Scene;
  /**
   * The root 3D Scene to be displayed.
   */
  public var s3d(default, null):h3d.scene.Scene;
  /**
   * A Mask to constrain the root 2D Scene to the Game's width/height. Eventually will be replaced by camera system
   */
  public var mask2d(default, null):Mask;
  /**
   * Flag to check if a game reset is request.
   */
  public var resized:Bool;

  public function new(s2d:h2d.Scene, s3d:h3d.scene.Scene, engine:h3d.Engine, ?options:GameOptions) {
    options = DataUtil.copy_fields(options, Game.defaults);
    name = options.name;
    version = options.version;
    width = options.width <= 0 ? engine.width : options.width;
    height = options.height <= 0 ? engine.height : options.height;
    framerate = options.framerate;
    resized = false;
    mask2d = new Mask(width, height, s2d);
    this.s2d = s2d;
    this.s3d = s3d;
  }

  static function get_defaults() return {
    name: "Boost App",
    version: "0.0.0",
    width: 0,
    height: 0,
    framerate: 60
  }
}

typedef GameOptions = {
  ?name:String,
  ?version:String,
  ?width:Int,
  ?height:Int,
  ?framerate:Int
}
