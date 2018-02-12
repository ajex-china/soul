package soul.tween.easing{
	final public class CircOut extends Ease {
		
		public static var ease:CircOut = new CircOut();
		
		override public function getRatio(p:Number):Number {
			return Math.sqrt(1 - (p = p - 1) * p);
		}
		
	}
	
}
