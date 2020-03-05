import ghost.Entity;
import ghost.Layer;
import ghost.Game;
import component.Trash;
import component.Suckable;
import entity.Player;
import system.SuckerSystem;
import hxmath.math.Vector2;
import echo.Body;
#if heaps
import hxd.Key;
#end

using ghost.ext.ObjectExt;

class Boot {
  static function main() {
    var cam_speed = 50;
    var player:Entity;

    // Define our Game's Start method
    var start = (game:Game) -> {
      // Load the Ogmo project
      game.load_project(hxd.Res.project.entry.getText());
      // Load the first level
      var level = game.load_level(hxd.Res.levels.garage.entry.getText());

      // game.camera.pixel_perfect();

      // Set the camera bounds
      game.camera.min = new Vector2(level.data.offsetX, level.data.offsetY);
      game.camera.max = new Vector2(level.data.offsetX + level.data.width, level.data.offsetY + level.data.height);

      // Get the Grid Layer we're using for Collision
      var collision_layer = game.get_grid_layer('collision');
      if (collision_layer != null) collision_layer.entities.for_each(grid -> {
        grid.generate_collider(OPTIMIZED);
        grid.graphic.visible = false;
      });

      // Get the Player Entity
      player = game.get_entity("Player");
      if (player != null) game.camera.target = player;

      // Get all the Box Entities and set them up
      for (entity in game.get_all_entities('Box')) {
        entity.body.drag.x = 100;
        entity.components.add(new Suckable());
      }

      // Get all the Big Box Entities and set them up
      for (entity in game.get_all_entities('Big Box')) {
        entity.body.mass = 5;
        entity.body.drag.x = 100;
        entity.components.add(new Suckable());
      }

      // Get all the Trash Entities and set them up
      for (entity in game.get_all_entities('Trash')) {
        entity.body.drag.x = 100;
        entity.body.clear_shapes();
        entity.body.create_shape({
          type: CIRCLE,
          radius: 5,
          offset_x: 5,
          offset_y: 5
        });
        entity.components.add(new Suckable());
        entity.components.add(new Trash());
      }

      // Get all the One Way Platform Entities and set them up
      for (entity in game.get_all_entities('One Way')) {
        entity.body.mass = 0;
      }

      // TODO - add suckable dust particles, maybe darkness mask until lights are turned on? look at for ref: (get twitter vid from likes lmao)

      game.world.gravity.set(0, 180);
      game.world.listen();

      game.add_system(new SuckerSystem());
    }

    // Define our Game's Main update loop
    var step = (game:Game, dt:Float) -> {
      // if (player == null) return;

      // if (Key.isDown(Key.LEFT)) {
      //   player.body.velocity.x -= cam_speed * dt;
      //   player.renderer.flip_x = true;
      // }
      // if (Key.isDown(Key.RIGHT)) {
      //   player.body.velocity.x += cam_speed * dt;
      //   player.renderer.flip_x = false;
      // }
      // if (Key.isPressed(Key.UP)) player.body.velocity.y = -cam_speed;
      // if (Key.isDown(Key.DOWN)) game.camera.viewY += cam_speed * dt;
    }

    // Create the Game
    new Game({
      filesystem: LOCAL,
      width: 320,
      height: 180,
      start: start,
      step: step
    });
  }
}
