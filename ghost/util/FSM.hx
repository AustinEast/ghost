package ghost.util;

interface State<T> {
  public function enter(parent:T):Void;

  public function step(parent:T, dt:Float):Void;

  public function exit(parent:T):Void;
}

class FSM<T> {
  var parent:T;
  var current:State<T>;
  var requested:State<T>;

  public function new(parent:T, ?initial_state:State<T>) {
    this.parent = parent;
    if (initial_state != null) requested = initialState;
  }

  public function set(state:State<T>):State<T> return requested = state;

  public function step(dt:Float) {
    if (requested != null) {
      if (current != null) {
        current.exit(parent);
      }
      current = requested;
      current.enter(parent);
      requested = null;
    }

    if (current != null) current.step(parent, dt);
  }
}
