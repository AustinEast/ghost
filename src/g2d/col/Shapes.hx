package g2d.col;

abstract Shapes(Array<Shape>) {
  public static function rounded_rect():Array<Shape> {
    var arr:Array<Shape> = [];
    return arr;
  }

  public function new(?s:Array<Shape>) {
    if (s == null) this = [];
    else this = s;
  }
}
