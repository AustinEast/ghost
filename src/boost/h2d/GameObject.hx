package boost.h2d;

import h2d.Bitmap;
import h2d.Tile;
import hxd.res.Image;
import boost.ecs.component.h2d.Motion2D;
import boost.ecs.component.h2d.Transform2D;
import boost.ecs.component.h2d.Object2D;
import boost.ecs.component.h2d.Graphic2D;
import boost.util.Color;
import ecs.entity.Entity;

/**
 * GameObjects are Entities preconfigured with transform, physics, and graphic Components.
 * Useful as a starting place for creating 2D Entities for a GameState.
 */
class GameObject extends Entity {
    /**
     * The GameObject's x position.
     * alias for `transform.x`.
     */
    public var x(get, set):Float;
    /**
     * The GameObject's y position.
     * Alias for `transform.y`.
     */
    public var y(get, set):Float;
    /**
     * The GameObject's width.
     * Alias for `collider.width`.
     * 
     * Not Implemented!
     */
    public var width(null, null):Float;
    /**
     * The GameObject's height.
     * Alias for `collider.height`.
     * 
     * Not Implemented!
     */
    public var height(null, null):Float;
	/**
	 * The GameObject's Transform2D Component.
	 */
	public var transform:Transform2D;
    /**
	 * The GameObject's Motion2D Component.
	 */
	public var motion:Motion2D;
    /**
	 * The GameObject's Graphic2D Component.
	 */
    public var graphic:Graphic2D;
    /**
	 * The GameObject's Object2D Component.
	 */
    public var object:Object2D;
	/**
	 * Creates a new GameObject.
	 * @param x the x position of the GameObject.
	 * @param y the y position of the GameObject.
	 * @param name the name of the GameObject.
	 */
	public function new(x:Float = 0, y:Float = 0, ?name:String) {
		super(name);
        object = new Object2D();
		transform = new Transform2D({ x: x, y: y });
        motion = new Motion2D();
        graphic = new Graphic2D(new Bitmap(null, object.object));
		
        this.add(object);
        this.add(transform);
		this.add(motion);
        this.add(graphic);
	}

    public function add_child(game_object:GameObject) {
        object.object.addChild(game_object.object.object);
    }

    public function remove_child(game_object:GameObject) {
        object.object.removeChild(game_object.object.object);
    }

    // getters
    function get_x():Float return transform.x;
    function get_y():Float return transform.y;

    // setters
    function set_x(value:Float):Float return transform.x = value;
    function set_y(value:Float):Float return transform.y = value;
}