package gxd.component;

import ecs.component.Component;

class Members<T:GameObject> extends Component {
  var array:Array<T>;

  public var length(default, null):Int;
  public var max:Int;

  public function new() {
    array = [];
    length = 0;
  }

  public function put(object:T):T {
    if (array.indexOf(object) != -1) {
      length += 1;
    }
    return object;
  }

  public function take(object:T):T {
    return object;
  }

  public function for_each(method:T->Void, recurse:Bool = false) {
    for (member in array) {
      if (member != null) {
        if (recurse && member.has(Members)) member.get(Members).for_each((method, recurse));
        method(cast member);
      }
    }
  }
  //   public function first_null():Int {}
  //   public function first_alive():T {}
  //   public function first_dead():T {}
}
