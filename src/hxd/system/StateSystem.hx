package hxd.system;

import ghost.GM;
import ghost.GameState;
import ghost.Game;
import ghost.sys.Event;
import ghost.util.DestroyUtil;
import hxd.component.States;
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
      // Reset States if requested
      if (states.reset) reset(states);
      // Remove all closed States
      for (state in states.active) {
        if (state.closed) {
          remove(state);
          states.active.remove(state);
        }
      }
      // Create any requested States
      for (state in states.requested) {
        add(state);
        states.active.push(state);
      }
      states.requested = [];
      // Update active States
      for (state in states.active) {
        state.age += dt;
        state.update(state.time_scale * dt);
      }
    }
  }

  function add(state:GameState) {
    GM.log.info('Initializing State: ${Type.getClassName(Type.getClass(state))}');
    state.attach(engine, game.ui);
    state.create();
    state.age = 0;
    // Trigger a scale event for the new state
    game.resized = true;
  }

  function remove(state:GameState) {
    GM.log.info('Destroying State: ${Type.getClassName(Type.getClass(state))}');
    DestroyUtil.destroy(state);
  }

  function reset(states:States) {
    states.reset = false;
    states.requested.push(cast Type.createInstance(states.initial, []));
    DestroyUtil.destroyArray(states.active);
  }
}
