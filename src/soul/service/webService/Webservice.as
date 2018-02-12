package soul.service.webService
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Proxy;
	import flash.utils.flash_proxy;
	
	public dynamic class Webservice extends Proxy implements IEventDispatcher
	{
		private var _envelopeHeader:XML;
		private var _methods:Array;
		private var _availableMethods:Array;
		private var _wsdl:WSDL;
		
		private var _wsdlURL:String;
		
		private var _eventDispatcher:EventDispatcher;
		
		private var _methodQueue:Array;
		private var _headerQueue:Array;
		private var _controlRestrictions:Boolean = false;
		
		private var _responseMethod:String = RESPONSE_METHOD_CONSTANT;
		
		public static const RESPONSE_METHOD_NAME:String		= "response_name";
		public static const RESPONSE_METHOD_CONSTANT:String	= "response_constant";
		
		public function Webservice(wsdlURL:String)
		{
			_eventDispatcher = new EventDispatcher(this);
			
			_methods		= new Array();
			_methodQueue	= new Array();
			_headerQueue	= new Array();
			
			//Removes the ending ?WSDL if it was inputted
			_wsdlURL		= wsdlURL.substr(wsdlURL.length - 5) == "?WSDL" ? wsdlURL.substring(0, wsdlURL.length - 5) : wsdlURL;
			//Creates a new WSDL handler and points it to the URL
			_wsdl = new WSDL(_wsdlURL);
			_wsdl.addEventListener(Event.COMPLETE, wsdlInserted);
			_wsdl.addEventListener(WebserviceEvent.RESPONSE, handleDataEvent);
			
			_wsdl.decoder = new WizardDecoder();
		}
		
		public function makeCall(methodName:String, ...params):WebserviceCall {
			return makeCallCore(methodName, null, params);
		}
		
		private function makeCallCore(methodName:String, callback:Function=null, parameters:Array=null):WebserviceCall {
			//Creates an empty array if none was submitted
			if (parameters == null)
				parameters = new Array();
			
			if (_wsdl.ready) {
				
				//Check to see that there really is a method called this
				if (methodExists(methodName)) {
					
					//Gets the method and makes a call
					var method:WebserviceMethod = getMethod(methodName);
					var call:WebserviceCall = method.call(parameters, callback);
					
					//Sets the listeners to the call object
					if(callback == null) {
						
						call.addEventListener(WebserviceEvent.RESPONSE, handleDataEvent);
					
					} else {
						
						call.addEventListener(WebserviceEvent.RESPONSE, runCallback);
						
					}
					
					
					return call;
					
				} else {
					//If the method was not found, create an error object and dispatch it
					var newEvent:WebserviceEvent = new WebserviceEvent(WebserviceEvent.ERROR, false, methodName);
					newEvent.faultCode = 501;
					newEvent.faultDescription = "Method not found";
					
					dispatchEvent(newEvent);
					
					return null;
				}
				
			} else {
				//If the WSDL is not ready, queue this method
				var saveArray:Array = new Array();
				saveArray.push(methodName);
				saveArray.push(callback);
				saveArray.push(parameters);
				_methodQueue.push( { argumentArray: saveArray } );
				
				if (!_wsdl.downloading)
					_wsdl.downloadWSDL();
				
				return null;
			}
		}
		
		public function makeCallWithCallback(methodName:String, callback:Function, ...params):void {
			var call:WebserviceCall = makeCallCore(methodName, callback, params);
		}
		
		private function runCallback(event:WebserviceEvent):void {
			var call:WebserviceCall = WebserviceCall(event.target);
			var returnObject:Object;
			
			if (event.success) {
				returnObject = call.decodedObject;
			} else {
				returnObject = new Object();
				returnObject.faultCode = event.faultCode;
				returnObject.faultDescription = event.faultDescription;
			}
			
			call.callback.call(call, event.success, returnObject);
		}
		
		public function insertWSDL(wsdl:XML):void {
			_wsdl.insertWSDL(wsdl);
		}
		
		public function getDecoder():WizardDecoder
		{
			return _wsdl.decoder;
		}
		
		private function handleDataEvent(event:WebserviceEvent):void {
			
			//The name of the event is based on what constant is set to the response method
			var typNamn:String = _responseMethod == RESPONSE_METHOD_CONSTANT ? WebserviceEvent.RESPONSE : event.name + "Response";
			var newEvent:WebserviceEvent;
			
			if (event.success) {
				
				newEvent = new WebserviceEvent(typNamn, true, event.name);
				newEvent.callObject = WebserviceCall(event.target);
				newEvent.faultCode = 200;
				
			} else {
				
				newEvent = new WebserviceEvent(typNamn, false, event.name);
				newEvent.faultObject = event.faultObject;
				newEvent.faultCode = event.faultCode;
				newEvent.faultDescription = event.faultDescription;
				
			}
			
			dispatchEvent(newEvent);
			
		}
		
		internal function getMethod(methodName:String):WebserviceMethod {
			//Checks to see that this method actually exists
			if (methodExists(methodName)) {
				
				//Loops the methods that have already been created and tries to find the right one
				for each (var method:WebserviceMethod in _methods) 
				{
					
					if (method.name == methodName)
						return method;
						
				}
				
				//If the method was not found in the list, create it and put it in the list
				var newMethod:WebserviceMethod = _wsdl.createMetod(methodName);
				_methods.push(newMethod);
				newMethod.envelopeHeader		= envelopeHeader;
				newMethod.controlRestrictions	= _controlRestrictions;
				
				
				return newMethod;
				
			} else {
				//If the method was not found, throw an error
				throw new Error("Method not found!", 501);
				
			}
			
		}
		
		public function methodExists(methodName:String):Boolean {
			
			//Loops through all the methodnames derieved from the WSDL
			//and tries to find one with a matching name
			for each (var method:String in _availableMethods) 
			{
				
				if (method == methodName)
					return true;
					
			}
			
			return false;
		
		}
		
		public function setHeader(methodName:String, header:XML):void {
			if (_wsdl.ready) {
				getMethod(methodName).envelopeHeader = header;
			} else {
				_headerQueue.push( { argumentArray: [methodName, header] } );
			}
		}
		
		private function wsdlInserted(event:Event):void {
			_availableMethods = _wsdl.getMethods();
			var queuedObject:Object;
				
			//purge header queue
			for each (queuedObject in _headerQueue) 
				setHeader.apply(this, queuedObject.argumentArray);
			
			//purge method queue
			for each (queuedObject in _methodQueue) 
				makeCallCore.apply(this, queuedObject.argumentArray);
			
			_methodQueue	= new Array();
			_headerQueue	= new Array();
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		override flash_proxy function callProperty(name:*, ...rest):* 
		{
			if (rest == null)
				rest = [];
			rest.unshift(name);
			
			return makeCall.apply(this, rest);
		}
		
		/* INTERFACE flash.events.IEventDispatcher */
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function dispatchEvent(event:Event):Boolean
		{
			return _eventDispatcher.dispatchEvent(event);
		}
		
		public function hasEventListener(type:String):Boolean
		{
			return _eventDispatcher.hasEventListener(type);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		
		public function willTrigger(type:String):Boolean
		{
			return _eventDispatcher.willTrigger(type);
		}
		
		public function get envelopeHeader():XML { return _envelopeHeader; }
		
		public function set envelopeHeader(value:XML):void 
		{
			_envelopeHeader = value;			
			
			for each (var method:String in _availableMethods) {
				getMethod(method).envelopeHeader = value;
			}
				
				
		}
		
		public function get wsdlReady():Boolean {
			return _wsdl.ready;
		}
		
		public function get wsdl():XML {
			return _wsdl.rawWSDL;
		}
		
		public function get availableMethods():Array { return _availableMethods; }
		
		public function get responseMethod():String { return _responseMethod; }
		
		public function set responseMethod(value:String):void 
		{
			if(_responseMethod == RESPONSE_METHOD_CONSTANT || _responseMethod == RESPONSE_METHOD_NAME)
				_responseMethod = value;
			else
				throw new Error("The response method must be set to either the RESPONSE_METHOD_CONSTANT or RESPONSE_METHOD_NAME");
		}
		
		public function downloadWSDL():void {
			if (!_wsdl.ready && !_wsdl.downloading)
				_wsdl.downloadWSDL();
		}
		
		public function set timeout(value:int):void {
			for each (var methodName:String in availableMethods) 
			{
				getMethod(methodName).timeout = value;
			}
		}
		
		public function get controlRestrictions():Boolean { return _controlRestrictions; }
		
		public function set controlRestrictions(value:Boolean):void 
		{
			_controlRestrictions = value;
			for each (var methodName:String in availableMethods) 
			{
				getMethod(methodName).controlRestrictions = value;
			}
		}
	}
}