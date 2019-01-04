package g2d.system;

import gxd.sys.Event;
import ecs.system.System;
/**
 * TODO: System to sort 2D entities display order.
 *
 * Planned sorting modes:
 * - Y Sort
 * - Z Sort (for entities with h2d.transform)
 * - X Sort (because why not?)
 */
class SortSystem extends System<Event> {}
