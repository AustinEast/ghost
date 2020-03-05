package ghost.system;

import ghost.component.SpriteRenderer;

class AnimationSystem extends System {
  @:nodes var nodes:Node<SpriteRenderer>;

  override function step(dt:Float) {
    super.step(dt);

    for (node in nodes) {
      var renderer = node.sprite_renderer;
      if (renderer.animations.current != null) {
        if (renderer.animations.current.frames.length == 1) renderer.current_frame = 0;
        else if (renderer.animations.delay != 0 && !renderer.animations.paused) {
          renderer.animations.step(dt);
          renderer.current_frame = renderer.animations.current.frames[renderer.animations.index];
        }
      }
      renderer.bitmap.tile = renderer.frames[renderer.current_frame];
    }
  }
}
