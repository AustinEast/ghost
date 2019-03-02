package g2d;

import h2d.RenderContext;
#if echo
import echo.World;
#end

class GameState extends GameGroup {
  #if echo
  public var world:World;
  #end

  #if echo
  override function sync(ctx:RenderContext) {
    super.sync(ctx);
  }
  #end
}
