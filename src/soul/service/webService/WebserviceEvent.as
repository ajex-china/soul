package soul.service.webService
{
	import flash.events.Event;
	
	public class WebserviceEvent extends Event 
	{
		private var _faultCode:int;
		private var _faultDescription:String;
		private var _faultObject:*;
		
		private var _callObject:WebserviceCall;
		private var _response:*;
		private var _name:String;
		
		private var _success:Boolean;
		
		public static const RESPONSE:String = "response_event";
		public static const ERROR:String="error";
		
		public function WebserviceEvent(type:String, success:Boolean, name:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			_success = success;
			_name = name;
		} 
		
		public override function clone():Event 
		{ 
			var event:WebserviceEvent = new WebserviceEvent(type, _success, _name, bubbles, cancelable);
			event.callObject 		= _callObject;
			event.faultCode 		= _faultCode;
			event.faultDescription 	= _faultDescription;
			event.faultObject 		= _faultObject;
			return event;
		} 
		
		public override function toString():String 
		{ 
			return formatToString("WebserviceEvent", "type", "success", "name",  "faultCode", "faultDescription"); 
		}
		
		public function get faultCode():int { return _faultCode; }
		
		public function set faultCode(value:int):void 
		{
			_faultCode = value;
		}
		
		public function get faultDescription():String { return _faultDescription; }
		
		public function set faultDescription(value:String):void 
		{
			_faultDescription = value;
		}
		
		public function get callObject():WebserviceCall { return _callObject; }
		
		public function set callObject(value:WebserviceCall):void 
		{
			_callObject = value;
		}
		
		public function get faultObject():* { return _faultObject; }
		
		public function set faultObject(value:*):void 
		{
			_faultObject = value;
		}
		
		public function get response():* { return _callObject?_callObject.decodedObject:null; }
		
		public function get success():Boolean { return _success; }
		
		public function get name():String { return _name; }
		
	}
	
}