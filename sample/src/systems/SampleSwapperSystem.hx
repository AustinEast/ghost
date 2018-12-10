package systems;

import ghost.GameState;
import ghost.GM;
import ghost.sys.Event;
import hxd.component.States;
import hxd.Key;
import ecs.node.Node;
import ecs.Engine;
import ecs.system.System;
/**
 * System for swapping out the different Sample GameStates.
 */
class SampleSwapperSystem extends System<Event> {
  @:nodes var nodes:Node<States>;
  var samples:Array<Class<GameState>>;
  var current:Int = 0;

  public function new(samples:Array<Class<GameState>>) {
    super();
    this.samples = samples;
  }

  override function update(dt:Float) {
    for (node in nodes) {
      if (Key.isPressed(Key.ENTER)) {
        GM.load_state(cast Type.createInstance(samples[current], []));
      }

      if (Key.isPressed(Key.SPACE)) {
        current += 1;
        if (current >= samples.length) current = 0;
        GM.load_state(cast Type.createInstance(samples[current], []));
      }
    }
  }
}
