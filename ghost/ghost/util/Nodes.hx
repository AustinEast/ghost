package ghost.util;

import ghost.util.Signal.SignalConnection;

@:structInit
class NodeListeners {
  var added:SignalConnection<Component->Void>;
  var removed:SignalConnection<Component->Void>;

  public function dispose() {
    added.dispose();
    removed.dispose();
  }
}

@:generic
class Nodes<T:Node.NodeBase> {
  public var added:Signal<T>;
  public var removed:Signal<T>;

  var game:Game;
  var factory:Components->T;
  var filter:Components->Bool;
  var track_adds:SignalConnection<Entity->Void>;
  var track_removes:SignalConnection<Entity->Void>;
  var components:Array<Int>;
  var members:Array<T>;
  var listeners:Map<Components, NodeListeners>;

  public function new(game:Game, factory:Components->T, filter:Components->Bool) {
    this.game = game;
    this.factory = factory;
    this.filter = filter;
    components = [];
    members = [];
    listeners = [];

    added = new Signal<T>();
    removed = new Signal<T>();

    game.entities.for_each(entity -> {
      track(entity.components);
      if (filter(entity.components)) add(entity.components);
    });

    track_adds = game.entities.added.add(entity -> {
      track(entity.components);
      if (filter(entity.components)) add(entity.components);
    });
    track_removes = game.entities.removed.add(entity -> {
      untrack(entity.components);
      remove(entity.components);
    });
  }

  function add(components:Components) {
    if (this.components.indexOf(components.id) == -1) {
      this.components.push(components.id);
      var node = factory(components);
      members.push(node);
      added.dispatch(node);
    }
  }

  function remove(components:Components) {
    var i = this.components.indexOf(components.id);
    if (i > -1) {
      removed.dispatch(members[i]);
      members[i].dispose();
      members.splice(i, 1);
      this.components.splice(i, 1);
    }
  }

  function track(components:Components) {
    if (listeners.exists(components)) return;
    listeners.set(components, {
      added: components.added.add(component -> if (filter(components)) add(components)),
      removed: components.added.add(component -> if (!filter(components)) remove(components))
    });
  }

  function untrack(components:Components) {
    var listener = listeners.get(components);
    if (listener != null) {
      listener.dispose();
      remove(components);
    }
  }

  public function dispose() {
    // TODO - dispose of vars
    track_adds.dispose();
    track_removes.dispose();
  }

  public inline function iterator() return members.iterator();

  function toString() {
    return 'Nodes (members: ${members.toString()})';
  }
}
