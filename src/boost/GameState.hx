package boost;

import h2d.Layers;
import boost.util.DestroyUtil;
import boost.util.DestroyUtil.IDestroyable;
import ecs.Engine;

/**
 * The Base "State" of a `Game`.
 * This is where you add all of your Game's Entities and systems.
 * Extend this to access the `init()` and `update()` functions in order to construct/manage the State
 * TODO: Integrate the StateSystem for SubStates
 */
class GameState implements IDestroyable {
    /**
     * This State's ECS Engine instance.
     */
    public var ecs(default, null):Engine;
    /**
     * This State's 2D Scene instance.
     * If the State is a Sub State, it is added as a child to the Parent State's s2d instance.
     * Otherwise it is added as a child to the `Game`'s root s2d instance
     */
    public var local2d(default, null):Layers;
    /**
     * This State's 3D Scene instance.
     * If the State is a Sub State, it is added as a child to the Parent State's s3d instance.
     * Otherwise it is added as a child to the `Game`'s root s3d instance
     */
    public var local3d(default, null):h3d.scene.Object;
    /**
     * Current SubState
     */
    public var substate(default, null):GameState;
    /**
     * Flag to set whether the State will continue to update if it has opened a Substate
     */
    public var persistent_update:Bool = false;
    public var open_state_callback:Void->Void;
    public var close_substate_callback:Void->Void;

    function new() {
        ecs = new Engine();
        local2d = new Layers();
        local3d = new h3d.scene.Object();
    }

    /**
     * Override this to add initialization logic
     */
    public function init() {}

    /**
     * Override this to run logic every frame
     * @param dt Time elapsed since last frame
     */
    public function update(dt:Float) {
        ecs.update(dt);
    }

    @:allow(boost.ecs.system.sys.StateSystem)
    function try_update(dt:Float) {
        if (persistent_update || substate == null) update(dt);
		// if (request_substate_reset) {
		// 	request_substate_reset = false;
		// 	reset_substate();
		// } else 
        if (substate != null) substate.try_update(dt);
    }

    @:dox(hide) @:noCompletion
    public function destroy() {
        DestroyUtil.destroy(substate);
        ecs.destroy();
        local2d.remove();
        local3d.remove();
    }

    // public function open_substate(substate:Class<GameState>) {
        // this.substate = Type.createInstance(substate, []);
        // if (child)
    // }

    // public function closeSubState() {
        
    // }

    @:allow(boost.ecs.system.sys.StateSystem)
    function attach(context2d:h2d.Object, context3d:h3d.scene.Object) {
        context2d.addChild(local2d);
        context3d.addChild(local3d);
    }

}
