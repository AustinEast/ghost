package ghost.ext;

class IntExt {
  public static inline function clamp(v:Int, min:Int, max:Int):Int return v < min ? min : (v > max ? max : v);
}
