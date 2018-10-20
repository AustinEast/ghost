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
			if (states.active != states.requested) switch_state(node);
			states.active.try_update(dt);
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

    function switch_state(node:Node<States,Game>) {
		GM.log.info('Opening State:');
		if (node.states.active != null) {
			GM.log.info('- Destroying Prior State: ${Type.getClassName(Type.getClass(node.states.active))}');
			DestroyUtil.destroy(node.states.active);
		}
		node.states.active = node.states.requested;
		GM.log.info('- Initializing State: ${Type.getClassName(Type.getClass(node.states.active))}');
		node.states.active.attach(node.game.s2d, node.game.s3d);
		if (Std.is(node.states.active, GameState)) cast (node.states.active, GameState).init_systems();
		node.states.active.init();
		GM.log.info('- State Initialized');
		// Trigger a scale event for the new state
		node.game.resized = true;
	}

    function reset(states:States) {
		states.reset = false;
		states.requested = cast Type.createInstance(states.initial, []);
	}
}