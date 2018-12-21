package gxd;

import ecs.system.SystemId;
import gxd.Game.GameSystems;
import ecs.system.System;
import ecs.entity.Entity;
import ecs.Engine;
import ecs.system.SystemCollection;
import ecs.entity.EntityCollection;
import gxd.sys.Event;
import gxd.util.DestroyUtil;
/**
 * The Base "State" of a `Game`. States are used to organize a Game's different views.
 * For example, a simple Game could be organized to have a State for each of theses views: Main Menu, GamePlay, Game Over Screen.
 *
 * Extend this class to access and override the `create()`, `update()`, and `destroy()` functions in order to construct/manage the State.
 */
class State extends Group {
  /**
   * How fast or slow time should pass in this State; default is `1.0`.
   */
  public var time_scale:Float;
  /**
   * Age of the State (in Seconds).
   */
  @:allow(gxd.system.StateSystem)
  public var age(default, null):Float;
  /**
   * When the State is marked as closed, it is destroyed after this update cycle.
   */
  public var closed:Bool;
  public var ui:h2d.Object;

  var engine:Engine<Event>;
  var systems:Array<System<Event>>;

  function new() {
    super();
    age = 0;
    time_scale = 1;
    closed = false;
  }
  /**
   * Override this to add initialization logic.
   */
  public function create() {}
  /**
   * Override this to run logic every frame.
   * @param dt Time elapsed since last frame.
   */
  override public function update(dt:Float) {}
  /**
   * Marks the State as closed.
   */
  public function close() closed = true;
  /**
   * Adds an Entity to the State.
   * @param entity The Entity to add.
   * @return The added Entity. Useful for chaining.
   */
  override public function put(object:GameObject):GameObject {
    engine.entities.add(super.put(object));
    return object;
  }
  /**
   * Removes an Entity from the State.
   * @param entity The Entity to remove.
   * @return The removed Entity. Useful for chaining.
   */
  override public function take(object:GameObject):GameObject {
    engine.entities.remove(super.take(object));
    return object;
  }
  /**
   * Adds a `System` to the State.
   *
   * @param system The `System` to add.
   * @param before The `System` to position the new `System` before. Defaults to the BroadPhase System.
   * @return The added `System`. Useful for chaining.
   */
  public function add_system(system:System<Event>, before:SystemId = BROADPHASE):System<Event> {
    systems.push(system);
    engine.systems.addBefore(before, system);
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
  override public function destroy() {
    members.for_each((member) -> engine.entities.remove(member), true);
    for (system in systems) engine.systems.remove(system);
    systems = null;
    ui.remove();
    super.destroy();
  }

  @:allow(gxd.system.StateSystem)
  function attach(engine:Engine<Event>, ui:h2d.Object) {
    this.engine = engine;
    this.ui = new h2d.Object(ui);
    // clear();
    systems = [];
  }
}
