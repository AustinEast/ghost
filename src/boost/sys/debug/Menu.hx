package boost.sys.debug;

import h2d.Object;

class Menu extends Object {
  var stats:Stats;

  public function new(?parent:Object) {
    super(parent);
    stats = new Stats(this);
  }

  public function update(dt:Float) {
    stats.update(dt);
  }
}
