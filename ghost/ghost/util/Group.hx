package ghost.util;

import ghost.util.Signal;

@:generic
class Group<T> {
  public var added:Signal<T>;
  public var removed:Signal<T>;
  /**
   * The actual Array holding the Group's members. It's not recommended to add/remove members directly (unless you know what you're doing).
   */
  public var members:Array<T>;

  public function new() {
    members = [];
    added = new Signal<T>();
    removed = new Signal<T>();
  }

  public function add(member:T):T {
    if (member == null) {
      Log.warn('Cannot add null member to Group');
      return null;
    }

    // Dont add if its already in the group
    if (members.indexOf(member) >= 0) return member;

    // Add the member
    members[first_null()] = member;
    added.dispatch(member);

    return member;
  }

  public function remove(member:T):Bool {
    if (member == null) return false;

    if (members.remove(member)) {
      removed.dispatch(member);
      return true;
    }

    return false;
  }
  /**
   * Gets the first member that has the matches the filter.
   * @param filter The filter to test the members against.
   * @return The first member that matches the filter, if any.
   */
  public function get(filter:T->Bool):Null<T> {
    for (member in members) if (member != null && filter(member)) return member;
    return null;
  }
  /**
   * Gets all members that match the filter.
   * @param name The filter to test the members against.
   * @return All members that match the filter. If none are found, the array will return empty.
   */
  public function get_all(filter:T->Bool):Array<T> return members.filter(member -> member != null && filter(member));

  public inline function has(member:T):Bool return members.indexOf(member) >= 0;

  public inline function clear() members.resize(0);

  public function for_each(action:T->Void) for (member in members) if (member != null) action(member);
  /**
   * Gets the first index set to `null`.
   * Returns an index equal to `members.length` if no nulls are found.
   *
   * @return  An `Int` indicating the first `null` slot in the group.
   */
  public function first_null():Int {
    var i:Int = 0;

    while (i < members.length) {
      if (members[i] == null) return i;
      i++;
    }

    return members.length;
  }

  public inline function iterator() return members.iterator();
}
