package soul.service.webService
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	
	import flash.utils.setTimeout;
	
	internal class ErrorHandler 
	{
		private var _collaborator:IEventDispatcher;
		
		public function ErrorHandler(collaborator:IEventDispatcher) 
		{
			_collaborator = collaborator;
		}
		
		public function handle(downloader:URLLoader):void {
			downloader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusError);
			downloader.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			downloader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
		}
		
		private function dispatchEvent(event:Event):void {
			if(_collaborator.hasEventListener(event.type))
				_collaborator.dispatchEvent(event);
			else
				if (event is ErrorEvent)
					throw new Error("Unhandled error: " + ErrorEvent(event).text);
				else
					throw new Error("Unhandled error: " + event.toString());
		}
		
		private function ioError(event:IOErrorEvent):void
		{
			if (_collaborator is WSDL)
			{
				dispatchEvent(event);
			}
		}
		
		private function resendHttpStatus(event:HTTPStatusEvent):void {
			if (event.target.data == null) {
				event = new HTTPStatusEvent(event.type, event.bubbles, event.cancelable, 600);
				httpStatusError(event);
			}
		}
		
		private function httpStatusError(event:HTTPStatusEvent):void {
			if (event.status != 200) {
				var name:String = _collaborator is WebserviceCall ? WebserviceCall(_collaborator).name : "Unknown";
				
				if (event.status == 0) {
					setTimeout(resendHttpStatus, 50, event);
					return;
				}
				
				var newEvent:WebserviceEvent = new WebserviceEvent(WebserviceEvent.RESPONSE, false, name);
				newEvent.faultCode = event.status;
				switch(event.status) {
					case 500:
						newEvent.faultDescription = "Internal Server Error";
					break;
					
					case 501:
						newEvent.faultDescription = "Not Implemented";
					break;
					
					case 502:
						newEvent.faultDescription = "Bad Gateway";
					break;
					
					case 503:
						newEvent.faultDescription = "Service Unavailable";
					break;
					
					case 504:
						newEvent.faultDescription = "Gateway Timeout";
					break;
					
					case 600:
						newEvent.faultDescription = "Flash Player Plugin Error. You're using Flash Player plugin, all status codes are returned as 0.";
						newEvent.faultDescription += " No more information about the error is available";
						newEvent.faultCode = 0;
					break;
					
					default:
						newEvent.faultDescription = "HTTP Status Error";
					break;
				}
				newEvent.faultObject = _collaborator;
				
				dispatchEvent(newEvent);
			}
		}
		
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			var name:String = _collaborator is WebserviceCall ? WebserviceCall(_collaborator).name : "Unknown";
			var newEvent:WebserviceEvent = new WebserviceEvent(WebserviceEvent.RESPONSE, false, name);
			
			newEvent.faultCode = 401;
			newEvent.faultDescription = "Security " + event.text;
			newEvent.faultObject = _collaborator;
			
			dispatchEvent(newEvent);
		}
		
	}
	
}