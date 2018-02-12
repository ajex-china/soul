package soul.tween.easing{
	final public class BounceInOut extends Ease {
	
		public static var ease:BounceInOut = new BounceInOut();
		
		override public function getRatio(p:Number):Number {
			var invert:Boolean;
			if (p < 0.5) {
				invert = true;
				p = 1 - (p * 2);
			} else {
				p = (p * 2) - 1;
			}
			if (p < 1 / 2.75) {
				p = 7.5625 * p * p;
			} else if (p < 2 / 2.75) {
				p = 7.5625 * (p -= 1.5 / 2.75) * p + .75;
			} else if (p < 2.5 / 2.75) {
				p = 7.5625 * (p -= 2.25 / 2.75) * p + .9375;
			} else {
				p = 7.5625 * (p -= 2.625 / 2.75) * p + .984375;
			}
			return invert ? (1 - p) * 0.5 : p * 0.5 + 0.5;
		}
		
	}
	
}
