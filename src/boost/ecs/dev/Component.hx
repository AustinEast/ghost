
// import haxe.Json;
// import boost.util.DestroyUtil.IDestroyable;

// class Component implements IDestroyable {
//     @:allow(boost.ecs.Entity)
//     public var owner(default, null):Null<Entity>;
//     public var name(default, null):String;
//     public var type(default, null):ComponentType;
//     public var active:Bool;

//     public function new(name:String, type:ComponentType = MODEL) {
//         this.name = name;
//         this.type = type;
//     }

//     public function update(dt:Float) {

//     }
    
//     public function destroy() {

//     }

//     public function to_string():String {
//         return Json.stringify({
//             name: name
//         });
//     }

//     public function added() {}

//     public function removed() {}
// }

// @:enum
// abstract ComponentType(Int) {
//     var MODEL = 0;
//     var CORE = 1;
//     var PHYSICS = 2;
//     var ACTOR = 3;
//     var RENDER = 4;
// }