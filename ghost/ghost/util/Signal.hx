package ghost.util;

import haxe.Constraints.Function;
import ghost.util.Macros;
/**
 * Signal implementation from: https://gist.github.com/nadako/b086569b9fffb759a1b5
**/
@:genericBuild(ghost.util.Macros.build_signal())
class Signal<Rest> {}

class SignalBase<T:Function> {
  var head:SignalConnection<T>;
  var tail:SignalConnection<T>;
  var toAddHead:SignalConnection<T>;
  var toAddTail:SignalConnection<T>;
  var dispatching:Bool;

  public function new() {
    dispatching = false;
  }

  public function add(listener:T, once = false):SignalConnection<T> {
    var conn = new SignalConnection(this, listener, once);
    if (dispatching) {
      if (toAddHead == null) {
        toAddHead = toAddTail = conn;
      }
      else {
        toAddTail.next = conn;
        conn.previous = toAddTail;
        toAddTail = conn;
      }
    }
    else {
      if (head == null) {
        head = tail = conn;
      }
      else {
        tail.next = conn;
        conn.previous = tail;
        tail = conn;
      }
    }
    return conn;
  }

  public function remove(conn:SignalConnection<T>):Void {
    if (head == conn) head = head.next;
    if (tail == conn) tail = tail.previous;
    if (toAddHead == conn) toAddHead = toAddHead.next;
    if (toAddTail == conn) toAddTail = toAddTail.previous;
    if (conn.previous != null) conn.previous.next = conn.next;
    if (conn.next != null) conn.next.previous = conn.previous;
  }

  inline function start_dispatch():Void {
    dispatching = true;
  }

  function end_dispatch():Void {
    dispatching = false;
    if (toAddHead != null) {
      if (head == null) {
        head = toAddHead;
        tail = toAddTail;
      }
      else {
        tail.next = toAddHead;
        toAddHead.previous = tail;
        tail = toAddTail;
      }
      toAddHead = toAddTail = null;
    }
  }
}

@:allow(ghost.util.SignalBase)
@:access(ghost.util.SignalBase)
class SignalConnection<T:Function> {
  var signal:SignalBase<T>;
  var listener:T;
  var once:Bool;

  var previous:SignalConnection<T>;
  var next:SignalConnection<T>;

  function new(signal:SignalBase<T>, listener:T, once:Bool) {
    this.signal = signal;
    this.listener = listener;
    this.once = once;
  }

  public function dispose():Void {
    if (signal != null) {
      signal.remove(this);
      signal = null;
    }
  }
}
