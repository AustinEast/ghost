package gxd;

import gxd.GameObject;
import gxd.component.Members;

typedef Group = TypedGroup<GameObject>;

class TypedGroup<T:GameObject> extends GameObject {
  public var members(default, null):Members<T>;

  public function new() {
    super();
    members = new Members();
  }

  public function put(object:T):T return members.put(object);

  public function take(object:T):T return members.take(object);

  override public function destroy() {}
}
