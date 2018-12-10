package h2d.system;

import h3d.Matrix;
import h2d.component.Graphic;
import h2d.component.Object;
import h2d.component.Transform;
import ghost.sys.Event;
import ghost.util.DataUtil;
import ecs.node.Node;
import ecs.Engine;
import ecs.system.System;
import tink.CoreApi.CallbackLink;

using hxd.Math;
/**
 * System for handling the rendering of 2D Objects added to a State.
 *
 * TODO: Re-evaluate this system and how it can support parent/child relationships
 */
class RenderSystem extends System<Event> {
  @:nodes var nodes:Node<Transform>;
  @:nodes var objects:Node<Transform, Object>;
  @:nodes var graphics:Node<Transform, Graphic>;
  var bias:Float = 5;

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
    for (node in nodes) add_context(node);
    for (node in graphics) add_graphic(node);
    for (node in objects) add_object(node);

    listeners = [
      nodes.nodeAdded.handle(add_context),
      nodes.nodeRemoved.handle(remove_context),
      graphics.nodeAdded.handle(add_graphic),
      graphics.nodeRemoved.handle(remove_graphic),
      objects.nodeAdded.handle(add_object),
      objects.nodeRemoved.handle(remove_object)
    ];
  }

  override function onRemoved(engine:Engine<Event>) {
    super.onRemoved(engine);
    listeners.dissolve();
    listeners = null;
  }

  inline function add_context(node:Node<Transform>) node.transform.context = context;

  inline function remove_context(node:Node<Transform>) node.transform.context = null;

  inline function add_graphic(node:Node<Transform, Graphic>) node.transform.object.addChild(node.graphic.bitmap);

  inline function remove_graphic(node:Node<Transform, Graphic>) node.graphic.bitmap.remove();

  inline function add_object(node:Node<Transform, Object>) node.transform.object.addChild(node.object.object);

  inline function remove_object(node:Node<Transform, Object>) node.object.object.remove();

  override function update(dt:Float) {
    // var alpha = (GM.residue / dt).clamp();
    // for (node in objects) update_object(node.transform, node.object.object, alpha);
    // for (node in sprites) update_object(node.transform, node.sprite.bitmap, alpha);
  }

  inline function update_object(t:Transform, o:h2d.Object, alpha:Float) {
    o.x = interp(o.x, t.x, alpha);
    o.y = interp(o.y, t.y, alpha);
    o.rotation = interp(o.rotation, t.rotation, alpha);
    o.scaleX = interp(o.scaleX, t.scale_x, alpha);
    o.scaleY = interp(o.scaleY, t.scale_y, alpha);
  }

  inline function interp(from:Float, to:Float, alpha:Float):Float return (to - from).abs() > bias ? to : to * alpha + from * (1 - alpha);

  static function get_defaults() return {
    pixelPerfect: true
  }
}

typedef DisplayOptions = {
  ?pixelPerfect:Bool
}
