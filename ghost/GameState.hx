package gxd;

import gxd.Game.GameSystems;
import gxd.component.Instance;
import ecs.Engine;
import ecs.system.System;
import ecs.system.SystemId;
/**
 * The Base "GameState" of a `Game`. States are used to organize a Game's different views.
 * For example, a simple Game could be organized to have a GameState for each of theses views: Main Menu, GamePlay, Game Over Screen.
 *
 * Extend this class to access and override the `create()`, `update()`, and `dispose()` functions in order to construct/manage the GameState.
 */
class GameState extends Group {
  /**
   * How fast or slow time should pass in this GameState; default is `1.0`.
   */
  public var time_scale:Float;
  /**
   * Age of the GameState (in Seconds).
   */
  @:allow(gxd.system.StateSystem)
  public var age(default, null):Float;
  /**
   * When the GameState is marked as closed, it is disposeed after this update cycle.
   */
  public var closed:Bool;
  public var ui:h2d.Object;

  var ecs:Engine<Event>;
  var systems:Array<System<Event>>;

  function new() {
    super();
    age = 0;
    closed = false;
  }

  override function init_components() {
    components.add(process);
    components.add(members);
    components.add(new Instance(this, GAMESTATE));
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
   * Marks the GameState as closed.
   */
  public function close() closed = true;
  /**
   * Adds a GameObject to the GameState.
   * @param object The GameObject to add.
   * @return The added GameObject. Useful for chaining.
   */
  override public function add(object:GameObject):GameObject {
    ecs.entities.add(super.add(object).components);
    return object;
  }
  /**
   * Removes a GameObject from the GameState.
   * @param object The GameObject to remove.
   * @return The removed GameObject. Useful for chaining.
   */
  override public function remove(object:GameObject):GameObject {
    ecs.entities.remove(super.remove(object).components);
    return object;
  }
  /**
   * Adds a `System` to the GameState.
   *
   * @param system The `System` to add.
   * @param before The `System` to position the new `System` before. Defaults to the BroadPhase System.
   * @return The added `System`. Useful for chaining.
   */
  public function add_system(system:System<Event>, before:SystemId = BROADPHASE):System<Event> {
    systems.push(system);
    ecs.systems.addBefore(before, system);
    return system;
  }
  /**
   * Removes an System from the GameState.
   * @param system The System to remove.
   * @return The removed System. Useful for chaining.
   */
  public function remove_system(system:System<Event>):System<Event> {
    systems.remove(system);
    ecs.systems.remove(system);
    return system;
  }
  /**
   * Override this to run cleanup logic when closing the state.
   */
  override public function dispose() {
    for (system in systems) ecs.systems.remove(system);
    members.for_each((member) -> remove(member));
    super.dispose();
    systems = null;
    ecs.entities.remove(components);
    ecs = null;
    ui.remove();
    ui = null;
  }

  @:allow(gxd.system.StateSystem)
  @:keep
  function attach(ecs:Engine<Event>, ui:h2d.Object) {
    this.ecs = ecs;
    this.ui = new h2d.Object(ui);
    // clear();
    systems = [];
  }
}
