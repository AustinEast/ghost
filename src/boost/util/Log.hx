package boost.util;

import boost.util.DestroyUtil.IDestroyable;
import haxe.Json;

/**
 * Logging Utilities
 */
class Log implements IDestroyable {

    var _all:Array<String>;
    var _info:Array<String>;
    var _warn:Array<String>;
    var _error:Array<String>;

    /**
     * Flag to set whether or not Logs are suppressed.
     * If suppressed, Logs will not be `trace`d or stored by the Logger
     */
    public var suppress:Bool;
    /**
     * Flag to set whether or not Logs are quiet.
     * If quiet, Logs will not be `trace`d, but they will be stored by the Logger
     */
    public var quiet:Bool;
    /**
     * Creates new Log instance
     */
    public function new() {
        _all = new Array<String>();
        _info = new Array<String>();
        _warn = new Array<String>();
        _error = new Array<String>();
        suppress = false;
        quiet = false;
    }
    /**
     * Destroys Log instance
     */
    public function destroy() {
        while (_all.length > 0) _all.pop();
        while (_info.length > 0) _info.pop();
        while (_warn.length > 0) _warn.pop();
        while (_error.length > 0) _error.pop();
    }
    /**
     * Log an Informational Message
     * @param message the string to log
     */
    public function info(message: String) log(message, INFO);
    /**
     * Log a Warning Message
     * @param message the string to log
     */
    public function warn(message: String) log(message, WARNING);
    /**
     * Log an Error Message
     * @param message the string to log
     */
    public function error(message: String) log(message, ERROR);
    /**
     * Log a Message
     * @param message the string to log
     * @param type the severity of the message
     */
    public inline function log(message: String, type: LogType) {
        if (suppress) return;
        message = '$type: $message';
        if (!quiet) trace(message);
        // Store the message
        _all.push(message);
        switch (type) {
            case INFO: _info.push(message);
            case WARNING: _warn.push(message);
            case ERROR: _error.push(message);
        }
    }
    /**
     * Get a list of log messages
     * @param type the severity of the message. If null, it will retrieve all logs
     * @return Array<String>
     */
    public function get(?type:LogType):Array<String> {
        if (type == null) return _all;
        switch (type) {
            case INFO: return _info;
            case WARNING: return _warn;
            case ERROR: return _error;
        }
    }
    /**
     * Helper function to quickly stringify a JSON object
     * @param value JSON object to stringify
     * @return String
     */
    public inline function from_json(value:Dynamic):String {
        return Json.stringify(value, null, "  ");
    }
}

@:enum 
abstract LogType (String) {
    var INFO    = "INFO";
    var WARNING = "WARN";
    var ERROR   = "ERROR";
}