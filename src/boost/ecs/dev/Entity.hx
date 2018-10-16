
// import haxe.Json;
// import boost.system.Log;
// import boost.util.DestroyUtil.IDestroyable;

// class Entity implements IDestroyable {

//     public var id(default, null):Int;
//     public var name(default, null):String;
//     public var components(default, null): Map<String, Component>;
//     public var parent(default, null): Null<Entity>;
//     public var children(default, null): Array<Entity>;
//     public var active:Bool;

//     public function new(name:String) {
//         this.name = name;
//         // id = GM.new_id();
//         active = true;
//         components = new Map();
//         children = new Array();
//     }

//     public function destroy() {
        
//     }

//     public function add_component(component:Component):Entity {
//         components.exists(component.name) ? Log.warn('Component ${component.name} already added to Entity $name.') : components.set(component.name, component);
//         component.owner = this;
//         component.added();
//         return this;
//     }

//     public function remove_component(component:Component):Bool {
//         if (components.exists(component.name)) {
//             components.remove(component.name);
//             component.owner = null;
//             component.removed();
//             return true;
//         }
//         Log.warn('Component ${component.name} does not exist on Entity $name.');
//         return false;
//     }

//     public function add_child(child:Entity):Entity {
//         children.push(child);
//         child.parent = this;
//         return this;
//     }

//     public function remove_child(child:Entity):Bool {
//         return children.remove(child);
//     }
    

//     public function to_string():String {
//         return boost.system.Log.from_json({
//             id: id,
//             name: name,
//             components: components.toString(),
//             parent: (parent == null) ? 'null' : parent.name,
//             children: children.map((child) -> Json.parse(child.to_string()))
//         });
//     }
// }