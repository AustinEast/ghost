package boost;

import boost.ecs.system.render.Render2D;
import boost.ecs.system.render.Display2D;
import boost.ecs.system.physics.Arcade2D;
import ecs.Engine;

/**
 * A State of the `Game` preconfigured with it's own Entity-Component-System (ECS) Engine and some default Systems to handle Rendering and Physics.
 * If use of the ECS Engine and the default Systems aren't desired, it is recommended to Extend the `State` class instead.
 * 
 * Extend this to access and override the `init()`, `init_systems()`, `update()`, and `destroy()` functions in order to construct/manage the State
 */
class GameState extends State {
    /**
     * This State's ECS Engine instance
     */
    public var ecs(default, null):Engine;
    /**
     * Creates the State and it's ECS Engine
     */
    function new() {
        super();
        ecs = new Engine();
    }
    /**
     * Override this to add initialization logic.
     * This is a good place to add this State's Entities
     */
    override public function init() {}
    /**
     * Override this to customize the default ECS Systems for the GameState
     */
    public function init_systems() {
        ecs.systems.add(new Arcade2D());
        ecs.systems.add(new Display2D(local2d));
        ecs.systems.add(new Render2D());
    }
    /**
     * Override this to run logic every frame.
     * This also updates the ECS Engine
     * @param dt Time elapsed since last frame
     */
    override public function update(dt:Float) {
        super.update(dt);
        ecs.update(dt);
    }
    /**
     * Override this to run cleanup logic when closing the state
     */
    override public function destroy() {
        super.destroy();
        ecs.destroy();
    }
}
