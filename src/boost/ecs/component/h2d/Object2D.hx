package boost.ecs.component.h2d;

import h2d.Object;
import ecs.component.Component;

class Object2D extends Component {
  public var object:Object;
  public function new(?object:Object) {
    if (object == null) object = new Object();
    this.object = object;
	}
}