package soul.tween.easing{
	final public class ElasticOut extends Ease {
		
		private static const _2PI:Number = Math.PI * 2;
		
		public static var ease:ElasticOut = new ElasticOut();
		
		public function ElasticOut(amplitude:Number=1, period:Number=0.3) {
			_p1 = amplitude || 1;
			_p2 = period || 0.3;
			_p3 = _p2 / _2PI * (Math.asin(1 / _p1) || 0); 
		}
		
		override public function getRatio(p:Number):Number {
			return _p1 * Math.pow(2, -10 * p) * Math.sin( (p - _p3) * _2PI / _p2 ) + 1;
		}
		
		public function config(amplitude:Number=1, period:Number=0.3):ElasticOut {
			return new ElasticOut(amplitude, period);
		}
		
	}
	
}
