package ghost;

import ghost.entity.*;
import ghost.util.Group;
import ghost.util.Signal.SignalConnection;
import echo.Body;
import echo.util.Disposable;
import hxmath.math.Vector2;
import ogmo.Project.LayerTemplate;


using ghost.ext.Vector2Ext;

#if heaps
import h2d.Object;
#end

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

class LayerDisplay extends Object {
  public var scroll:Vector2 = new Vector2(1, 1);
  public var offset:Vector2 = new Vector2(0, 0);

  override function calcAbsPos() {
    super.calcAbsPos();

    if (!scroll.is_one()) {
      absX *= scroll.x;
      absY *= scroll.y;
    }

    if (!offset.is_zero()) {
      absX += offset.x;
      absY += offset.y;
    }
  }
}

class TypedLayer<T:Entity> implements IDisposable {
  public var name:String;
  public var active:Bool;
  public var game(default, null):Game;
  public var display(default, null):LayerDisplay;
  public var template(default, null):Null<LayerTemplate>;
  public var entities(default, null):Group<T>;
  public var bodies(default, null):Array<Body>;
  public var scroll(get, set):Vector2;
  public var offset(get, set):Vector2;
  public var visible(get, set):Bool;
  public var disposed(default, null):Bool;

  var add_entity_to_game:SignalConnection<T->Void>;
  var remove_entity_from_game:SignalConnection<T->Void>;
  var remove_entity:SignalConnection<Entity->Void>;

  public function new(name:String, game:Game, ?template:LayerTemplate) {
    this.name = name;
    this.template = template;
    active = true;
    display = new LayerDisplay();
    entities = new Group<T>();
    bodies = [];
    disposed = false;

    attach(game);
  }

  public function step(dt:Float) {
    for (e in entities) if (e.active && !e.disposed) e.step(dt);
  }

  public function add(entity:T):T {
    if (entity.layer != null) entity.remove();
    entity.layer = cast this;
    display.addChild(entity.display);
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
    game.camera.add(display);

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

    display.remove();
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
    display = null;
    entities = null;
  }

  inline function get_visible() return display.visible;

  inline function get_scroll() return display.scroll;

  inline function get_offset() return display.offset;

  inline function set_visible(value:Bool) return display.visible = value;

  inline function set_scroll(value:Vector2) return display.scroll = value;

  inline function set_offset(value:Vector2) return display.offset = value;

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
