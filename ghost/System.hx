package ghost;

import ghost.Layer.TypedLayer;
import ghost.util.Signal.Listener;

@:autoBuild(ghost.util.Macros.build_system())
class System {
  var game:Game;
  var layer_added_listener:Listener<TypedLayer<Entity>->Void>;
  var layer_removed_listener:Listener<TypedLayer<Entity>->Void>;

  public function new() {}

  public function step(dt:Float) {}

  public function added(game:Game) {
    this.game = game;
    for (layer in game.layers) layer_added(layer);
    if (layer_added_listener != null) layer_added_listener.dispose();
    if (layer_removed_listener != null) layer_removed_listener.dispose();
    layer_added_listener = game.layers.added.add(layer_added);
    layer_removed_listener = game.layers.removed.add(layer_removed);
    add_nodes();
  }

  public function removed() {
    if (layer_added_listener != null) layer_added_listener.dispose();
    if (layer_removed_listener != null) layer_removed_listener.dispose();
    layer_added_listener = null;
    layer_removed_listener = null;
    game = null;
    remove_nodes();
  }

  function add_nodes() {}

  function remove_nodes() {}

  function layer_added(layer:TypedLayer<Entity>) {}

  function layer_removed(layer:TypedLayer<Entity>) {}
}
