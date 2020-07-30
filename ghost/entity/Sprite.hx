package ghost.entity;

import ghost.component.Animations;
import echo.shape.Rect;
import echo.Body;
import ghost.Entity.EntityOptions;
import ghost.component.SpriteRenderer;

typedef SpriteOptions = {
  > EntityOptions,
  ?animations:Array<Animation>,
  ?renderer:SpriteRendererOptions
}

class Sprite extends Entity {
  public var animations:Animations;
  public var renderer:SpriteRenderer;

  public function new(?options:SpriteOptions) {
    super(options);
    animations = new Animations(options.animations);
    components.add(animations);
  }

  public inline function set_collider_from_graphic():Sprite {
    if (body == null) body = new Body({x: x, y: y, rotation: rotation});
    body.clear_shapes();

    if (renderer == null) return this;

    var w = renderer.scale_x * renderer.width;
    var h = renderer.scale_y * renderer.height;

    body.create_shape({
      type: RECT,
      offset_x: renderer.offset_x + 0.5 * (w - renderer.width + renderer.width),
      offset_y: renderer.offset_y + 0.5 * (h - renderer.height + renderer.height),
      width: w,
      height: h
    });
    return this;
  }
}
