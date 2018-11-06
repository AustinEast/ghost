package boost.h2d;

import boost.component.h2d.Motion;
import boost.component.h2d.Transform;
import boost.component.h2d.Animator;
import boost.component.h2d.Graphic;
import boost.component.Process;
import ecs.entity.Entity;

/**
 * GameObjects are Entities preconfigured with transform, physics, and graphic Components.
 * Useful as a starting place for creating  Entities for a GameState.
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
     * The GameObject's update function.
     * Alias for `process.task`.
     * 
     * Useful for running logic on a GameObject every update frame without needing to create a new `System`.
     */
    public var update(get, set):Float->Void;
	/**
	 * The GameObject's kill function.
     * Hides this GameObject's graphic and stops it's update function.
     * 
     * Note that by default this doesn't destroy the GameObject or stop this GameObject's other `Component`s from interacting with `System`s.
	 */
    public var kill:Void->Void;
    /**
	 * The GameObject's revive function.
     * Shows this GameObject's graphic and activates it's update function.
	 */
    public var revive:Void->Void;
	/**
	 * The GameObject's Transform Component.
	 */
	public var transform:Transform;
    /**
	 * The GameObject's Motion Component.
	 */
	public var motion:Motion;
    /**
	 * The GameObject's Graphic Component.
	 */
    public var graphic:Graphic;
    /**
	 * The GameObject's Animator Component.
	 */
    public var animator:Animator;
    /**
	 * The GameObject's Process Component.
     * Drives the `update` function.
	 */
    public var process:Process;
	/**
	 * Creates a new GameObject.
	 * @param x The x position of the GameObject.
	 * @param y The y position of the GameObject.
     * @param update The update function of the GameObject.
	 * @param name The name of the GameObject.
	 */
	public function new(x:Float = 0, y:Float = 0, ?update:Float->Void, ?name:String) {
		super(name);
		transform = new Transform({ x: x, y: y });
        motion = new Motion();
        graphic = new Graphic();
        animator = new Animator();
        process = new Process(update, { loop: true });
		
        this.add(transform);
		this.add(motion);
        this.add(graphic);
        this.add(animator);
        this.add(process);

        this.kill = () -> {
            graphic.visible = false;
            process.active = false;
        }

        this.revive = () -> {
            graphic.visible = true;
            process.active = true;
        }
	}

    // getters
    function get_x():Float return transform.x;
    function get_y():Float return transform.y;
    function get_update():Float->Void return process.task;

    // setters
    function set_x(value:Float):Float return transform.x = value;
    function set_y(value:Float):Float return transform.y = value;
    function set_update(value:Float->Void):Float->Void return process.task = value;
}
