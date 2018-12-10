package h2d.component;

import ghost.GM;
import ecs.component.Component;
import hxd.Math;

class Animator extends Component {
  // @:option public var option
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
  public var members:Map<String, Animation>;

  @:allow(h2d.system.AnimationSystem)
  var delay:Float;
  @:allow(h2d.system.AnimationSystem)
  var timer:Float;
  @:allow(h2d.system.AnimationSystem)
  var reversed:Bool;

  public function new() {
    members = [];
  }
  /**
   * Play an Animation. The Animation must already be added to this Controller.
   * @param name The name of the Animation.
   * @param force If true, the Animation will start over if it is already playing.
   * @param callback A function that is called when the Animation is finished.
   * @param frame The frame index to start the Animation from.
   */
  public function play(name:String, force:Bool = false, callback:Void->Void = null, frame:Int = 0) {
    if (current != null && current.name == name && !force && !finished) return;
    if (members.exists(name)) {
      current = members.get(name);
      index = current.direction == REVERSE ? current.frames.length - frame - 1 : frame;
      index = Math.iclamp(index, 0, current.frames.length - 1);
      this.callback = callback;
      finished = false;
      paused = false;
      reversed = current.direction == REVERSE;
      delay = current.speed > 0 ? 1.0 / current.speed : 0;
      timer = 0;
    }
    else GM.log.warn('Animation `${name}` does not exist on this Entity');
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
  public function add(name:String, frames:Array<Int>, speed:Int = 15, looped:Bool = false, loop_delay:Float = 0,
      direction:AnimationDirection = AnimationDirection.FORWARD):Animation {
    members.exists(name) ? GM.log.warn('Animation `${name}` already exists on this Entity') : members.set(name, {
      name: name,
      frames: frames,
      speed: speed,
      looped: looped,
      loop_delay: loop_delay,
      direction: direction
    });
    return members.get(name);
  }
}

typedef Animation = {
  var name:String;
  var frames:Array<Int>;
  var speed:Int;
  var looped:Bool;
  var loop_delay:Float;
  var direction:AnimationDirection;
  var ?ease:Ease;
}

@:enum
abstract AnimationDirection(String) {
  var FORWARD = 'Forward';
  var REVERSE = 'Reverse';
  var PINGPONG = 'PingPong';
}

// TODO: Add in optional Easing functions on enter/exit
@:enum
abstract Ease(Int) {
  var TODO = 0;
}
