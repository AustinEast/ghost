package ghost;

import echo.util.Disposable;
import hxmath.math.Vector2;
import ghost.util.Color;
#if heaps
import echo.util.Debug.HeapsDebug;
import h2d.Layers;
import h2d.Object;
import h2d.Mask;
import h2d.Graphics;
import h2d.ScaleGrid;
import h2d.col.Bounds;
#elseif openfl
import openfl.display.Sprite;
#end

class Camera extends #if heaps h2d.Camera #elseif openfl Sprite #end {
  public var game(default, null):Game;
  public var display:#if heaps Object #elseif openfl Sprite #end;
  public var target:Null<Entity>;
  public var offset:Vector2;
  public var min:Null<Vector2>;
  public var max:Null<Vector2>;
  public var background_color(default, set):Color;
  public var background:#if heaps Graphics #elseif openfl Sprite #end;

  var pos:Vector2;

  // TODO
  // public var lerp:Float;

  public function new(game:Game) {
    super(#if heaps game.s2d #elseif openfl #end);
    this.game = game;
    background = new Graphics(this);
    display = new Object(background);
    offset = new Vector2(0, 0);

    viewX = game.width * 0.5;
    viewY = game.height * 0.5;

    pos = new Vector2(0, 0);
  }

  public function step(dt:Float) {
    if (target != null) {
      target.get_position(pos);
      if (offset != null) pos += offset;
      viewX = pos.x;
      viewY = pos.y;
    }

    var hw = game.width * 0.5;
    var hh = game.height * 0.5;
    if (max != null) {
      if (viewX > max.x - hw) viewX = max.x - hw;
      if (viewY > max.y - hh) viewY = max.y - hh;
    }
    if (min != null) {
      if (viewX < min.x + hw) viewX = min.x + hw;
      if (viewY < min.y + hh) viewY = min.y + hh;
    }
  }

  public function add(#if heaps object:Object #elseif openfl sprite:Sprite #end) {
    #if heaps
    @:privateAccess
    display.addChildAt(object, 0);
    #elseif openfl

    #end
  }

  // TODO - shake the viewport
  // public function shake() {}

  public function dispose() {
    game = null;
    background.remove();
    background = null;
    display.remove();
    display = null;
    target = null;
  }

  inline function set_background_color(value:Color) {
    background.clear();
    background.beginFill(value.to24Bit(), value.alpha);
    background.drawRect(0, 0, game.width, game.height);
    background.endFill();
    return background_color = value;
  }
}
