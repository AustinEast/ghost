package boost.ecs.component.sys;

import ecs.component.Component;

/**
 * Component for keeping reference to the HEAPS Engine's properties
 * TODO: Finish docs
 */
class Engine extends Component {
    /**
     * The HEAPS Engine's width.
     * Generally matches the Window's width
     */
    public var width(get, null):Int;
    /**
     * The HEAPS Engine's height.
     * Generally matches the Window's height
     */
    public var height(get, null):Int;

    public var debug(get, set) : Bool;
	public var draw_triangles(get, null) : Int;
	public var draw_calls(get, null) : Int;
	public var shader_switches(get, null) : Int;
	public var background_color(get, set) : Null<Int>;
	public var auto_resize(get, set) : Bool;
    public var fullscreen(get, set) : Bool;
    /**
     * The HEAPS Engine's current FPS
     */
    public var fps(get, null):Float;
    /**
     * Internal tracker for the HEAPS Engine
     */
    var engine:h3d.Engine;

    public function new(engine:h3d.Engine) {
        this.engine = engine;
    }

    // getters
    function get_width() return engine.width;
    function get_height() return engine.height;
    function get_debug() return engine.debug;
    function get_draw_triangles() return engine.drawTriangles;
    function get_draw_calls() return engine.drawCalls;
    function get_shader_switches() return engine.shaderSwitches;
    function get_background_color() return engine.backgroundColor;
    function get_auto_resize() return engine.autoResize;
    function get_fullscreen() return engine.fullScreen;
    function get_fps() return engine.fps;

    // setters
    function set_debug(value:Bool) return engine.debug = value;
    function set_background_color(value:Int) return engine.backgroundColor = value;
    function set_auto_resize(value:Bool) return engine.autoResize = value;
    function set_fullscreen(value:Bool) return engine.fullScreen = value;
}
