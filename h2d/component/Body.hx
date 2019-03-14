package h2d.component;

import hxmath.math.Vector2;
import ghost.Proxy.IProxy;
import ghost.EntityBase;
import echo.data.Options.BodyOptions;

class Body extends Component implements IProxy {
  /**
   * The Body's position on the X axis.
   */
  @:alias(body.x)
  public var x:Float;
  /**
   * The Body's position on the Y axis.
   */
  @:alias(body.y)
  public var y:Float;
  /**
   * The Body's optional `Shape`. If it **isn't** null, this `Shape` acts as the Body's Collider, allowing it to be checked for Collisions.
   */
  @:alias(body.shape)
  public var shape:Null<echo.Shape>;
  /**
   * Flag to set whether the Body collides with other Bodies.
   *
   * If false, this Body will not have its position or velocity affected by other Bodies, but it will still call collision callbacks
   */
  @:alias(body.solid)
  public var solid:Bool;
  /**
   * Body's mass. Affects how the Body reacts to Collisions and Velocity.
   *
   * The higher a Body's mass, the more resistant it is to those forces.
   * If a Body's mass is set to `0`, it becomes static - unmovable by forces and collisions.
   */
  @:alias(body.mass)
  public var mass:Float;
  /**
   * Body's position on the X and Y axis.
   */
  @:alias(body.position)
  public var position(get, null):Vector2;
  /**
   * Body's current rotational angle. Currently is not implemented.
   */
  @:alias(body.rotation)
  public var rotation:Float;
  /**
   * Value to determine how much of a Body's `velocity` should be retained during collisions (or how much should the `Body` "bounce" in other words).
   */
  @:alias(body.elasticity)
  public var elasticity:Float;
  /**
   * The units/second that a `Body` moves.
   */
  @:alias(body.velocity)
  public var velocity:Vector2;
  /**
   * A measure of how fast a `Body` will change it's velocity. Can be thought of the sum of all external forces on an object (such as a World's gravity) during a step.
   */
  @:alias(body.acceleration)
  public var acceleration:Vector2;
  /**
   * The units/second that a `Body` will rotate. Currently is not Implemented.
   */
  @:alias(body.rotational_velocity)
  public var rotational_velocity:Float;
  /**
   * The maximum velocity range that a `Body` can have.
   *
   * If set to 0, the Body has no restrictions on how fast it can move.
   */
  @:alias(body.max_velocity)
  public var max_velocity:Vector2;
  /**
   * The maximum rotational velocity range that a `Body` can have. Currently not Implemented.
   *
   * If set to 0, the Body has no restrictions on how fast it can rotate.
   */
  @:alias(body.max_rotational_velocity)
  public var max_rotational_velocity:Float;
  /**
   * A measure of how fast a Body will move its velocity towards 0 when there is no acceleration.
   */
  @:alias(body.drag)
  public var drag:Vector2;
  /**
   * Percentage value that represents how much a World's gravity affects the Body.
   */
  @:alias(body.gravity_scale)
  public var gravity_scale:Float;
  /**
   * Flag to set if the Body is active and will participate in a World's Physics calculations or Collision querys.
   */
  @:alias(body.active)
  public var active:Bool;
  /**
   * Dynamic Object to store any user data on the `Body`. Useful for Callbacks.
   */
  @:alias(body.data)
  public var data:Dynamic;
  public var body:echo.Body;

  public function new(?body_options:BodyOptions) {
    super('body');
    body = new echo.Body(body_options);
  }

  override function post_step(dt:Float) {
    super.post_step(dt);
    entity.base.setPosition(x, y);
    entity.base.rotation = body.rotation;
  }

  override function added(entity:EntityBase<Object>) {
    super.added(entity);
    body.entity = entity;
    entity.base.setPosition(x, y);
  }

  override function removed() {
    super.removed();
    body.entity = null;
  }

  override function state_added(state:GameState) {
    super.state_added(state);
    state.world.add(body);
  }

  override function state_removed(state:GameState) {
    super.state_removed(state);
    state.world.remove(body);
  }

  override function dispose() {
    super.dispose();
    body.dispose();
  }
}
