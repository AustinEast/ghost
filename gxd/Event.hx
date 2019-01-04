package gxd;

import echo.Collisions;
import g2d.component.*;

using tink.CoreApi;

enum Event {
  BroadPhaseEvent(data:Pair<CollisionItem, CollisionItem>);
  CollisionEvent(data:Collision);
}

typedef Collision = {
  var item1:CollisionItem;
  var item2:CollisionItem;
  var data:CollisionData;
}

typedef CollisionItem = {
  var id:Int;
  var collider:Collider;
  var transform:Transform;
  var ?motion:Motion;
}
