package gxd.sys;

import g2d.Collisions;

using tink.CoreApi;

enum Event {
  BroadPhaseEvent(data:Pair<CollisionItem, CollisionItem>);
  CollisionEvent(data:Collision);
}
