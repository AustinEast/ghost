package h3d;

import hxd.GM;
import ghost.Process;
import h3d.scene.Object;

class GameState extends Process {
  public var entities:Array<Entity>;
  public var base:Object;
  public var ui:h2d.Object;

  public function new(?parent:Process) {
    super(parent);
    entities = [];
    base = new Object();
    ui = new h2d.Object();
    attach();
  }

  public function add(entity:Entity) {
    if (entity.state != null) entity.state.remove(entity);
    entities.push(entity);
    entity.added(this);
  }

  public function remove(entity:Entity) {
    if (entities.remove(entity)) entity.removed(this);
  }

  function attach() {
    GM.game.s3d.addChild(base);
    GM.game.ui.addChild(ui);
  }

  function dettach() {
    base.remove();
    ui.remove();
  }

  override function pre_step(dt:Float) {
    super.step(dt);
    for (e in entities) if (e.active && !e.disposed) e.pre_step(dt);
  }

  override function step(dt:Float) {
    super.step(dt);
    for (e in entities) if (e.active && !e.disposed) e.step(dt);
  }

  override function post_step(dt:Float) {
    super.step(dt);
    for (e in entities) if (e.active && !e.disposed) e.post_step(dt);
  }

  override function dispose() {
    super.dispose();
    for (e in entities) e.dispose();
    entities = null;
    dettach();
    base = null;
    ui = null;
  }
}
