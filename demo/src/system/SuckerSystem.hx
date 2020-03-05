package system;

import ghost.util.Signal.SignalConnection;
import echo.Body;
import ghost.Game;
import ghost.Node;
import ghost.System;
import echo.Shape;
import component.Sucker;
import component.Suckable;
import component.Trash;

using ghost.ext.FloatExt;

class SuckerSystem extends System {
  @:nodes var suckers:Node<Sucker>;
  @:nodes var suckables:Node<Suckable>;
  @:nodes var trash:Node<Trash>;

  var sucker_bodies:Array<Body>;
  var trash_bodies:Array<Body>;
  var suckers_added:SignalConnection<Node<Sucker>->Void>;
  var suckers_removed:SignalConnection<Node<Sucker>->Void>;
  var trash_added:SignalConnection<Node<Trash>->Void>;
  var trash_removed:SignalConnection<Node<Trash>->Void>;

  override function added(game:Game) {
    super.added(game);

    // Keep track of all the sucker bodies and trash bodies
    sucker_bodies = [];
    trash_bodies = [];

    for (node in suckers) sucker_bodies.push(node.entity.body);
    for (node in trash) trash_bodies.push(node.entity.body);

    suckers_added = suckers.added.add(node -> sucker_bodies.push(node.entity.body));
    suckers_removed = suckers.removed.add(node -> sucker_bodies.remove(node.entity.body));

    trash_added = trash.added.add(node -> trash_bodies.push(node.entity.body));
    trash_removed = trash.removed.add(node -> trash_bodies.remove(node.entity.body));

    // Check if trash should be eaten
    game.world.listen(sucker_bodies, trash_bodies, {
      enter: (a, b, c) -> {
        var sucker = a.entity.components.get(Sucker);
        for (data in c) if (sucker.shape == data.sa || sucker.shape == data.sb) b.entity.kill();
      }
    });
  }

  override function removed() {
    super.removed();

    suckers_added.dispose();
    suckers_removed.dispose();
    trash_added.dispose();
    trash_removed.dispose();
  }

  override function step(dt) {
    var bounds = Shape.rect();
    for (n1 in suckers) {
      // if Sucker is active, pull in in-range suckables
      if (n1.sucker.active) {
        if (n1.sucker.facing) for (n2 in suckables) {
          n2.entity.body.bounds(bounds);
          if (bounds.right.within(n1.entity.x - n1.sucker.min_distance, n1.entity.x - n1.sucker.max_distance)
            && bounds.y.within(n1.entity.y - 24, n1.entity.y + 24)) n2.entity.body.acceleration.x += 20;
        }
        else for (n2 in suckables) {
          n2.entity.body.bounds(bounds);
          if (bounds.left.within(n1.entity.x + n1.sucker.min_distance, n1.entity.x + n1.sucker.max_distance)
            && bounds.y.within(n1.entity.y - 24, n1.entity.y + 24)) n2.entity.body.acceleration.x -= 20;
        }
      }
    }
    bounds.put();
  }
}
