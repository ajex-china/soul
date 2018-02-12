package  soul.tween.easing{
	public class SteppedEase extends Ease {
		private var _steps:int;
		
		public function SteppedEase(steps:int) {
			_p1 = 1 / steps;
			_steps = steps + 1;
		}
		
		public static function create(steps:int):SteppedEase {
			return new SteppedEase(steps);
		}
		
		override public function getRatio(p:Number):Number {
			if (p < 0) {
				p = 0;
			} else if (p >= 1) {
				p = 0.999999999;
			}
			return ((_steps * p) >> 0) * _p1;
		}
		
		public static function config(steps:int):SteppedEase {
			return new SteppedEase(steps);
		}
		
		public function get steps():int {
			return _steps - 1;
		}

	}
}
