package soul.events
{
	import flash.events.Event;
	
	public class ResizeEvent extends Event
	{
		
		/**
		 * 大小变化 
		 */
		public static const RESIZE:String = "resize";
		
		public var oldWidth:Number;
		public var oldHeight:Number;
		public var width:Number;
		public var height:Number;
		public function ResizeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}