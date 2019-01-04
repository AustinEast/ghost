package gxd.component;

import gxd.GameObject;
import ecs.component.Component;

class Members<T:GameObject> extends Component {
  var array:Array<T>;

  public var length(default, null):Int;
  public var max:Int;

  public function new(max:Int = 0) {
    array = [];
    length = 0;
    this.max = max;
  }

  public function add(object:T):T {
    // Ensure the object hasnt already been added
    if (array.indexOf(object) == -1) {
      // Look for any null spots in the group
      var index = first_null();
      // If one is found, fill it
      if (index != -1) {
        array[index] = object;
        if (index >= length) length = index + 1;
      }
      // Otherwise, add the object if the max size has not been reached
      else if (max == 0 || max > 0 && length >= max) {
        array.push(object);
        length++;
      }
    }
    return object;
  }

  public function remove(object:T):T {
    var index = array.indexOf(object);
    if (index != -1) array[index] = null;
    return object;
  }

  public function for_each(method:T->Void, recurse:Bool = false) {
    for (member in array) {
      if (member != null) {
        if (recurse && member.components.has(Members)) member.components.get(Members).for_each(method, recurse);
        method(cast member);
      }
    }
  }

  public function first_null():Int {
    for (i in 0...array.length) if (array[i] == null) return i;
    return -1;
  }
  //   public function first_alive():T {}
  //   public function first_dead():T {}
}
