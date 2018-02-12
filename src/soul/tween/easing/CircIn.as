package  soul.tween.easing{
	final public class CircIn extends Ease {
	
		public static var ease:CircIn = new CircIn();

		override public function getRatio(p:Number):Number {
			return -(Math.sqrt(1 - (p * p)) - 1);
		}
		
	}
}
