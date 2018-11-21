package boost;

import ecs.system.System;
import ecs.entity.Entity;
import ecs.Engine;
import ecs.state.EngineState.SystemInfo;
import ecs.system.SystemCollection;
import ecs.entity.EntityCollection;
import boost.sys.Event;
import boost.util.DestroyUtil;
/**
 * The Base "State" of a `Game`. States are used to organize a Game's different views.
 * For example, a simple Game could be organized to have a State for each of theses views: Main Menu, GamePlay, Game Over Screen.
 * If use of the ECS Engine and default Systems are desired, it is recommended to Extend the `GameState` class instead.
 *
 * Extend this class to access and override the `init()`, `update()`, and `destroy()` functions in order to construct/manage the State.
 */
class GameState implements IDestroyable {
  /**
   * How fast or slow time should pass in this State; default is `1.0`.
   */
  public var time_scale:Float;
  /**
   * Age of the State (in Seconds).
   */
  @:allow(boost.hxd.system.StateSystem)
  public var age(default, null):Float;
  /**
   * When the State is marked as closed, it is destroyed after this update cycle.
   */
  public var closed:Bool;
  /**
   * A function that gets called when this state is closed.
   */
  public var close_callback:Void->Void;

  var engine:Engine<Event>;
  @:dox(hide) @:noCompletion
  var entities:EntityCollection;
  @:dox(hide) @:noCompletion
  var systems:SystemCollection<Event>;

  function new() {
    age = 0;
    time_scale = 1;
    closed = false;
    close_callback = () -> {};
  }
  /**
   * Override this to add initialization logic.
   */
  public function create() {}
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
   * Adds an Entity to the State.
   * @param entity The Entity to add.
   * @return The added Entity. Useful for chaining.
   */
  public function add(entity:Entity):Entity {
    entities.add(entity);
    engine.entities.add(entity);
    return entity;
  }
  /**
   * Removes an Entity from the State.
   * @param entity The Entity to remove.
   * @return The removed Entity. Useful for chaining.
   */
  public function remove(entity:Entity):Entity {
    entities.remove(entity);
    engine.entities.remove(entity);
    return entity;
  }
  /**
   * Adds an System to the State.
   *
   * TODO: ENABLE ADDING SYSTEM IN POSITION BASED ON ENUM
   *
   * @param system The System to add.
   * @return The added System. Useful for chaining.
   */
  public function add_system(system:System<Event>):System<Event> {
    systems.add(system);
    engine.systems.add(system);
    return system;
  }
  /**
   * Removes an System from the State.
   * @param system The System to remove.
   * @return The removed System. Useful for chaining.
   */
  public function remove_system(system:System<Event>):System<Event> {
    systems.remove(system);
    engine.systems.remove(system);
    return system;
  }
  /**
   * Override this to run cleanup logic when closing the state.
   */
  public function destroy() {
    for (entity in entities) engine.entities.remove(entity);
    for (system in systems) engine.systems.remove(system);
    entities.destroy();
    systems.destroy();
  }

  @:allow(boost.hxd.system.StateSystem)
  function attach(engine:Engine<Event>) {
    this.engine = engine;
    entities = new EntityCollection();
    systems = new SystemCollection<Event>(engine);
  }
}
