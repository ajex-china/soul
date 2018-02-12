package soul.service.webService
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	internal class WSDL extends EventDispatcher
	{
		private var _wsdlURL:String;
		
		private var _ready:Boolean = false;
		private var _downloading:Boolean = false;
		
		private var _rawWSDL:XML;
		private var _decoder:WizardDecoder;
		
		private var _complexTypes:Array;
		
		private var _downloader:URLLoader;
		private var _errorHandler:ErrorHandler;
		
		public function WSDL(wsdlURL:String) 
		{
			_wsdlURL = wsdlURL;
			_errorHandler = new ErrorHandler(this);
		}
		
		public function insertWSDL(wsdl:XML):void {
			_rawWSDL = wsdl;
			_complexTypes = null;
			
			_ready = true;
			
			if(_decoder != null)
				_decoder.insertComplexTypes(complexTypes);
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function downloadWSDL():void {
			_downloader = new URLLoader();
			
			_downloader.addEventListener(Event.COMPLETE, wsdlDownloaded);
			_errorHandler.handle(_downloader);
			
			_downloader.load( new URLRequest(_wsdlURL + "?WSDL&m=" + Math.random()));
			
			_downloading = true;
		}
		
		private function wsdlDownloaded(event:Event):void {
			var data:String = _downloader.data;
			
			if (data.indexOf("<") != 0)
			{
				data = data.substr(data.indexOf("<"), data.length);
			}
			
			if (data.lastIndexOf(">") != data.length - 1)
			{
				data = data.substr(0, data.lastIndexOf(">") + 1);
			}
			
			insertWSDL( XML(data) );
		}
		
		public function createMetod(methodName:String):WebserviceMethod {
			var requestXML:XML = getRequestXML(methodName);
			var responseXML:XML = getResponseXML(methodName);
			
			var method:WebserviceMethod = new WebserviceMethod(methodName, _wsdlURL, requestXML, responseXML);
			method.complexTypes = complexTypes;
			
			method.decoder = _decoder;
			
			return method;
		}
		
		private function getComplexTypes():Array {
			var tempArr:Array = new Array();
			
			var wsdl:Namespace = _rawWSDL.namespace("wsdl");
			var s:Namespace = _rawWSDL.namespace("s");
			
			var types:XMLList = _rawWSDL.wsdl::types;
			var schema:XMLList = types.s::schema;
			var complexTypes:XMLList = schema.s::complexType;
			
			for each (var complexType:XML in complexTypes) 
			{
				tempArr.push(complexType);
			}
			
			var simpleTypes:XMLList = schema.s::simpleType;
			
			for each (var simpleType:XML in simpleTypes) 
			{
				tempArr.push(simpleType);
			}
			
			return tempArr.concat();
		}
		
		public function get ready():Boolean { return _ready; }
		
		public function get complexTypes():Array {
			if (_complexTypes == null)
				_complexTypes = getComplexTypes();
				
			return _complexTypes;
		}
		
		public function get downloading():Boolean { return _downloading; }
		
		public function get decoder():WizardDecoder { return _decoder; }
		
		public function set decoder(value:WizardDecoder):void 
		{
			_decoder = value;
		}
		
		public function get rawWSDL():XML { return _rawWSDL; }
		
		public function getMethods():Array {
			var wsdl : Namespace = _rawWSDL.namespace("wsdl");
			var portType : XMLList = _rawWSDL.wsdl::portType;
			
			for each (var port:XML in portType) 
			{
				if (new RegExp("Soap$").test(port.@name))
					break;
			}
			
			
			var operations : XMLList = port.wsdl::operation;
			
			var methodArray : Array = new Array();
			
			for each (var operation : XML in operations) 
			{
				methodArray.push(operation.@name);
			}
			
			return methodArray;
		}
		
		public function getRequestXML(methodName:String):XML {
			
			var s : Namespace = _rawWSDL.namespace("s");
			var wsdl : Namespace = _rawWSDL.namespace("wsdl");
			
			var types:XMLList = _rawWSDL.wsdl::types;
			
			var schema : XMLList = types.s::schema;
			var elements : XMLList = schema.s::element;
			
			
			for each (var element:XML in elements) 
			{
				if (element.@name == methodName) {
					return element;
				}
			}
			
			throw new Error("Method not found");
		}
		
		public function getResponseXML(methodName:String):XML {
			methodName += "Response";
			return getRequestXML(methodName);
		}
	}
	
}