package gxd.node;

import ecs.node.NodeBase;
import gxd.component.Process;
import gxd.component.Instance;

class GameStateNode extends NodeBase {
  public var gameState:GameState;
  public var process:Process;

  public function new(entity) {
    this.entity = entity;
    this.gameState = cast entity.get(Instance).value;
    this.process = entity.get(Process);
  }
}
