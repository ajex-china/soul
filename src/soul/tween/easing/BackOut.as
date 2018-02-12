package soul.tween.easing{
	final public class BackOut extends Ease {
	
		public static var ease:BackOut = new BackOut();
		
		public function BackOut(overshoot:Number=1.70158) {
			_p1 = overshoot;
		}
		
		override public function getRatio(p:Number):Number {
			return ((p = p - 1) * p * ((_p1 + 1) * p + _p1) + 1);
		}
		
		public function config(overshoot:Number=1.70158):BackOut {
			return new BackOut(overshoot);
		}
	
	}
	
}
