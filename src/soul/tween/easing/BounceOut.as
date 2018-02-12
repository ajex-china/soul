package soul.tween.easing{
	final public class BounceOut extends Ease {
		
		public static var ease:BounceOut = new BounceOut();
	
		override public function getRatio(p:Number):Number {
			if (p < 1 / 2.75) {
				return 7.5625 * p * p;
			} else if (p < 2 / 2.75) {
				return 7.5625 * (p -= 1.5 / 2.75) * p + .75;
			} else if (p < 2.5 / 2.75) {
				return 7.5625 * (p -= 2.25 / 2.75) * p + .9375;
			} else {
				return 7.5625 * (p -= 2.625 / 2.75) * p + .984375;
			}
		}
		
	}
	
}
