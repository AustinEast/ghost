package boost.hxd.system;

import boost.Game;
import boost.hxd.component.States;
import boost.sys.Event;
import boost.util.DestroyUtil;
import ecs.node.Node;
import ecs.system.System;
import tink.CoreApi.CallbackLink;
/**
 * System for managing the current `State`
 */
class StateSystem extends System<Event> {
  @:nodes var nodes:Node<States>;
  var listeners:CallbackLink;
  var game:Game;

  public function new(game:Game) {
    super();
    this.game = game;
  }

  override function update(dt:Float) {
    for (node in nodes) {
      var states = node.states;
      if (states.reset) reset(states);
      for (state in states.requested) {
        add(state);
        states.active.push(state);
      }
      states.requested = [];
      for (state in states.active) {
        if (state.closed) {
          remove(state);
          states.active.remove(state);
          continue;
        }
        state.age += dt;
        state.update(state.time_scale * dt);
      }
    }
  }

  function add(state:GameState) {
    GM.log.info('Initializing State: ${Type.getClassName(Type.getClass(state))}');
    state.attach(engine);
    state.create();
    state.age = 0;
    // Trigger a scale event for the new state
    game.resized = true;
  }

  function remove(state:GameState) {
    GM.log.info('Destroying State: ${Type.getClassName(Type.getClass(state))}');
    state.close_callback();
    DestroyUtil.destroy(state);
  }

  function reset(states:States) {
    states.reset = false;
    states.requested.push(cast Type.createInstance(states.initial, []));
    DestroyUtil.destroyArray(states.active);
  }
}
