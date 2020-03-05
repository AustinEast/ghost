package ghost.ext;

class FloatExt {
  public static inline function double(value:Float):Float return value * 2;

  public static inline function half(value:Float):Float return value * 0.5;

  public static inline function third(value:Float):Float return value * 0.333;

  public static inline function quarter(value:Float):Float return value * 0.25;

  public static inline function within(value:Float, a:Float, b:Float):Bool return value > Math.min(a, b) && value < Math.max(a, b);
}
