package soul.tween.easing{
	final public class BounceIn extends Ease {
		
		public static var ease:BounceIn = new BounceIn();
	
		override public function getRatio(p:Number):Number {
			if ((p = 1 - p) < 1 / 2.75) {
				return 1 - (7.5625 * p * p);
			} else if (p < 2 / 2.75) {
				return 1 - (7.5625 * (p -= 1.5 / 2.75) * p + .75);
			} else if (p < 2.5 / 2.75) {
				return 1 - (7.5625 * (p -= 2.25 / 2.75) * p + .9375);
			} else {
				return 1 - (7.5625 * (p -= 2.625 / 2.75) * p + .984375);
			}
		}
	
	}
	
}
