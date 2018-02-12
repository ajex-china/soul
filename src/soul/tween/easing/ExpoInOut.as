package  soul.tween.easing{
	final public class ExpoInOut extends Ease {
	
		public static var ease:ExpoInOut = new ExpoInOut();

		/** @inheritDoc **/
		override public function getRatio(p:Number):Number {
			return ((p*=2) < 1) ? 0.5 * Math.pow(2, 10 * (p - 1)) : 0.5 * (2 - Math.pow(2, -10 * (p - 1)));
		}
		
	}
	
}
