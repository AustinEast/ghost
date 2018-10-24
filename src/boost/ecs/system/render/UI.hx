package boost.ecs.system.render;

import h2d.Object;
import h3d.Matrix;
import boost.ecs.component.ui.Container;
import boost.util.DataUtil;
import ecs.node.Node;
import ecs.Engine;
import ecs.system.System;
import tink.CoreApi.CallbackLink;

/**
 * System for handling the Rendering of UI Elements.
 */
class UI extends System {
    @:nodes var nodes:Node<Container>;
	
	var listeners:CallbackLink;
	var context:Object;
	
	public function new(context:Object) {
		super();
		this.context = context;
	}
	
	override function onAdded(engine:Engine) {
		super.onAdded(engine);
		for(node in nodes) addToDisplay(node);
		listeners = [
			nodes.nodeAdded.handle(addToDisplay),
			nodes.nodeRemoved.handle(removeFromDisplay),
		];
	}
	
	override function onRemoved(engine:Engine) {
		super.onRemoved(engine);
		listeners.dissolve();
		listeners = null;
	}
	
	function addToDisplay(node:Node<Container>) {
		// context.addChild(node.object2D.object);
	}
	
	function removeFromDisplay(node:Node<Container>) {
		// context.removeChild(node.object2D.object);
	}
	
	override function update(dt:Float) {
		for(node in nodes) {
			
		}
	}
}
