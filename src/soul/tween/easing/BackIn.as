package soul.tween.easing{
	final public class BackIn extends Ease {
		
		public static var ease:BackIn = new BackIn();
	
		public function BackIn(overshoot:Number=1.70158) {
			_p1 = overshoot;
		}
		
		override public function getRatio(p:Number):Number {
			return p * p * ((_p1 + 1) * p - _p1);
		}
		
		public function config(overshoot:Number=1.70158):BackIn {
			return new BackIn(overshoot);
		}
	
	}
	
}
