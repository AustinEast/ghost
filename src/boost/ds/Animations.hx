package boost.ds;

import haxe.ds.StringMap;
import hxd.Math;
import boost.util.DestroyUtil.IDestroyable;

/**
 * Animation Controller Class.
 */
class Animations extends StringMap<Animation> implements IDestroyable {
	/**
	 * The current Animation.
	 */
	public var current:Animation;
	/**
	 * The current frame the Animation is displaying.
	 */
	public var index:Int;
	/**
	 * Flag to check if the current Animation is paused.
	 * If it is, the current Animation will not advance to the next frame.
	 */
	public var paused:Bool;
	/**
	 * Flag to check if the current Animation is finished.
	 */
	public var finished:Bool;
	/**
	 * A function that is called when the current Animation is finished.
	 * If the animation is looped, this will get called after every loop is finished.
	 */
	public var callback:Void->Void;

	@:allow(boost.ecs.system.render.Render2D)
	var delay:Float;
	@:allow(boost.ecs.system.render.Render2D)
	var timer:Float;
	@:allow(boost.ecs.system.render.Render2D)
	var reversed:Bool;

    /**
     * Play an Animation. The Animation must already be added to this Controller.
     * @param name The name of the Animation.
     * @param force If true, the Animation will start over if it is already playing.
     * @param callback A function that is called when the Animation is finished.
     * @param frame The frame index to start the Animation from.
     */
    public function play(name:String, force:Bool = false, callback:Void->Void = null, frame:Int = 0) {
		if (current != null && current.name == name && !force && !finished) return;
		if (exists(name)) {
			current = get(name);
			index = current.direction == REVERSE ? current.frames.length - frame - 1 : frame;
			index = Math.iclamp(index, 0, current.frames.length - 1);
			this.callback = callback;
			finished = false;
			paused = false;
			reversed = current.direction == REVERSE;
			delay = current.speed > 0 ? 1.0 / current.speed : 0;
			timer = 0;
		} else GM.log.warn('Animation `${name}` does not exist on this Entity');
	}
	/**
	 * Adds an Animation to the Controller.
	 * @param name The name of the Animation.
	 * @param frames The indexes of the frames that will be played.
	 * @param speed The speed of the Animation playback in frames per second.
	 * @param looped Flag to set if the Animation loops.
	 * @param loop_delay Delay between each loop of the Animation in seconds.
	 * @param direction Direction the Animation will traverse it's frames.
	 * @return Animation
	 */
	public function add(name:String, frames:Array<Int>, speed:Int = 15, looped:Bool = false, loop_delay:Float = 0, direction:AnimationDirection = AnimationDirection.FORWARD):Animation {
		exists(name) ? GM.log.warn('Animation `${name}` already exists on this Entity') 
		: set(name, { name:name, frames:frames, speed:speed, looped:looped, loop_delay:loop_delay, direction:direction });
		return get(name);
	}

    public function destroy() {
		current = null;
		for (key in keys()) remove(key);
    }
}

typedef Animation = {
    name:String,
	frames:Array<Int>,
	speed:Int,
	looped:Bool,
	loop_delay:Float,
	direction: AnimationDirection,
	?ease:Ease
}

@:enum 
abstract AnimationDirection (String) {
	var FORWARD  = 'Forward';
	var REVERSE  = 'Reverse';
	var PINGPONG = 'PingPong';
}

// TODO: Add in optional Easing functions on enter/exit
@:enum 
abstract Ease (Int) {
	var TODO  = 0;
}