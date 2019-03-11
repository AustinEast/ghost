package h2d.component;

import ghost.EntityBase;
import echo.data.Options.BodyOptions;

class Body extends Component {
  public var body:echo.Body;

  public function new(?body_options:BodyOptions) {
    super('body');
    body = new echo.Body(body_options);
  }

  override function pre_step(dt:Float) {
    super.pre_step(dt);
    body.position.set(entity.base.x, entity.base.y);
  }

  override function post_step(dt:Float) {
    super.post_step(dt);
    entity.base.setPosition(body.x, body.y);
    entity.base.rotation = body.rotation;
  }

  override function added(entity:EntityBase<Object>) {
    super.added(entity);
    entity.base.setPosition(body.x, body.y);
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
