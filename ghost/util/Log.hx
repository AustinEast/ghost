package ghost.util;

import echo.util.Disposable;
import haxe.Json;
/**
 * Logging Utilities
 */
class Log {
  /**
   * Flag to set whether or not Logs are suppressed.
   * If suppressed, Logs will not `trace` or be stored by the Logger
   */
  public static var suppress:Bool = false;
  /**
   * Flag to set whether or not Logs are quiet.
   * If quiet, Logs will not `trace`, but they will be stored by the Logger
   */
  public static var quiet:Bool = false;

  static var _all:Array<String> = [];
  static var _info:Array<String> = [];
  static var _warn:Array<String> = [];
  static var _error:Array<String> = [];
  /**
   * Log an Informational Message
   * @param message the string to log
   */
  public static inline function info(message:String) log(message, INFO);
  /**
   * Log a Warning Message
   * @param message the string to log
   */
  public static inline function warn(message:String) log(message, WARNING);
  /**
   * Log an Error Message
   * @param message the string to log
   */
  public static inline function error(message:String) log(message, ERROR);
  /**
   * Log a Message
   * @param message the string to log
   * @param type the severity of the message
   */
  public static inline function log(message:String, type:LogType) {
    if (suppress) return;
    message = '$type: $message';
    if (!quiet) trace(message);
    // Store the message
    _all.push(message);
    switch (type) {
      case INFO:
        _info.push(message);
      case WARNING:
        _warn.push(message);
      case ERROR:
        _error.push(message);
    }
  }
  /**
   * Get a list of log messages
   * @param type the severity of the message. If null, it will retrieve all logs
   * @return Array<String>
   */
  public static inline function get(?type:LogType):Array<String> {
    if (type == null) return _all;
    switch (type) {
      case INFO:
        return _info;
      case WARNING:
        return _warn;
      case ERROR:
        return _error;
    }
  }
  /**
   * Helper function to quickly stringify a JSON object
   * @param value JSON object to stringify
   * @return String
   */
  public static inline function from_json(value:Dynamic):String {
    return Json.stringify(value, null, "  ");
  }
  /**
   * Clears all stored Logs
   */
  public static inline function clear() {
    while (_all.length > 0) _all.pop();
    while (_info.length > 0) _info.pop();
    while (_warn.length > 0) _warn.pop();
    while (_error.length > 0) _error.pop();
  }
  /**
   * Convenience method to add a breakpoint in js builds.
   */
  public static inline function breakpoint():Void {
    #if js
    js.Lib.debug();
    #end
  }
}

@:enum
abstract LogType(String) {
  var INFO = "INFO";
  var WARNING = "WARN";
  var ERROR = "ERROR";
}
