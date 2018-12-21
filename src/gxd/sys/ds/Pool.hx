package gxd.sys.ds;

import gxd.util.DestroyUtil;
/**
 * Generic Pooling container
 */
class Pool<T:IDestroyable> implements IPool<T> {
  public var length(get, null):Int;

  var pool:Array<T>;
  var clazz:Class<T>;
  var count:Int;

  public function new(clazz:Class<T>) {
    this.clazz = clazz;
    pool = [];
    count = 0;
  }

  public function get():T {
    if (count == 0) return Type.createInstance(clazz, []);
    return pool[--count];
  }

  public function put(obj:T):Void {
    // we don't want to have the same object in the accessible pool twice (ok to have multiple in the inaccessible zone)
    if (obj != null) {
      var i:Int = pool.indexOf(obj);
      // if the object's spot in the pool was overwritten, or if it's at or past count (in the inaccessible zone)
      if (i == -1 || i >= count) {
        obj.destroy();
        pool[count++] = obj;
      }
    }
  }

  public function putUnsafe(obj:T):Void {
    if (obj != null) {
      obj.destroy();
      pool[count++] = obj;
    }
  }

  public function pre_allocate(amount:Int):Void {
    while (amount-- > 0) pool[count++] = Type.createInstance(clazz, []);
  }

  public function clear():Array<T> {
    count = 0;
    var old_pool = pool;
    pool = [];
    return old_pool;
  }

  public function get_length() return count;
}

interface IPooled extends IDestroyable {
  function put():Void;
  private var pooled:Bool;
}

interface IPool<T:IDestroyable> {
  function pre_allocate(amount:Int):Void;
  function clear():Array<T>;
}
