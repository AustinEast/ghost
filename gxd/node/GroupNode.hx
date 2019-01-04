package gxd.node;

import ecs.node.NodeBase;
import gxd.component.Process;
import gxd.component.Instance;

class GroupNode extends NodeBase {
  public var group:Group;
  public var process:Process;

  public function new(entity) {
    this.entity = entity;
    this.group = cast entity.get(Instance).value;
    this.process = entity.get(Process);
  }
}
