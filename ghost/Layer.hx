package ghost;

import ghost.entity.*;
import ghost.util.Group;
import ghost.util.Signal.Listener;
import echo.Body;
import echo.util.Disposable;
import hxmath.math.Vector2;
import ogmo.Project.LayerTemplate;

class TypedLayer<T:Entity> implements IDisposable {
  public var name:String;
  public var active:Bool;
  public var game(default, null):Game;
  public var template(default, null):Null<LayerTemplate>;
  public var entities(default, null):Group<T>;
  public var bodies(default, null):Array<Body>;
  public var scroll(default, null):Vector2;
  public var offset(default, null):Vector2;
  public var disposed(default, null):Bool;

  var add_entity_to_game:Listener<T->Void>;
  var remove_entity_from_game:Listener<T->Void>;
  var remove_entity:Listener<Entity->Void>;

  public function new(name:String, game:Game, ?template:LayerTemplate) {
    this.name = name;
    this.template = template;
    active = true;
    entities = new Group<T>();
    bodies = [];
    scroll = new Vector2(0, 0);
    offset = new Vector2(0, 0);
    disposed = false;

    attach(game);
  }

  public function step(dt:Float) {
    for (e in entities) if (e.active && !e.disposed) e.step(dt);
  }

  public function add(entity:T):T {
    if (entity.layer != null) entity.remove();
    entity.layer = cast this;
    entities.add(entity);
    if (entity.body != null) {
      game.world.add(entity.body);
      bodies.push(entity.body);
    }
    entity.on_add(cast this);
    return entity;
  }

  public function remove(entity:T):T {
    if (entities.remove(entity)) entity.remove();
    return entity;
  }
  /**
   * Gets the first `Entity` that has the requested name.
   * @param name The `String` to test against.
   * @return The first found `Entity`, if any.
   */
  public inline function get(name:String):Null<T> {
    for (entity in entities) if (entity.name == name) return cast entity;
    return null;
  }
  /**
   * Gets all `Entity`s that have the requested name.
   * @param name The `String` to test against.
   * @return The all found `Entity`. If none are found, the array will return empty.
   */
  public inline function get_all(name:String):Array<T> {
    var arr:Array<T> = [];
    for (entity in entities) if (entity.name == name) arr.push(cast entity);
    return arr;
  }

  public inline function clear() {
    while (entities.members.length > 0) {
      var e = entities.members[0];
      entities.remove(e);
      e.remove();
    }
  }

  public function attach(game:Game) {
    detach();
    this.game = game;
    game.layers.add(cast this);

    add_entity_to_game = entities.added.add((entity) -> {
      game.entities.add(entity);
      return;
    });
    remove_entity_from_game = entities.removed.add((entity) -> {
      game.entities.remove(entity);
      return;
    });
    remove_entity = game.entities.removed.add((entity) -> {
      entities.remove(cast entity);
    });
  }

  public function detach() {
    if (game == null) return;

    game.layers.remove(cast this);
    add_entity_to_game.dispose();
    remove_entity_from_game.dispose();
    remove_entity.dispose();
    game = null;
  }

  public function dispose() {
    disposed = true;
    detach();
    clear();
    game = null;
    template = null;
    entities = null;
    scroll = null;
    offset = null;
  }

  // function add_entity_to_game(entity:T) {
  //   if (game != null) game.entities.add(entity);
  // }
  // function remove_entity_from_game(entity:T) {
  //   if (game != null) game.entities.remove(entity);
  // }

  function toString() {
    var c = Type.getClassName(Type.getClass(this));
    return name + "(" + c + ")";
  }
}

// class Layer extends TypedLayer<Entity> {}
// class DecalLayer extends TypedLayer<Sprite> {}
// class GridLayer extends TypedLayer<Grid> {}
// class TileLayer extends TypedLayer<TileMap> {}

@:forward
abstract Layer(TypedLayer<Entity>) from TypedLayer<Entity> to TypedLayer<Entity> {
  public function new(name:String, game:Game, ?template:LayerTemplate) this = new TypedLayer<Entity>(name, game, template);
}

@:forward
abstract DecalLayer(TypedLayer<Sprite>) from TypedLayer<Sprite> to TypedLayer<Sprite> {
  public function new(name:String, game:Game, ?template:LayerTemplate) this = new TypedLayer<Sprite>(name, game, template);
}

@:forward
abstract GridLayer(TypedLayer<Grid>) from TypedLayer<Grid> to TypedLayer<Grid> {
  public function new(name:String, game:Game, ?template:LayerTemplate) this = new TypedLayer<Grid>(name, game, template);
}

@:forward
abstract TileLayer(TypedLayer<TileMap>) from TypedLayer<TileMap> to TypedLayer<TileMap> {
  public function new(name:String, game:Game, ?template:LayerTemplate) this = new TypedLayer<TileMap>(name, game, template);
}
