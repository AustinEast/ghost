package systems;

import gxd.GameState;
import gxd.GM;
import gxd.sys.Event;
import ecs.system.System;
import hxd.Key;
/**
 * System for swapping out the different Sample States.
 */
class SampleSwapperSystem extends System<Event> {
  var samples:Array<Class<GameState>>;
  var index:Int;
  var current:GameState;

  public function new(samples:Array<Class<GameState>>) {
    super();
    this.samples = samples;
    index = 0;
    current = cast GM.add(cast Type.createInstance(samples[index], []));
  }

  override function update(dt:Float) {
    if (Key.isPressed(Key.ENTER)) {
      current.close();
      current = cast GM.add(cast Type.createInstance(samples[index], []));
    }

    if (Key.isPressed(Key.SPACE)) {
      current.close();
      index += 1;
      if (index >= samples.length) index = 0;
      current = cast GM.add(cast Type.createInstance(samples[index], []));
    }
  }
}
