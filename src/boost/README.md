# Main Classes

### Game
The main entry point for a boostlib-powered game. Simply pass in a `State` and some configurations and its ready to go!

### State
Use these to construct the different States of a `Game`. 
For example, a different `State` can be made for the Main Menu, the Game Loop, and the Game Over Screen.

### GameState
A `State` of the `Game` preconfigured with it's own Entity-Component-System (ECS) Engine and some default Systems to handle Rendering and Physics.

### GM
The Game Manager. Use this to access useful methods and properties like resetting the `Game`, changing the `State`, and setting the target FPS.

# Sections

* component  - ECS Components that drive boostlib.
* ext  - Static Classes used to extend existing types with new methods.
* h2d  - Useful classes to quickly create 2D games.
* h3d  - Useful classes to quickly create 3D games.
* system  - ECS Systems that drive boostlib.
* ui   - UI elements.
* util - Utility Classes.
