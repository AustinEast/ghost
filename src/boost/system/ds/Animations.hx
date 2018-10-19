package boost.system.ds;

import haxe.ds.StringMap;
import hxd.Math;
import boost.util.DestroyUtil.IDestroyable;

class Animations extends StringMap<Animation> implements IDestroyable {

	public var current:Animation;
	public var finished:Bool;
	public var delay:Float;
	public var timer:Float;
	public var index:Int;
	public var paused:Bool;

    public function play(name:String, force:Bool = false, frame:Int = 0) {
		if (current != null && current.name == name && !force && !finished) return;
		if (exists(name)) {
			current = get(name);
			frame = Math.iclamp(frame, 0, current.frames.length - 1);
			index = current.direction == REVERSE ? current.frames.length - frame - 1 : frame;
			finished = false;
			paused = false;
			delay = current.speed > 0 ? 1.0 / current.speed : 0;
			timer = 0;
		} else GM.log.warn('Animation `${name}` does not exist on this Entity');
	}

	public function add(name:String, frames:Array<Int>, speed:Int = 15, looped:Bool = false, direction:AnimationDirection = AnimationDirection.FORWARD):Animation {
		exists(name) ? GM.log.warn('Animation `${name}` already exists on this Entity') 
		: set(name, { name:name, frames:frames, speed:speed, looped:looped, direction: direction });
		return get(name);
	}

    public function destroy() {

    }
}

typedef Animation = {
    name:String,
	frames:Array<Int>,
	speed:Int,
	looped:Bool,
	direction: AnimationDirection,
	?ease:Ease
}

@:enum 
abstract AnimationDirection (Int) {
	var FORWARD  = 0;
	var REVERSE  = 1;
	var PINGPONG = 2;
}

// TODO: Add in optional Easing functions on enter/exit
@:enum 
abstract Ease (Int) {
	var TODO  = 0;
}