package ghost.system;

import ghost.component.Animations;

class AnimationSystem extends System {
  @:nodes var nodels:Node<Animations>;

  override function step(dt:Float) {
    super.step(dt);

    for (node in nodels) {
      var animations = node.animations;
      if (animations.current == null) return;

      inline function finish_animation(animations:Animations) {
        animations.finished = true;
        if (animations.callback != null) animations.callback();
        if (animations.current.looped) animations.timer -= animations.current.loop_delay;
      }

      animations.timer += dt;
      if (animations.current.looped && animations.finished && animations.timer > animations.delay) {
        animations.finished = false;
        animations.index = animations.reversed ? animations.current.frames.length - 1 : 0;
      }
      while (animations.timer > animations.delay && !animations.finished) {
        animations.timer -= animations.delay;
        animations.index += animations.reversed ? -1 : 1;
        switch (animations.current.direction) {
          case FORWARD:
            if (animations.index >= animations.current.frames.length - 1) finish_animation(animations);
          case REVERSE:
            if (animations.index <= 0) finish_animation(animations);
          case PINGPONG:
            if (animations.reversed && animations.index <= 0) {
              animations.reversed = false;
              finish_animation(animations);
            }
            else if (!animations.reversed && animations.index >= animations.current.frames.length) {
              animations.index = animations.current.frames.length - 1;
              animations.reversed = true;
            }
        }
      }

      // OLD WAY
      // var renderer = node.sprite_renderer;
      // if (renderer.animations.current != null) {
      //   if (renderer.animations.current.frames.length == 1) renderer.current_frame = 0;
      //   else if (renderer.animations.delay != 0 && !renderer.animations.paused) {
      //     renderer.animations.step(dt);
      //     renderer.current_frame = renderer.animations.current.frames[renderer.animations.index];
      //   }
      // }
      // renderer.bitmap.tile = renderer.frames[renderer.current_frame];
    }
  }
}
