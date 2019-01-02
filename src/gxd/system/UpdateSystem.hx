package gxd.system;

import gxd.component.Process;
import gxd.component.Instance;
import gxd.node.*;
import gxd.sys.Event;
import ecs.Engine;
import ecs.node.NodeList;
import ecs.node.TrackingNodeList;
import ecs.system.System;

class UpdateSystem extends System<Event> {
  var states:NodeList<GameStateNode>;
  var groups:NodeList<GroupNode>;
  var objects:NodeList<GameObjectNode>;

  override function onAdded(engine:Engine<Event>) {
    super.onAdded(engine);
    states = new TrackingNodeList(engine, GameStateNode.new, entity -> entity.has(Instance) && entity.get(Instance).value_type == GAMESTATE);
    groups = new TrackingNodeList(engine, GroupNode.new, entity -> entity.has(Instance) && entity.get(Instance).value_type == GROUP);
    objects = new TrackingNodeList(engine, GameObjectNode.new, entity -> entity.has(Instance) && entity.get(Instance).value_type == GAMEOBJECT);
  }

  override function update(dt:Float) {
    for (state in states) run_task(dt, state.process);
    for (group in groups) run_task(dt, group.process);
    for (object in objects) run_task(dt, object.process);
  }

  inline function run_task(dt:Float, process:Process) {
    if (process.task != null && process.active) process.task(dt);
    if (!process.loop) process.active = false;
  }
}
