package boost.sys;

import boost.h2d.system.BroadPhaseSystem;
import boost.h2d.Collisions;

enum Event {
  BroadPhaseEvent(data:Array<BroadPhasePair>);
  CollisionEvent(data:CollisionData);
}
