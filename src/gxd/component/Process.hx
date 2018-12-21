package gxd.component;

import gxd.util.DataUtil;
import ecs.component.Component;

class Process extends Component {
  /**
   * Default Process Options.
   */
  public static var defaults(get, null):ProcessOptions;
  /**
   * The Task to be Processed.
   * This is a function with a `Float` parameter, so the time elapsed since the last update frame (dt) can be passed in.
   *
   * Example: process.task = (dt) -> trace('elapsed: $dt');
   */
  public var task:Null<Float->Void>;
  /**
   * Flag to set whether this Process will remain active between Processor loops.
   */
  public var loop:Bool;
  /**
   * Flag to set whether the Task will be processed in the current Processor loop.
   */
  public var active:Bool;

  public function new(task:Float->Void, ?options:ProcessOptions) {
    options = DataUtil.copy_fields(options, defaults);
    this.task = task;
    loop = options.loop;
    active = options.active;
  }

  static function get_defaults():ProcessOptions return {
    loop: false,
    active: true
  }
}

typedef ProcessOptions = {
  var ?loop:Bool;
  var ?active:Bool;
}
