package ghost.util;

@:forward(split)
abstract ComponentType(String) {
  inline function new(value:String) this = value;

  @:from
  public static inline function ofClass(value:Class<Component>):ComponentType return new ComponentType(Type.getClassName(value));

  @:from
  public static inline function ofInstance(value:Component):ComponentType return ofClass(Type.getClass(value));

  @:to
  public inline function toClass():Class<Component> return cast Type.resolveClass(this);

  @:to
  public inline function toString():String return this;
}
