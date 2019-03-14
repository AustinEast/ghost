package h2d.data;

import h2d.data.Animations;
import echo.data.Options;

typedef SpriteOptions = {
  ?graphic:GraphicOptions,
  ?body:BodyOptions
}

typedef GraphicOptions = {
  ?asset:hxd.res.Image,
  ?animated:Bool,
  ?width:Int,
  ?height:Int,
  ?animations:Array<Animation>
}
