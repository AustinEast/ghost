package ghost;

import ghost.Layer;
import ghost.entity.*;
import ghost.util.Group;
import ghost.util.Color;
import ogmo.Level.LayerDefinition;
import ogmo.Project.LayerTemplate;
import echo.util.Disposable;

using hxmath.math.MathUtil;
using Std;
/**
 * TODO - reload data when it gets updated
 */
class Level implements IDisposable {
  public var game(default, null):Game;
  public var data(default, null):ogmo.Level;
  public var entities(default, null):Group<Entity>;
  public var loaded(default, null):Bool;

  public function new(data:String, game:Game, load:Bool = true, default_loaders:Bool = true) {
    this.game = game;
    this.data = ogmo.Level.create(data);
    this.data.layers.reverse();
    loaded = false;
    entities = new Group();

    if (default_loaders) set_default_loaders();
    if (load) load_layers();

    // game.entities.removed.add(remove_entity);
  }

  public function set_default_loaders() {
    data.onTileLayerLoaded = (tile_data, layer_definition) -> {
      var layer = get_tilemap_layer(layer_definition);
      var tilemap = new TileMap();

      layer.add(tilemap);
      entities.add(tilemap);

      if (game.project != null) {
        var tileset = game.project.getTilesetTemplate(layer_definition.tileset);
        if (tileset != null) {
          tilemap.load_from_array(tile_data, layer_definition.gridCellsX, layer_definition.gridCellsY, {
            tile_width: tileset.tileWidth,
            tile_height: tileset.tileHeight,
            asset: tileset.path
          });
        }
      }
    }

    data.onTile2DLayerLoaded = (tile_data, layer_definition) -> {
      var layer = get_tilemap_layer(layer_definition);
      var tilemap = Type.createInstance(game.tilemap_class, []);

      layer.add(tilemap);
      entities.add(tilemap);

      if (game.project != null) {
        var tileset = game.project.getTilesetTemplate(layer_definition.tileset);
        if (tileset != null) {
          tilemap.load_from_2d_array(tile_data, {
            tile_width: tileset.tileWidth,
            tile_height: tileset.tileHeight,
            asset: tileset.path
          });
        }
      }
    }

    data.onGridLayerLoaded = (grid_data, layer_definition) -> {
      var layer = get_grid_layer(layer_definition);
      var grid = Type.createInstance(game.grid_class, []);

      layer.add(grid);
      entities.add(grid);

      if (game.project != null) {
        var layer_template = game.project.getLayerTemplate(layer_definition.exportID);
        if (layer_template != null && layer_template.legend != null) {
          for (key => value in layer_template.legend) {
            grid.legend.set(key, Color.fromString(value, true));
          }
        }
      }
      grid.load_from_array(grid_data, layer_definition.gridCellsX, layer_definition.gridCellsY, layer_definition.gridCellWidth,
        layer_definition.gridCellHeight);
    }

    data.onGrid2DLayerLoaded = (grid_data, layer_definition) -> {
      var layer = get_grid_layer(layer_definition);
      var grid = Type.createInstance(game.grid_class, []);

      layer.add(grid);
      entities.add(grid);

      if (game.project != null) {
        var layer_template = game.project.getLayerTemplate(layer_definition.exportID);
        if (layer_template != null && layer_template.legend != null) {
          for (key => value in layer_template.legend) {
            grid.legend.set(key, Color.fromString(value, true));
          }
        }
      }
      grid.load_from_2d_array(grid_data, layer_definition.gridCellWidth, layer_definition.gridCellHeight);
    }

    data.onEntityLayerLoaded = (entities, layer_definition) -> {
      var layer = get_layer(layer_definition);

      for (entity in entities) {
        // Check if Entity name matches class in `entity` package. otherwise just make entity with colored square;
        var type = Type.resolveClass('entity.${entity.name.split(' ').join('')}');
        if (type != null) {
          var e:Entity = cast Type.createInstance(type, []);
          layer.add(e);
          this.entities.add(e);
          e.load_options({
            x: entity.x,
            y: entity.y,
            rotation: entity.rotation != null ? entity.rotation : 0,
            name: entity.name
          });
          e.load_values(entity.values);
          if (e.is(Sprite)) {
            var s:Sprite = cast e;
            s.renderer.flip_x = entity.flippedX != null ? entity.flippedX : false;
            s.renderer.flip_y = entity.flippedY != null ? entity.flippedY : false;
          }
        }
        else {
          var e = Type.createInstance(game.sprite_class, [
            {
              x: entity.x,
              y: entity.y,
              rotation: entity.rotation != null ? entity.rotation : 0,
              name: entity.name,
              renderer: {
                flip_x: entity.flippedX != null ? entity.flippedX : false,
                flip_y: entity.flippedY != null ? entity.flippedY : false
              }
            }
          ]);
          layer.add(e);
          this.entities.add(e);

          if (game.project != null) {
            var template = game.project.getEntityTemplate(entity.exportID);
            if (template != null) {
              if (template.texture != null) {
                e.renderer.load(template.texture);
                if (entity.height != null) {
                  e.renderer.scale_y = entity.height / template.size.y;
                }
              }
              else {
                var color = Color.fromString(template.color, true);
                e.renderer.make(entity.width == null ? template.size.x.int() : entity.width.int(),
                  entity.height == null ? template.size.y.int() : entity.height.int(), color, color.alphaFloat);
              }
              e.set_collider_from_graphic();
            }
          }
        }
      }
    }

    data.onDecalLayerLoaded = (decals, layer_definition) -> {
      var layer = get_layer(layer_definition);

      for (decal in decals) {
        var d = Type.createInstance(game.sprite_class, [
          {
            x: decal.x,
            y: decal.y,
            rotation: decal.rotation != null ? decal.rotation.radToDeg() : 0,
            renderer: {
              asset: layer_definition.folder + '/' + decal.texture,
              scale_x: decal.scaleX != null ? decal.scaleX : 0,
              scale_y: decal.scaleY != null ? decal.scaleY : 0,
            }
          }
        ]);
        d.renderer.center_offset();
        layer.add(d);
        entities.add(d);

        // TODO - do something with decal layer values
      }
    }
  }

