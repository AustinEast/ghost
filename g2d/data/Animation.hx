package g2d.data;

typedef Animation = {
  var name:String;
  var frames:Array<Int>;
  var speed:Int;
  var looped:Bool;
  var loop_delay:Float;
  var direction:AnimationDirection;
  var ?ease:Ease;
}

@:enum
abstract AnimationDirection(String) {
  var FORWARD = 'Forward';
  var REVERSE = 'Reverse';
  var PINGPONG = 'PingPong';
}

// TODO: Add in optional Easing functions on enter/exit
@:enum
abstract Ease(Int) {
  var TODO = 0;
}
