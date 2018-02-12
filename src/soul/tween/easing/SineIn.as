package soul.tween.easing{
	final public class SineIn extends Ease {
		
		private static const _HALF_PI:Number = Math.PI / 2;
		
		public static var ease:SineIn = new SineIn();
		
		override public function getRatio(p:Number):Number {
			return -Math.cos(p * _HALF_PI) + 1;
		}
		
	}
	
}
