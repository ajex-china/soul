package soul.tween.easing {
	final public class Power0 {
		
		/** Eases out with a power of 0 (linear). Power0.easeIn, Power0.easeOut, and Power0.easeInOut are all identical because there is no power - they're all linear but use the common naming convention for ease of use. **/
		public static var easeOut:Ease = new Ease(null,null,1,0);
		
		/** Eases in with a power of 0 (linear). Power0.easeIn, Power0.easeOut, and Power0.easeInOut are all identical because there is no power - they're all linear but use the common naming convention for ease of use.  **/
		public static var easeIn:Ease = new Ease(null,null,2,0);
		
		/** eases in and then out with a power of 0 (linear). Power0.easeIn, Power0.easeOut, and Power0.easeInOut are all identical because there is no power - they're all linear but use the common naming convention for ease of use.  **/
		public static var easeInOut:Ease = new Ease(null,null,3,0);
	}
}