package boost.h2d.system;

import h3d.Matrix;
import boost.h2d.component.Graphic;
import boost.h2d.component.Object;
import boost.h2d.component.Transform;
import boost.sys.Event;
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
class RenderSystem extends System<Event> {
  @:nodes var objects:Node<Transform, Object>;
  @:nodes var graphics:Node<Transform, Graphic>;

  public static var defaults(get, null):DisplayOptions;
  /**
   * TODO
   */
  var listeners:CallbackLink;
  /**
   * The Rendering context that this system will add `h2d.Objects` to.
   */
  var context:h2d.Object;

  public function new(context:h2d.Object, ?options:DisplayOptions) {
    super();
    options = DataUtil.copy_fields(options, defaults);
    if (options.pixelPerfect) context.filter = new h2d.filter.ColorMatrix(Matrix.I());
    this.context = context;
  }

  override function onAdded(engine:Engine<Event>) {
    super.onAdded(engine);
    for (node in objects) add_object(node.object.object);
    for (node in graphics) add_object(node.graphic.bitmap);
    listeners = [
      objects.nodeAdded.handle((node) -> add_object(node.object.object)),
      objects.nodeRemoved.handle((node) -> remove_object(node.object.object)),
      graphics.nodeAdded.handle((node) -> add_object(node.graphic.bitmap)),
      graphics.nodeRemoved.handle((node) -> remove_object(node.graphic.bitmap)),
    ];
  }

  override function onRemoved(engine:Engine<Event>) {
    super.onRemoved(engine);
    listeners.dissolve();
    listeners = null;
  }

  inline function add_object(object:h2d.Object) context.addChild(object);

  inline function remove_object(object:h2d.Object) context.removeChild(object);

  override function update(dt:Float) {
    for (node in objects) if (node.transform.dirty) update_object(node.transform, node.object.object);
    for (node in graphics) if (node.transform.dirty) update_object(node.transform, node.graphic.bitmap);
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
