package soul.tween.easing
{
	final public class CircInOut extends Ease {
		
		public static var ease:CircInOut = new CircInOut();
		
		override public function getRatio(p:Number):Number {
			return ((p*=2) < 1) ? -0.5 * (Math.sqrt(1 - p * p) - 1) : 0.5 * (Math.sqrt(1 - (p -= 2) * p) + 1);
		}
		
	}
	
}
