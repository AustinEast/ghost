package g2d;

import glib.Disposable;
import h2d.Object;
#if ecs
import ecs.Entity;
#end

class GameObject extends Object implements IDisposable {
  public var state:GameState;
  #if ecs
  public var components:ecs.Entity;
  #end

  public function new(?parent:Object) {
    super(parent);
    #if ecs
    components:ecs.Entity;
    #end
  }

  public function update(dt:Float) {}

  public function dispose() {
    state = null;
    #if ecs
    components.destroy();
    components = null;
    #end
  }
}
