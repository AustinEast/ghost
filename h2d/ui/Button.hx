package h2d.ui;

import ghost.Data;
import h2d.Object;
import h2d.Text;
import h2d.Flow;

using h2d.ext.ObjectExt;
using h2d.ui.Styles;

class Button extends Flow {
  public var text:Text;

  public function new(?label:String, ?on_click:Void->Void, ?styles:ButtonStyle, ?parent:Object) {
    super(parent);
    // Construct and Apply the Button's styles
    var nstyles:ButtonStyle = Data.copy_fields(Styles.button, Styles.button_defaults);
    styles = Data.copy_fields(styles, nstyles);
    this.apply_flow_styles(styles.flow);
    // Add the Label text
    text = this.add_text(label, 0, 0, styles.text);
    // Add interactivity
    enableInteractive = true;
    interactive.cursor = Button;
    interactive.onOver = (_) -> {
      backgroundTile = styles.on_over.background;
      if (styles.on_over.color != null) text.textColor = styles.on_over.color;
    }
    interactive.onPush = (_) -> {
      backgroundTile = styles.on_click.background;
      if (styles.on_click.color != null) text.textColor = styles.on_click.color;
    }
    interactive.onRelease = (_) -> {
      if (interactive.isOver()) {
        on_click();
        backgroundTile = styles.on_over.background;
        if (styles.on_click.color != null) text.textColor = styles.on_over.color;
      }
    }
    interactive.onOut = (_) -> {
      backgroundTile = styles.on_out.background;
      if (styles.on_out.color != null) text.textColor = styles.on_out.color;
    }
  }
}
