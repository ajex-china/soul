package soul.tween.easing
{
	final public class BackInOut extends Ease 
	{
		
		public static var ease:BackInOut = new BackInOut();

		public function BackInOut(overshoot:Number=1.70158) 
		{
			_p1 = overshoot;
			_p2 = _p1 * 1.525;
		}
		
		override public function getRatio(p:Number):Number {
			return ((p*=2) < 1) ? 0.5 * p * p * ((_p2 + 1) * p - _p2) : 0.5 * ((p -= 2) * p * ((_p2 + 1) * p + _p2) + 2);
		}
		public function config(overshoot:Number=1.70158):BackInOut {
			return new BackInOut(overshoot);
		}
	
	}
	
}
