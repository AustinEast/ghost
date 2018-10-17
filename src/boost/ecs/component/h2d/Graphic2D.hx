package boost.ecs.component.h2d;

import hxd.res.Image;
import boost.util.Color;
import h2d.Bitmap;
import h2d.Tile;
import ecs.component.Component;

class Graphic2D extends Component {

	public var animations:Map<String,Animation>;

	public var animation_index:Int;

	public var frames:Array<Tile>;

	public var current_animation:Animation;

	public var current_frame:Int;

	public var animation_is_reserved:Bool;

	public var visible(get, set):Bool;

	public var width(get, null):Int;

	public var height(get, null):Int;

	public var dx(get, set):Int;

	public var dy(get, set):Int;

	public var bitmap:Bitmap;
	
	public function new(?bitmap:Bitmap) {
		this.bitmap = bitmap == null ? new Bitmap() : bitmap;
		animations = [];
		frames = [];
		current_frame = 0;
	}

	public function load_graphic(asset:Image, animated:Bool = false, width:Int = 0, height:Int = 0) {
		clear_frames();
		current_frame = 0;
		if (animated) {
			var t = asset.toTile();
			frames = [
				for(y in 0 ... Std.int(t.height / height))
				for(x in 0 ... Std.int(t.width / width))
				t.sub(x * width, y * height, width, height)
			];
		} else frames[0] = asset.toTile();
		bitmap.tile = frames[current_frame];
    }

    public function make_graphic(width:Int, height:Int, color:Int = Color.WHITE, alpha:Float = 1) {
		clear_frames();
		current_frame = 0;
		frames[0] = Tile.fromColor(color, width, height, alpha);
		bitmap.tile = frames[current_frame];
    }

	public function play_animation(name:String) {
		if (animations.exists(name)) {
			current_animation = animations.get(name);
			animation_index = current_animation.direction == REVERSE ? current_animation.frames.length : 0;
		} else GM.log.warn('Animation `${name}` does not exist on this Entity');
	}

	public function add_animation(name:String, frames:Array<Int>, speed:Int = 15, looped:Bool = false, direction:AnimationDirection = AnimationDirection.FORWARD):Animation {
		animations.exists(name) ? GM.log.warn('Animation `${name}` already exists on this Entity') 
		: animations.set(name, {name:name, frames:frames, speed:speed, looped:looped, direction: direction);
		return animations.get(name);
	}

	function clear_frames() while (frames.length > 0) frames.pop().dispose();

	// getters
	function get_visible():Bool return bitmap.visible;
	function get_width():Int return bitmap.tile.width;
	function get_height():Int return bitmap.tile.height;
	function get_dx():Int return bitmap.tile.dx;
	function get_dy():Int return bitmap.tile.dy;

	// setters
	function set_visible(value:Bool):Bool return bitmap.visible = value;
	function set_dx(value:Int) return bitmap.tile.dx = value;
	function set_dy(value:Int) return bitmap.tile.dy = value;
}

typedef Animation = {
    name:String,
	frames:Array<Int>,
	speed:Int,
	looped:Bool,
	direction: AnimationDirection
}

@:enum 
abstract AnimationDirection (Int) {
	var FORWARD  = 0;
	var REVERSE  = 1;
	var PINGPONG = 2;
}


