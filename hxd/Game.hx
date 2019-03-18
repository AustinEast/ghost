package hxd;

import h2d.Flow;
import h2d.Object;
import ghost.Process;
import ghost.Data;
import ghost.Disposable;
import h2d.Mask;
import h2d.Layers;
import hxd.App;
/**
 * The Game Class bootstraps the creation of a HEAPS game.
 *
 * Once created, this class doesn't need to be interacted with directly.
 * Instead, look to the Game Manager (GM) Class for available properties and methods.
 */
class Game extends hxd.App implements IDisposable {
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
   * Layers Object that `h2d` Entities will be displayed on. Eventually will be replaced by camera system
   */
  public var viewport(default, null):Layers;
  /**
   * Layers Object that ui will be displayed on. Eventually will be replaced by camera system
   */
  public var ui(default, null):Layers;
  #if debug
  public var debug(default, null):Flow;
  #end
  /**
   * Age of the Game (in Seconds).
   */
  public var age(default, null):Float;
  public var closed(default, null):Bool;
  /**
   * Callback function that is called at the end of this Game's `init()`.
   *
   * This acts as the Game's main entry point for adding in GameStates.
   */
  public var create:Void->Void;
  /**
   * A Mask to constrain the root 2D Scene to the Game's width/height. Eventually will be replaced by camera system
   */
  public var root2d(default, null):Mask;
  /**
   * Creates a new Game.
   * @param filesystem The type of FileSystem to initialize.
   * @param options Optional Parameters to configure the Game.
   */
  public function new(filesystem:FileSystemOptions = EMBED, ?options:GameOptions) {
    super();
    options = Data.copy_fields(options, Game.defaults);

    name = options.name;
    version = options.version;
    width = options.width;
    height = options.height;
    hxd.Timer.wantedFPS = options.framerate;
    age = 0;
    closed = false;

    // Load the FileSystem
    // If we dont have access to macros, just `initEmbed()`
    #if macro
    switch (filesystem) {
      case EMBED:
        hxd.Res.initEmbed();
      case LOCAL:
        hxd.Res.initLocal();
      case PAK:
        hxd.Res.initPak();
    }
    #else
    hxd.Res.initEmbed();
    #end
  }

  override public function init() {
    if (width <= 0) width = engine.width;
    if (height <= 0) height = engine.height;
    root2d = new Mask(width, height, s2d);
    viewport = new Layers(root2d);
    ui = new Layers(root2d);
    debug = new Flow(s2d);
    debug.layout = Vertical;

    // Init the Game Manager
    GM.init(this, engine);

    // Call the callback function if it's set
    if (create != null) create();

    // Call a resize event for good measure
    onResize();
  }

  @:dox(hide) @:noCompletion
  override public function update(dt:Float) {
    if (closed) {
      if (!isDisposed) dispose();
      return;
    }
    age += dt;
    #if debug
    GM.debugger.update();
    #end
    Process.update(dt);
    // Temporary fix for macOS vsync issue on HL
    // #if hl
    // Sys.sleep(0.013);
    // #end
  }

  @:dox(hide) @:noCompletion
  override public function onResize() {
    var scaleFactorX:Float = engine.width / width;
    var scaleFactorY:Float = engine.height / height;
    var scaleFactor:Float = Math.min(scaleFactorX, scaleFactorY);
    if (scaleFactor < 1) scaleFactor = 1;
    root2d.setScale(scaleFactor);
    root2d.setPosition(engine.width * 0.5 - (width * scaleFactor) * 0.5, engine.height * 0.5 - (height * scaleFactor) * 0.5);
    #if debug
    GM.debugger.resize();
    #end
  }

  public function close() {
    Process.shutdown();
    closed = true;
  }

  override public function dispose() {
    if (!closed) throw '`close()` $name instead of disposing it directly';
    super.dispose();
  }

  static function get_defaults() return {
    name: "Ghost App",
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

@:enum
abstract FileSystemOptions(Int) {
  var EMBED = 0;
  var LOCAL = 1;
  var PAK = 2;
}
