package soul.tween.easing
{
	public class Ease 
	{
		protected static var _baseParams:Array = [0, 0, 1, 1];
		protected var _func:Function;
		protected var _params:Array;
		protected var _p1:Number;
		protected var _p2:Number;
		protected var _p3:Number;
		public var _type:int;
		public var _power:int;
		public var _calcEnd:Boolean;
		public function Ease(func:Function=null, extraParams:Array=null, type:Number=0, power:Number=0) {
			_func = func;
			_params = (extraParams) ? _baseParams.concat(extraParams) : _baseParams;
			_type = type;
			_power = power;
		}
		public function getRatio(p:Number):Number {
			if (_func != null) {
				_params[0] = p;
				return _func.apply(null, _params);
			} else {
				var r:Number = (_type == 1) ? 1 - p : (_type == 2) ? p : (p < 0.5) ? p * 2 : (1 - p) * 2;
				if (_power == 1) {
					r *= r;
				} else if (_power == 2) {
					r *= r * r;
				} else if (_power == 3) {
					r *= r * r * r;
				} else if (_power == 4) {
					r *= r * r * r * r;
				}
				return (_type == 1) ? 1 - r : (_type == 2) ? r : (p < 0.5) ? r / 2 : 1 - (r / 2);
			}
		}
		
	}
}
