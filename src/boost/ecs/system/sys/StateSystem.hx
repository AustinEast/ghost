package boost.ecs.system.sys;

import boost.util.DestroyUtil;
import boost.ecs.component.sys.States;
import boost.ecs.component.sys.Game;
import ecs.node.Node;
import ecs.system.System;

import tink.CoreApi.CallbackLink;

/**
 * System for managing the current `State`
 */
class StateSystem extends System {
	@:nodes var nodes:Node<States,Game>;

	var listeners:CallbackLink;

	public function new() {
		super();
	}

	override function update(dt:Float) {
		for(node in nodes) {
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

	override function onAdded(engine:ecs.Engine) {
		super.onAdded(engine);
		for(node in nodes) addToDisplay(node);
		listeners = [
			nodes.nodeAdded.handle(addToDisplay),
			nodes.nodeRemoved.handle(removeFromDisplay),
		];
	}
	
	override function onRemoved(engine:ecs.Engine) {
		super.onRemoved(engine);
		listeners.dissolve();
		listeners = null;
	}
	
	function addToDisplay(node:Node<States,Game>) {
		// context2d.add(node.states.local2d, 0);
		// context3d.add(node.states.local3d);
	}
	
	function removeFromDisplay(node:Node<States,Game>) {
		// context2d.removeChild(node.states.local2d);
		// context3d.removeChild(node.states.local3d);
	}

    function add(state:State, game:Game) {	
		GM.log.info('Initializing State: ${Type.getClassName(Type.getClass(state))}');
		state.attach(game.mask2d, game.s3d);
		if (Std.is(state, GameState)) cast (state, GameState).init_systems();
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
	}
}