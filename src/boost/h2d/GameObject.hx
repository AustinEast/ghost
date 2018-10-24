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
     * alias for `transform.position.x`.
     */
    public var x(get, set):Float;
    /**
     * The GameObject's y position.
     * Alias for `transform.position.y`.
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
		transform = new Transform2D({ position: { x: x, y: y } });
        motion = new Motion2D();
        graphic = new Graphic2D(new Bitmap(null, object.object));
        graphic.visible = false;
		
        this.add(object);
        this.add(transform);
		this.add(motion);
        this.add(graphic);
	}
    /**
     * Loads an Image asset to be displayed by this GameObject.
     * @param asset The Image asset to load.
     * @param sprite_sheet Flag the set whether the Image is a Sprite Sheet.
     * @param width Width of the Sprite. This only needs to be set if the Image is a Sprite Sheet.
     * @param height Height of the Sprite. This only needs to be set if the Image is a Sprite Sheet.
     */
    public function load_graphic(asset:Image, sprite_sheet:Bool = false, width:Int = 0, height:Int = 0) {
		graphic.visible = true;
        graphic.load(asset, sprite_sheet, width, height);
    }
    /**
     * Creates a Colored Rectangle to be displayed by this GameObject.
     * @param width Width of the Sprite.
     * @param height Height of the Sprite.
     * @param color Color of the Sprite.
     * @param alpha Alpha of the Sprite.
     */
    public function make_graphic(width:Int = 16, height:Int = 16, color:Int = Color.WHITE, alpha:Float = 1) {
        graphic.visible = true;
        graphic.make(width, height, color, alpha);
    }

    public function add_child(game_object:GameObject) {
        object.object.addChild(game_object.object.object);
    }

    public function remove_child(game_object:GameObject) {
        object.object.removeChild(game_object.object.object);
    }

    // getters
    function get_x():Float return transform.position.x;
    function get_y():Float return transform.position.y;

    // setters
    function set_x(value:Float):Float return transform.position.x = value;
    function set_y(value:Float):Float return transform.position.y = value;
}