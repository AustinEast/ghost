package boost.hxd.component;

import ecs.component.Component;
/**
 * Ignore Me
 */
class State extends Component {
  public var local2d:h2d.Object;
  public var local3d:h3d.scene.Object;

  public function new(?local2d:h2d.Object, ?local3d:h3d.scene.Object) {
    this.local2d = local2d == null ? new h2d.Object() : local2d;
    this.local3d = local3d == null ? new h3d.scene.Object() : local3d;
  }
}
