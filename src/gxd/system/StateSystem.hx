package gxd.system;

import gxd.GM;
import gxd.Game;
import gxd.component.Instance;
import gxd.node.GameStateNode;
import gxd.sys.Event;
import ecs.Engine;
import ecs.node.NodeList;
import ecs.node.TrackingNodeList;
import ecs.system.System;
import tink.CoreApi.CallbackLink;
/**
 * System for managing the current `GameState`
 */
class StateSystem extends System<Event> {
  var nodes:NodeList<GameStateNode>;
  var listeners:CallbackLink;
  var game:Game;

  public function new(game:Game) {
    super();
    this.game = game;
  }

  override function onAdded(engine:Engine<Event>) {
    super.onAdded(engine);
    nodes = new TrackingNodeList(engine, GameStateNode.new, entity -> entity.has(Instance) && entity.get(Instance).value_type == GAMESTATE);
    for (node in nodes) add(node);
    listeners = [nodes.nodeAdded.handle(add)];
  }

  override function onRemoved(engine:Engine<Event>) {
    super.onRemoved(engine);
    listeners.dissolve();
    listeners = null;
  }

  function add(node:GameStateNode) {
    GM.log.info('Initializing GameState: ${Type.getClassName(Type.getClass(node.gameState))}');
    node.gameState.attach(engine, game.ui);
    node.gameState.create();
    node.gameState.age = 0;
  }

  override function update(dt:Float) {
    for (node in nodes) if (node.gameState.closed) {
      GM.log.info('Destroying GameState: ${Type.getClassName(Type.getClass(node.gameState))}');
      node.gameState.destroy();
    }
  }
}
