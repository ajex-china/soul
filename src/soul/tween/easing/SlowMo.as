package  soul.tween.easing{
	public class SlowMo extends Ease {
		
		public static var ease:SlowMo = new SlowMo();
		
		private var _p:Number;
		
		public function SlowMo(linearRatio:Number=0.7, power:Number=0.7, yoyoMode:Boolean=false) {
			if (linearRatio > 1) {
				linearRatio = 1;
			}
			_p = (linearRatio != 1) ? power : 0;
			_p1 = (1 - linearRatio) / 2;
			_p2 = linearRatio;
			_p3 = _p1 + _p2;
			_calcEnd = yoyoMode;
		}
		
		override public function getRatio(p:Number):Number {
			var r:Number = p + (0.5 - p) * _p;
			if (p < _p1) {
				return _calcEnd ? 1 - ((p = 1 - (p / _p1)) * p) : r - ((p = 1 - (p / _p1)) * p * p * p * r);
			} else if (p > _p3) {
				return _calcEnd ? 1 - (p = (p - _p3) / _p1) * p : r + ((p - r) * (p = (p - _p3) / _p1) * p * p * p);
			}
			return _calcEnd ? 1 : r;
		}
		
		public function config(linearRatio:Number=0.7, power:Number=0.7, yoyoMode:Boolean=false):SlowMo {
			return new SlowMo(linearRatio, power, yoyoMode);
		}
		
	}
	
}
