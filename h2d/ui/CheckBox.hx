package h2d.ui;

import h2d.Flow;
import h2d.Object;

using h2d.ext.ObjectExt;

class CheckBox extends Flow {
  public var checked:Bool;

  var text:Text;
  var box:Bitmap;
  var on_toggle:Null<Bool->Void>;
  var checked_tile:Tile;
  var unchecked_tile:Tile;

  public function new(?label:String, ?on_toggle:Bool->Void, ?parent:Object) {
    super(parent);
    this.on_toggle = on_toggle;
    checked = false;
    checked_tile = Tile.fromColor(0xFFFFFF, 8, 8);
    unchecked_tile = Tile.fromColor(0x696a6a, 8, 8);
    text = this.add_text(label, 0, 0, Styles.text_defaults);
    box = this.add_bitmap(unchecked_tile);
    horizontalSpacing = 4;
    enableInteractive = true;
    interactive.cursor = Button;
    interactive.onRelease = (_) -> {
      if (interactive.isOver()) {
        toggle();
      }
    }
  }

  public function toggle() {
    checked = !checked;
    box.tile = checked ? checked_tile : unchecked_tile;
    if (on_toggle != null) on_toggle(checked);
  }
}
