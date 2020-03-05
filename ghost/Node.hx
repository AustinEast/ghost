package ghost;

import ghost.util.Components;

@:genericBuild(ghost.util.Macros.build_node())
class Node<Rest> {}

class NodeBase {
  public var entity:Entity;

  var name:String = 'NodeBase';

  public function dispose() {
    entity = null;
  }

  public function toString() {
    return '$name( $entity )';
  }
}
