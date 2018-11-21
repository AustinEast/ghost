package boost;

import boost.h2d.system.BroadPhaseSystem;
import boost.sys.Event;
import boost.h2d.system.*;
import boost.hxd.system.*;
import ecs.entity.Entity;
import ecs.Engine;
import h2d.Graphics;
/**
 * A State of the `Game` preconfigured with it's own Entity-Component-System (ECS) Engine and some default Systems to handle Rendering and Physics.
 * If use of the ECS Engine and the default Systems aren't desired, it is recommended to Extend the `State` class instead.
 *
 * Extend this class to access and override the `init()`, `init_systems()`, `update()`, and `destroy()` functions in order to construct/manage the State.
 */
class GameState extends State {
  /**
   * This State's ECS Engine instance.
   */
  // public var ecs(default, null):Engine<Event>;
  /**
   * This State's Renderer System.
   */
  // public var renderer(default, null):RenderSystem;
  /**
   * This State's Collision System.
   */
  // public var collisions(default, null):CollisionSystem<Event>;
  /**
   * This State's Physics System.
   */
  // public var physics(default, null):ArcadeSystem;
  /**
   * Creates the State and it's ECS Engine.
   */
  function new() {
    super();
    // ecs = new Engine<Event>();
  }
  /**
   * Override this to add initialization logic.
   * This is a good place to add this State's Entities.
   */
  override public function init() {}
  /**
   * Override this to customize the default ECS Systems for the GameState.
   *
   * Default System update order:
   * - Input
   * - Game Logic
   * - Broad-phase Collisions
   * - Narrow-phase Collision
   * - Physics
   * - Rendering
   * - Animation
   *
   * TODO:
   * - Make it easier to edit default systems
   * - See if separating rendering logic to a different thread is possible
   */
  public function init_systems() {
    // renderer = new RenderSystem(local2d);
    // collisions = new CollisionSystem(CollisionEvent, {debug: true}, new Graphics(local2d));
    // physics = new ArcadeSystem();

    // ecs.systems.add(new ProcessSystem());
    // ecs.systems.add(new BroadPhaseSystem(BroadPhaseEvent, {debug: true} new Graphics(local2d)));
    // ecs.systems.add(collisions);
    // ecs.systems.add(physics);
    // ecs.systems.add(renderer);
    // ecs.systems.add(new AnimationSystem());
  }
  /**
   * Override this to run logic every frame.
   * This also updates the ECS Engine.
   * @param dt Time elapsed since last frame.
   */
  override public function update(dt:Float) {
    super.update(dt);
    // ecs.update(dt);
  }
  /**
   * Override this to run cleanup logic when closing the state.
   */
  override public function destroy() {
    // ecs.destroy();
    super.destroy();
  }
  /**
   * Adds an Entity to the State.
   * Alias for `ecs.entities.add()`.
   * @param entity The Entity to add.
   * @return The added Entity. Useful for chaining.
   */
  public function add(entity:Entity):Entity {
    // ecs.entities.add(entity);
    return entity;
  }
  /**
   * Removes an Entity from the State.
   * Alias for `ecs.entities.remove()`.
   * @param entity The Entity to remove.
   * @return The removed Entity. Useful for chaining.
   */
  public function remove(entity:Entity):Entity {
    // ecs.entities.remove(entity);
    return entity;
  }
}
