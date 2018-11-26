package ghost.h2d.system;

import ghost.h2d.component.Animator;
import ghost.h2d.component.Sprite;
import ghost.sys.Event;
import ecs.node.Node;
import ecs.Engine;
import ecs.system.System;
/**
 * System for handling 2D Animations.
 */
class AnimationSystem extends System<Event> {
  @:nodes var nodes:Node<Sprite, Animator>;

  override function update(dt:Float) {
    for (node in nodes) {
      var s = node.sprite;
      var a = node.animator;

      if (a.current != null && a.delay != 0 && !a.paused) update_animation(dt, s, a);
      s.bitmap.tile = s.frames[s.current_frame];
    }
  }

  function update_animation(dt:Float, s:Sprite, a:Animator) {
    a.timer += dt;
    if (a.current.looped && a.finished && a.timer > a.delay) {
      a.finished = false;
      a.index = a.reversed ? a.current.frames.length - 1 : 0;
    }
    while (a.timer > a.delay && !a.finished) {
      a.timer -= a.delay;
      a.index += a.reversed ? -1 : 1;
      switch (a.current.direction) {
        case FORWARD:
          if (a.index >= a.current.frames.length - 1) finish_animation(a);
        case REVERSE:
          if (a.index <= 0) finish_animation(a);
        case PINGPONG:
          if (a.reversed && a.index <= 0) {
            a.reversed = false;
            finish_animation(a);
          } else if (!a.reversed && a.index >= a.current.frames.length) {
            a.index = a.current.frames.length - 1;
            a.reversed = true;
          }
      }
      s.current_frame = a.current.frames[a.index];
    }
  }

  inline function finish_animation(a:Animator) {
    a.finished = true;
    if (a.callback != null) a.callback();
    if (a.current.looped) a.timer -= a.current.loop_delay;
  }
}
