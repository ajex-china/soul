package soul.service.websocket
{
	import flash.events.Event;
	
	public class WebSocketEvent extends Event
	{
		public static const SOCKET_DATA:String="SOCKET_DATA";
		public static const NULL_DATA:String="NULL_DATA";
		public static const CONNECT:String="CONNECT";
		public static const CLOSE:String="CLOSE";
		public static const IO_ERROR:String="IO_ERROR";
		public static const SECURITY_ERROR:String="SECURITY_ERROR";
		public var receivPacakge:Object = null;
		public static var SOCKET_REPEAT_CONNECT:String = "SOCKET_REPEAT_CONNECT";
		public var data:*;
		public function WebSocketEvent(type:String,_data:*=null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = _data;
			super(type, bubbles, cancelable);
		}
	}
}