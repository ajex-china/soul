package soul.service.http
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import soul.debug.AS3Debugger;
	/**
	 *HTTP通信抽象类 继承用 
	 * @author Administrator
	 * 
	 */
	public class BaseHttpService
	{
		private var _urlLoader:URLLoader;
		private var _urlRequest:URLRequest;
		private var _urlVariables:URLVariables;
		public function BaseHttpService()
		{
			init();
		}
		public function init():void
		{
			_urlLoader = new URLLoader();
			_urlRequest = new URLRequest();
			_urlLoader.addEventListener(Event.COMPLETE, completeHandler);
			_urlLoader.addEventListener(Event.OPEN, openHandler);
			_urlLoader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpHandler);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		}
		protected function completeHandler(e:Event):void
		{
			AS3Debugger.Trace("completeHandler");
		}
		protected function openHandler(e:Event):void
		{
			AS3Debugger.Trace("openHandler");
		}
		protected function progressHandler(e:ProgressEvent):void
		{
			AS3Debugger.Trace("progressHandler");
		}
		protected function securityErrorHandler(e:SecurityErrorEvent):void
		{
			AS3Debugger.Trace("securityErrorHandler");
		}
		protected function httpHandler(e:HTTPStatusEvent):void
		{
			AS3Debugger.Trace("httpHandler");
		}
		protected function errorHandler(e:IOErrorEvent):void
		{
			AS3Debugger.Trace("errorHandler:" + e.text);
		}
		public function sendURL(url:String,method:String,data:Object = null):void
		{
			_urlVariables = new URLVariables();
			if(data)
			{
				for (var key:* in data) { 
					_urlVariables[key] = data[key];
				}
				
			}
			_urlRequest.url = url;
			_urlRequest.method = method;
			_urlRequest.data = _urlVariables;
			_urlLoader.load(_urlRequest);
			AS3Debugger.Trace("HTTPURL:" + url);
		}

		public function get urlLoader():URLLoader
		{
			return _urlLoader;
		}


		public function get urlRequest():URLRequest
		{
			return _urlRequest;
		}


		public function get urlVariables():URLVariables
		{
			return _urlVariables;
		}


	}
}