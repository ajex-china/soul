package  soul.tween.easing.core {
	final public class EasePoint {
		public var time:Number;
		public var gap:Number;
		public var value:Number;
		public var change:Number;
		public var next:EasePoint;
		public var prev:EasePoint;
		
		public function EasePoint(time:Number, value:Number, next:EasePoint) {
			this.time = time;
			this.value = value;
			if (next) {
				this.next = next;
				next.prev = this;
				this.change = next.value - value;
				this.gap = next.time - time;
			}
		}
	}
}