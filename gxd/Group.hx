package gxd;

import gxd.GameObject;
import gxd.component.Instance;
import gxd.component.Members;

typedef Group = TypedGroup<GameObject>;

class TypedGroup<T:GameObject> extends GameObject {
  public var members(default, null):Members<T>;

  public function new() {
    members = new Members();
    super();
  }

  override function init_components() {
    components.add(process);
    components.add(members);
    components.add(new Instance(this, GROUP));
  }
  /**
   * Adds a GameObject to the Group.
   * @param object The GameObject to add.
   * @return The added GameObject. Useful for chaining.
   */
  public function add(object:T):T return members.add(object);
  /**
   * Removes a GameObject from the Group.
   * @param object The GameObject to remove.
   * @return The removed GameObject. Useful for chaining.
   */
  public function remove(object:T):T return members.remove(object);

  public function for_each(method:T->Void, recurse:Bool = false) members.for_each(method, recurse);

  override public function destroy() {
    super.destroy();
    members = null;
  }
}
