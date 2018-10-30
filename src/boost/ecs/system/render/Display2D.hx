package boost.ecs.system.render;

import h2d.Object;
import h3d.Matrix;
import boost.ecs.component.h2d.Object2D;
import boost.ecs.component.h2d.Transform2D;
import boost.util.DataUtil;
import ecs.node.Node;
import ecs.Engine;
import ecs.system.System;
import tink.CoreApi.CallbackLink;

/**
 * System for handling the display of 2D objects added to a State.
 * 
 * TODO: Re-evaluate this system and how it can support parent/child relationships
 */
class Display2D extends System {
    @:nodes var nodes:Node<Transform2D, Object2D>;
	
    public static var defaults(get, null):Display2DOptions;

	var listeners:CallbackLink;
	var context:Object;
	
	public function new(context:Object, ?options:Display2DOptions) {
		super();
        options = DataUtil.copy_fields(options, defaults); 
		if(options.pixelPerfect) context.filter = new h2d.filter.ColorMatrix(Matrix.I());
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
	
	function addToDisplay(node:Node<Transform2D, Object2D>) {
		context.addChild(node.object2D.object);
	}
	
	function removeFromDisplay(node:Node<Transform2D, Object2D>) {
		context.removeChild(node.object2D.object);
	}
	
	override function update(dt:Float) {
		for(node in nodes) {
			var transform = node.transform2D;
			if (transform.dirty) {
				transform.dirty = false;
				var object = node.object2D.object;
				object.x = transform.x;
				object.y = transform.y;
				object.rotation = transform.rotation * 180 / Math.PI;
				object.scaleX = transform.scale_x;
				object.scaleY = transform.scale_y;
			}
		}
	}

    static function get_defaults() return {
        pixelPerfect: true
    }
}

typedef Display2DOptions = {
    ?pixelPerfect:Bool
}