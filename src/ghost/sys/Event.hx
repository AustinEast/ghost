package ghost.sys;

import h2d.Collisions;

using tink.CoreApi;

enum Event {
  BroadPhaseEvent(data:Pair<CollisionItem, CollisionItem>);
  CollisionEvent(data:Collision);
}
