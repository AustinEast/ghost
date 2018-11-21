package boost.hxd.component;

import boost.sys.Event;
import ecs.system.SystemCollection;
import ecs.entity.EntityCollection;
import ecs.component.Component;
/**
 * Ignore Me
 */
class State extends Component {
  public var name(default, null):String;
  public var local2d:h2d.Object;
  public var local3d:h3d.scene.Object;
  public var create:Void->Void;
  public var update:Float->Void;

  var entities:EntityCollection;
  var systems:SystemCollection<Event>;

  public function new(name:String) {
    this.name = name;
  }
}
