package boost;

import h2d.Flow;
import h2d.Mask;
import h2d.Layers;
import boost.util.DestroyUtil;
import boost.util.DestroyUtil.IDestroyable;

/**
 * The Base "State" of a `Game`. States are used to organize a Game's different views.
 * For example, a simple Game could be organized to have a State for each of theses views: Main Menu, GamePlay, Game Over Screen.
 * If use of the ECS Engine and default Systems are desired, it is recommended to Extend the `GameState` class instead.
 * 
 * Extend this class to access and override the `init()`, `update()`, and `destroy()` functions in order to construct/manage the State.
 */
class State implements IDestroyable {
    /**
     * This State's 2D Scene instance.
     */
    public var local2d(default, null):Layers;
    /**
     * This State's 3D Scene instance.
     */
    public var local3d(default, null):h3d.scene.Object;
    /**
     * This State's UI instance. It is simply a `h2d.Object` rendered on top of everything else in the State. 
     * See `boost.ext.ObjectExt` for adding simple UI elements.
     */
    public var ui(default, null):h2d.Object;
    /**
	 * How fast or slow time should pass in this State; default is `1.0`.
	 */
    public var time_scale:Float;
    /**
     * Age of the State (in Seconds).
     */
    @:allow(boost.ecs.system.sys.StateSystem)
    public var age(default, null):Float;
    /**
     * When the State is marked as closed, it is destroyed after this update cycle.
     */
    public var closed:Bool;
    /**
     * A function that gets called when this state is closed.
     */
    public var close_callback:Void->Void;

    function new() {
        local2d = new Layers();
        local3d = new h3d.scene.Object();
        ui = new h2d.Object();
        age = 0;
        time_scale = 1;
        closed = false;
        close_callback = () -> {};
    }

    /**
     * Override this to add initialization logic.
     */
    public function init() {}

    /**
     * Override this to run logic every frame.
     * @param dt Time elapsed since last frame.
     */
    public function update(dt:Float) {}

    /**
     * Marks the State as closed.
     */
    public function close() closed = true;

    /**
     * Override this to run cleanup logic when closing the state.
     */
    public function destroy() {
        local2d.remove();
        ui.remove();
        local3d.remove();
    }

    @:allow(boost.ecs.system.sys.StateSystem)
    function attach(context2d:h2d.Object, context3d:h3d.scene.Object) {
        context2d.addChild(local2d);
        context2d.addChild(ui);
        context3d.addChild(local3d);
    }

}
