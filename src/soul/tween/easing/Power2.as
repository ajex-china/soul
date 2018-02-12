package soul.tween.easing{
	final public class Power2 {
		
		/** Eases out with a power of 2 **/
		public static var easeOut:Ease = new Ease(null,null,1,2);
		
		/** Eases in with a power of 2 **/
		public static var easeIn:Ease = new Ease(null,null,2,2);
		
		/** Eases in and then out with a power of 2 **/
		public static var easeInOut:Ease = new Ease(null,null,3,2);
	}
}