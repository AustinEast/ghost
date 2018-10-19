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

class GameObject extends Entity {

	public var transform:Transform2D;
	public var motion:Motion2D;
    public var graphic:Graphic2D;
    public var object:Object2D;

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

    public function load_graphic(asset:Image, animated:Bool = false, width:Int = 0, height:Int = 0) {
		graphic.visible = true;
        graphic.load(asset, animated, width, height);
    }

    public function make_graphic(width:Int, height:Int, color:Int = Color.WHITE, alpha:Float = 1) {
        graphic.visible = true;
        graphic.make(width, height, color, alpha);
    }

    public function add_child(game_object:GameObject) {
        object.object.addChild(game_object.object.object);
    }

    public function remove_child(game_object:GameObject) {
        object.object.removeChild(game_object.object.object);
    }
}