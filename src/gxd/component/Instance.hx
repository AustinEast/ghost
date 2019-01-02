package gxd.component;

import ecs.component.Component;

class Instance extends Component {
  public var value:GameObject;
  public var value_type:InstanceType;

  public function new(value:GameObject, value_type:InstanceType) {
    this.value = value;
    this.value_type = value_type;
  }
}

@:enum
abstract InstanceType(Int) from Int to Int {
  var GAMEOBJECT = 0;
  var GROUP = 1;
  var GAMESTATE = 2;
}
