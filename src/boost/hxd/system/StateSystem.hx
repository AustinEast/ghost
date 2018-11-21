package boost.hxd.system;

import boost.hxd.component.States;
import boost.hxd.component.Game;
import boost.util.DestroyUtil;
import ecs.node.Node;
import ecs.system.System;
import tink.CoreApi.CallbackLink;
/**
 * System for managing the current `State`
 */
class StateSystem<Event> extends System<Event> {
  @:nodes var nodes:Node<States, Game>;
  var listeners:CallbackLink;

  public function new() {
    super();
  }

  override function update(dt:Float) {
    for (node in nodes) {
      var states = node.states;
      if (states.reset) reset(states);
      for (state in states.requested) {
        add(state, node.game);
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

  function add(state:State, game:Game) {
    GM.log.info('Initializing State: ${Type.getClassName(Type.getClass(state))}');
    state.attach(game.mask2d, game.s3d);
    if (Std.is(state, GameState)) cast(state, GameState).init_systems();
    state.init();
    state.age = 0;
    // Trigger a scale event for the new state
    game.resized = true;
  }

  function remove(state:State) {
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
