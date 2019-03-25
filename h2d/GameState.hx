package h2d;

import hxd.GM;
import ghost.Process;
import h2d.Object;
import h2d.ghost.Camera;
import echo.World;
import echo.data.Options;

class GameState extends Process {
  public var entities:Array<Entity>;
  public var world:World;
  public var camera:Camera;
  public var ui:Object;

  public function new(?world_options:WorldOptions, ?parent:Process) {
    super(parent);
    entities = [];
    if (world_options == null) world_options = {width: GM.width, height: GM.height};
    world = new World(world_options);
    camera = new Camera();
    ui = new Object();
    attach();
  }

  public function add(entity:Entity):Entity {
    if (entity.state != null) entity.state.remove(entity);
    entities.push(entity);
    entity.added(this);
    return entity;
  }

  public function remove(entity:Entity):Entity {
    if (entities.remove(entity)) entity.removed(this);
    return entity;
  }

  function attach() {
    GM.game.viewport.addChild(camera);
    GM.game.ui.addChild(ui);
  }

  function dettach() {
    camera.remove();
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
    world.step(dt);
    for (e in entities) if (e.active && !e.disposed) e.post_step(dt);
  }

  override function dispose() {
    super.dispose();
    for (e in entities) e.dispose();
    entities = null;
    world.dispose();
    world = null;
    dettach();
    camera = null;
    ui = null;
  }
}
