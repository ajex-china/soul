package soul.tween.easing{
	final public class SineInOut extends Ease {
		
		public static var ease:SineInOut = new SineInOut();
		
		override public function getRatio(p:Number):Number {
			return -0.5 * (Math.cos(Math.PI * p) - 1);
		}
		
	}
	
}
