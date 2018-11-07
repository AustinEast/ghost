package systems;

import boost.GameState;
import boost.GM;
import boost.component.sys.States;
import hxd.Key;
import ecs.node.Node;
import ecs.Engine;
import ecs.system.System;
import states.*;
/**
 * System for swapping out the different Sample GameStates.
 */
class SampleSwapper<Event> extends System<Event> {
  @:nodes var nodes:Node<States>;
  var samples:Array<Class<GameState>> = [SampleState3, SampleState1, SampleState2];
  var current:Int = 0;

  override function update(dt:Float) {
    for (node in nodes) {
      if (Key.isPressed(Key.ENTER)) {
        current = 0;
        node.states.reset = true;
      }

      if (Key.isPressed(Key.SPACE)) {
        current += 1;
        if (current >= samples.length) current = 0;
        GM.load_state(cast Type.createInstance(samples[current], []));
      }
    }
  }
}
