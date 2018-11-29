package ghost.h2d.system;

import h3d.Matrix;
import ghost.h2d.component.Sprite;
import ghost.h2d.component.Object;
import ghost.h2d.component.Transform;
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
  @:nodes var objects:Node<Transform, Object>;
  @:nodes var sprites:Node<Transform, Sprite>;
  var last_objects:Node<Transform, Object>;
  var last_sprites:Node<Transform, Sprite>;
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
    for (node in objects) add_object(node.object.object);
    for (node in sprites) add_object(node.sprite.bitmap);
    listeners = [
      objects.nodeAdded.handle((node) -> add_object(node.object.object)),
      objects.nodeRemoved.handle((node) -> remove_object(node.object.object)),
      sprites.nodeAdded.handle((node) -> add_object(node.sprite.bitmap)),
      sprites.nodeRemoved.handle((node) -> remove_object(node.sprite.bitmap)),
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
    var alpha = 1; // (GM.residue / dt).clamp();
    for (node in objects) update_object(node.transform, node.object.object, alpha);
    for (node in sprites) update_object(node.transform, node.sprite.bitmap, alpha);
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
