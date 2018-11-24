package ghost.h2d.component;

import ecs.component.Component;

class Object extends Component {
  public var object:h2d.Object;

  public function new(?object:h2d.Object) {
    if (object == null) object = new h2d.Object();
    this.object = object;
  }
}
