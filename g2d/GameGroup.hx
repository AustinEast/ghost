package g2d;

import h2d.Object;
import g2d.GameObject;

typedef GameGroup = TypedGameGroup<GameObject>;

@:generic
class TypedGameGroup<T:GameObject> extends GameObject {
  public var members:Array<T>;

  public function new(?parent:Object) {
    super(parent);
    members = new Array<T>();
  }
}
