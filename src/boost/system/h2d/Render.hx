package boost.system.h2d;

import h3d.Matrix;
import boost.component.h2d.Graphic;
import boost.component.h2d.Object;
import boost.component.h2d.Transform;
import boost.util.DataUtil;
import ecs.node.Node;
import ecs.Engine;
import ecs.system.System;
import tink.CoreApi.CallbackLink;

/**
 * System for handling the rendering of 2D Objects added to a State.
 * 
 * TODO: Re-evaluate this system and how it can support parent/child relationships
 */
class Render extends System {
    @:nodes var objects:Node<Transform, Object>;
	@:nodes var graphics:Node<Transform, Graphic>;
	
    public static var defaults(get, null):DisplayOptions;

	var listeners:CallbackLink;
	var context:h2d.Object;
	
	public function new(context:h2d.Object, ?options:DisplayOptions) {
		super();
        options = DataUtil.copy_fields(options, defaults); 
		if(options.pixelPerfect) context.filter = new h2d.filter.ColorMatrix(Matrix.I());
		this.context = context;
	}
	
	override function onAdded(engine:Engine) {
		super.onAdded(engine);
		for(node in objects) addObjectToDisplay(node);
		for(node in graphics) addGraphicToDisplay(node);
		listeners = [
			objects.nodeAdded.handle(addObjectToDisplay),
			objects.nodeRemoved.handle(removeObjectFromDisplay),
			graphics.nodeAdded.handle(addGraphicToDisplay),
			graphics.nodeRemoved.handle(removeGraphicFromDisplay),
		];
	}
	
	override function onRemoved(engine:Engine) {
		super.onRemoved(engine);
		listeners.dissolve();
		listeners = null;
	}
	
	function addObjectToDisplay(node:Node<Transform, Object>) {
		context.addChild(node.object.object);
	}
	
	function removeObjectFromDisplay(node:Node<Transform, Object>) {
		context.removeChild(node.object.object);
	}

	function addGraphicToDisplay(node:Node<Transform, Graphic>) {
		context.addChild(node.graphic.bitmap);
	}
	
	function removeGraphicFromDisplay(node:Node<Transform, Graphic>) {
		context.removeChild(node.graphic.bitmap);
	}
	
	override function update(dt:Float) {
		for(node in objects) if(node.transform.dirty) update_object(node.transform, node.object.object);
		for(node in graphics) if(node.transform.dirty) update_object(node.transform, node.graphic.bitmap);
	}

	function update_object(t:Transform, o:h2d.Object) {
		t.dirty = false;
		o.x = t.x;
		o.y = t.y;
		o.rotation = t.rotation * 180 / Math.PI;
		o.scaleX = t.scale_x;
		o.scaleY = t.scale_y;
	}

    static function get_defaults() return {
        pixelPerfect: true
    }
}

typedef DisplayOptions = {
    ?pixelPerfect:Bool
}