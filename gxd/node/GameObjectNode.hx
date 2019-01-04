package gxd.node;

import ecs.node.NodeBase;
import gxd.component.Process;
import gxd.component.Instance;

class GameObjectNode extends NodeBase {
  public var gameObject:GameObject;
  public var process:Process;

  public function new(entity) {
    this.entity = entity;
    this.gameObject = cast entity.get(Instance).value;
    this.process = entity.get(Process);
  }
}
