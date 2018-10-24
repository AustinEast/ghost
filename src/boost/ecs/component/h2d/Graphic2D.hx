package boost.ecs.component.h2d;

import h2d.Bitmap;
import h2d.Tile;
import hxd.res.Image;
import boost.system.ds.Animations;
import boost.util.Color;
import ecs.component.Component;

class Graphic2D extends Component {

	public var animations:Animations;

	public var frames:Array<Tile>;

	public var current_frame:Int;

	public var visible(get, set):Bool;

	public var width(get, null):Int;

	public var height(get, null):Int;

	public var dx(default, set):Int;

	public var dy(default, set):Int;

	public var bitmap:Bitmap;
	
	public function new(?bitmap:Bitmap) {
		this.bitmap = bitmap == null ? new Bitmap() : bitmap;
		animations = new Animations();
		frames = [];
		dx = 0;
		dy = 0;
		current_frame = 0;
	}

	public function load(asset:Image, sprite_sheet:Bool = false, width:Int = 0, height:Int = 0) {
		clear_frames();
		current_frame = 0;
		if (sprite_sheet) {
			var t = asset.toTile();
			frames = [
				for(y in 0 ... Std.int(t.height / height))
				for(x in 0 ... Std.int(t.width / width))
				t.sub(x * width, y * height, width, height)
			];
		} else frames[0] = asset.toTile();
		update_frames();
		bitmap.tile = frames[0];
    }

    public function make(width:Int, height:Int, color:Int = Color.WHITE, alpha:Float = 1) {
		clear_frames();
		current_frame = 0;
		frames[current_frame] = Tile.fromColor(color, width, height, alpha);
		update_frames();
		bitmap.tile = frames[current_frame];
    }

	public function center_origin() {
		dx = -Math.floor(width * 0.5);
        dy = -Math.floor(height * 0.5);
	}

	inline function clear_frames() while (frames.length > 0) frames.pop().dispose();

	inline function update_frames() {
		for (frame in frames) {
			frame.dx = dx;
			frame.dy = dy;
		}
	}

	// getters
	function get_visible():Bool return bitmap.visible;
	function get_width():Int return bitmap.tile.width;
	function get_height():Int return bitmap.tile.height;

	// setters
	function set_visible(value:Bool):Bool return bitmap.visible = value;
	function set_dx(value:Int) {
		for (frame in frames) frame.dx = value;
		return dx = value;
	} 
	function set_dy(value:Int) {
		for (frame in frames) frame.dy = value;
		return dy = value;
	}
}


