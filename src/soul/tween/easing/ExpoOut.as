package  soul.tween.easing {
	final public class ExpoOut extends Ease {
		
		public static var ease:ExpoOut = new ExpoOut();
		
		override public function getRatio(p:Number):Number {
			return 1 - Math.pow(2, -10 * p);
		}
		
	}
	
}
