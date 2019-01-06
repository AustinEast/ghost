# TODO

* Figure out engine update FPS vs render FPS
* 2D Camera Entity
* Figure out better system of grouping (parent/childing) Entities (maybe a "Group" component?)
* Collision system
* TileMap
* Debug menu
* implement haxe-concurrency? (optionally of course)
* Redo Game.hx to not extend App, add more ECS integration
* Add more Samples:
    * Scene made the "haxeflixel" way vs "ECS" way
    * horizontal shooter
    * platformer

## Future Plans

### Macro Powered GameObjects
A GameObject will be an Entity with a couple of enhancements:
* Has `create()`, `update()`, and `dispose()` methods
* Has a macro-powered constructor that lets the user add and configure any component tagged with the right metadata
```
// Creates a GameObject with Transform, Group, and Physics Components that to collect 
var group = GM.physics.group();
add(group);
for (i in 0...100) {
    // Create a GameObject with some components.
    
    var go = new GameObject({
         transform3d: { x: 40, y: 30, z: 10 }, 
         collider2d: { shape:CIRCLE, radius: 16 }, 
         motion: true,
         graphic: { asset: "img.png", animated: true, width: 8, height: 8 
         }});
    group.add(go);
}
```
