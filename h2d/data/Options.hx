package h2d.data;

import h2d.data.Animations;
import echo.data.Options;

typedef SpriteOptions = {
  > BodyOptions,
  ?graphic:GraphicOptions,
}

typedef GraphicOptions = {
  ?asset:hxd.res.Image,
  ?animated:Bool,
  ?width:Int,
  ?height:Int,
  ?animations:Array<Animation>
}

typedef TilesOptions = {
  tile_graphic:Tile,
  ?tile_width:Int,
  ?tile_height:Int
}
