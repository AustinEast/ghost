package g2d.node;

import ecs.node.NodeBase;
import g2d.component.Collider;
import g2d.component.Transform;

class Static extends NodeBase {
  public var transform:Transform;
  public var collider:Collider;

  public function new(entity) {
    this.entity = entity;
    this.transform = entity.get(Transform);
    this.collider = entity.get(Collider);
  }
}
