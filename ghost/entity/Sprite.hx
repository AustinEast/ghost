package ghost.entity;

import echo.shape.Rect;
import echo.Body;
import ghost.Entity.EntityOptions;
import ghost.component.SpriteRenderer;

typedef SpriteOptions = {
  > EntityOptions,
  ?renderer:SpriteRendererOptions
}

class Sprite extends Entity {
  public var renderer:SpriteRenderer;

  public function new(?options:SpriteOptions) {
    super(options);
    renderer = new SpriteRenderer(options == null ? null : options.renderer);
    components.add(renderer);
  }

  public inline function set_collider_from_graphic():Sprite {
    if (body == null) body = new Body({x: x, y: y, rotation: rotation});
    body.clear_shapes();

    var w = renderer.scale_x * renderer.width;
    var h = renderer.scale_y * renderer.height;

    body.create_shape({
      type: RECT,
      offset_x: renderer.dx + 0.5 * (w - renderer.width + renderer.width),
      offset_y: renderer.dy + 0.5 * (h - renderer.height + renderer.height),
      width: w,
      height: h
    });
    return this;
  }
}
