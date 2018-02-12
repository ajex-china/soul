package soul.events{
	import flash.events.Event;
	public class TweenEvent extends Event {
		/** @private **/
		public static const VERSION:Number = 12.0;
		public static const START:String = "start";
		public static const UPDATE:String = "change";
		public static const COMPLETE:String = "complete";
		public static const REVERSE_COMPLETE:String = "reverseComplete";
		public static const REPEAT:String = "repeat";
		
		public function TweenEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event {
			return new TweenEvent(this.type, this.bubbles, this.cancelable);
		}
	
	}
	
}