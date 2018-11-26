package ghost.sys;

import ecs.system.System;
import ecs.system.SystemCollection;
import ecs.Engine;

class GhostEngine extends Engine<Event> {
  public var fixed_systems(default, null):SystemCollection<Event>;
  public var late_systems(default, null):SystemCollection<Event>;
  public var delta:Float;

  var residue:Float;

  public function new() {
    super();
    fixed_systems = new SystemCollection(this);
    late_systems = new SystemCollection(this);
    residue = 0;
  }

  override public function update(dt:Float) {
    fixed_systems.lock();
    systems.lock();
    late_systems.lock();

    residue += dt;
    while (residue > delta) {
      for (system in fixed_systems) {
        update_system(system, delta);
        residue -= delta;
      }
    }

    for (system in systems) update_system(system, dt);

    for (system in late_systems) update_system(system, dt);

    fixed_systems.unlock();
    systems.unlock();
    late_systems.unlock();

    delay.flushUpdate();
    events.flushUpdate();
  }

  inline function update_system(system:System<Event>, dt:Float) {
    entities.lock();
    system.update(dt * GM.time_scale);
    entities.unlock();
    delay.flushSystem();
    events.flushSystem();
  }

  override public function destroy() {
    super.destroy();

    fixed_systems.destroy();
    fixed_systems = null;

    late_systems.destroy();
    late_systems = null;
  }
}
