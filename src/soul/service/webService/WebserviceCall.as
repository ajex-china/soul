package soul.service.webService
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.utils.Timer;
	
	public class WebserviceCall extends EventDispatcher
	{
		private var _rawResponse:XML;
		private var _rawRequest:XML;
		
		private var _callback:Function;
		
		private var _responseDecleration:XML;
		
		private var _name:String;
		
		private var _decoder:WizardDecoder;
		
		private var _errorHandler:ErrorHandler;
		
		private var _decodedObject:*;
		
		private var _timeout:int = -1;
		private var _timeoutTimer:Timer;
		
		private var _urlLoader:URLLoader;
		private var _request:URLRequest;
		
		private var _complexTypes:Array;
		
		public function WebserviceCall(wsdlURL:String, name:String, targetNamespace:String, requestXML:XML, callback:Function = null) 
		{
			_urlLoader = new URLLoader();
			_errorHandler = new ErrorHandler(this);
			
			_callback = callback;
			
			_request = new URLRequest(wsdlURL);
			_request.method = "POST";
			_request.data = requestXML;
			
			//Skyddar mot buggen om namespacet inte har ett slash i slutet
			if (targetNamespace.charAt(targetNamespace.length -1) != "/")
				targetNamespace += "/";
			
			var headers:Array = new Array();
			headers.push(new URLRequestHeader("SOAPAction", targetNamespace + name));
			headers.push(new URLRequestHeader("Content-Type", "text/xml; charset=utf-8"));
			_request.requestHeaders = headers;
			
			_rawRequest = requestXML;
			
			_urlLoader.addEventListener(Event.COMPLETE, callComplete);
			_errorHandler.handle(_urlLoader);
		}
		
		internal function load():void {
			_urlLoader.load(_request);
			
			if (_timeoutTimer != null)
				_timeoutTimer.start();
		}
		
		private function callComplete(event:Event):void {
			_rawResponse = XML(_urlLoader.data);
				
			dispatchEvent(new WebserviceEvent(WebserviceEvent.RESPONSE, true, _name));
		}
		
		public function close():void {
			_urlLoader.close();
		}
		
		public function get decodedObject():* {
			if (_decodedObject == null) {
				_decodedObject = _decoder.decode(_rawResponse, _responseDecleration, _name);
			}
			
			return _decodedObject;
		}
		
		public function get timeout():int { return _timeout; }
		
		public function set timeout(value:int):void 
		{
			_timeout = value;
			
			if (_timeout > 0) {
				if (_timeoutTimer == null) {
					_timeoutTimer = new Timer(_timeout);
					_timeoutTimer.addEventListener(TimerEvent.TIMER, timedOut, false, 0, true);
				}
				_timeoutTimer.delay = _timeout;
				
			} else {
				if (_timeoutTimer != null) {
					if (_timeoutTimer.running)
						_timeoutTimer.stop();
				}
			}
		}
		
		public function get responseDecleration():XML { return _responseDecleration; }
		
		public function set responseDecleration(value:XML):void 
		{
			_responseDecleration = value;
		}
		
		internal function set complexTypes(value:Array):void 
		{
			if(_decoder != null)
				_decoder.insertComplexTypes(value.concat());
		}
		
		public function get name():String { return _name; }
		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		public function get rawResponse():XML { return _rawResponse; }
		
		public function set rawResponse(value:XML):void 
		{
			_rawResponse = value;
		}
		
		internal function get callback():Function { return _callback; }
		
		public function get decoder():WizardDecoder { return _decoder; }
		
		public function set decoder(value:WizardDecoder):void 
		{
			_decoder = value;
		}
		
		private function timedOut(event:TimerEvent):void {
			close();
			_timeoutTimer.stop();
			
			var newEvent:WebserviceEvent = new WebserviceEvent(WebserviceEvent.RESPONSE, false, _name);
			newEvent.faultCode = 408;
			newEvent.faultDescription = "Client timedout (" + _timeout + " ms passed)";
			newEvent.faultObject = this;
			
			dispatchEvent(newEvent);
		}
		
	}
	
}