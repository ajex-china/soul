package  soul.tween.easing{
	final public class SineOut extends Ease {
		
		private static const _HALF_PI:Number = Math.PI / 2;
		
		public static var ease:SineOut = new SineOut();
		
		override public function getRatio(p:Number):Number {
			return Math.sin(p * _HALF_PI);
		}
		
	}
	
}