  public function clear_loaders() {
    data.onDecalLayerLoaded = null;
    data.onEntityLayerLoaded = null;
    data.onGridLayerLoaded = null;
    data.onGrid2DLayerLoaded = null;
    data.onTileLayerLoaded = null;
    data.onTile2DLayerLoaded = null;
    data.onTileCoordsLayerLoaded = null;
    data.onTileCoords2DLayerLoaded = null;
  }

  public inline function get(name:String):Null<Entity> {
    for (entity in entities) if (entity != null && entity.name == name) return entity;
    return null;
  }

  public inline function get_all(name:String):Array<Entity> {
    var arr:Array<Entity> = [];
    for (entity in entities) if (entity != null && entity.name == name) arr.push(entity);
    return arr;
  }

  public function load_layers() {
    // if (closed) return;
    if (loaded) unload();
    data.load();
    loaded = true;
  }

  public function unload() {
    loaded = false;
    for (entity in entities) {
      entity.remove();
    }
  }

  public function close() {
    dispose();
  }

  public function dispose() {
    unload();
    clear_loaders();
    game = null;
    data = null;
  }
  /**
   * Get (or create) a layer from a `LayerDefinition`.
   */
  inline function get_layer(layer_definition:LayerDefinition):Layer {
    var layer = game.get_layer(layer_definition.name);
    if (layer == null) {
      var template:LayerTemplate = null;
      if (game.project != null) template = game.project.getLayerTemplate(layer_definition.exportID);
      layer = new Layer(layer_definition.name, game, template);
    }
    return layer;
  }
  /**
   * Get (or create) a Decal layer from a `LayerDefinition`.
   */
  inline function get_decal_layer(layer_definition:LayerDefinition):Null<DecalLayer> {
    var layer = game.get_decal_layer(layer_definition.name);
    if (layer == null) {
      var template:LayerTemplate = null;
      if (game.project != null) template = game.project.getLayerTemplate(layer_definition.exportID);
      layer = cast new TypedLayer<Sprite>(layer_definition.name, game, template);
    }
    return layer;
  }
  /**
   * Get (or create) a Grid layer from a `LayerDefinition`.
   */
  inline function get_grid_layer(layer_definition:LayerDefinition):Null<GridLayer> {
    var layer = game.get_grid_layer(layer_definition.name);
    if (layer == null) {
      var template:LayerTemplate = null;
      if (game.project != null) template = game.project.getLayerTemplate(layer_definition.exportID);
      layer = cast new TypedLayer<Grid>(layer_definition.name, game, template);
    }
    return layer;
  }
  /**
   * Get (or create) a TileMap layer from a `LayerDefinition`.
   */
  inline function get_tilemap_layer(layer_definition:LayerDefinition):Null<TileLayer> {
    var layer = game.get_tile_layer(layer_definition.name);
    if (layer == null) {
      var template:LayerTemplate = null;
      if (game.project != null) template = game.project.getLayerTemplate(layer_definition.exportID);
      layer = cast new TypedLayer<TileMap>(layer_definition.name, game, template);
    }
    return layer;
  }

  function remove_entity(entity:Entity) {
    entities.remove(entity);
  }
}
