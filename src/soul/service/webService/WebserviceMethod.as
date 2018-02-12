package soul.service.webService
{
	import adobe.utils.CustomActions;
	import flash.events.EventDispatcher;
	
	internal class WebserviceMethod extends EventDispatcher
	{
		private var _name:String;
		private var _wsdlURL:String;
		
		private var _requestXML:XML;
		private var _responseXML:XML;
		private var _complexTypes:Array;
		private var _controlRestrictions:Boolean = false;
		
		private var _decoder:WizardDecoder;
		
		private var _timeout:int = -1;
		
		private var _envelopeHeader:XML;
		
		public function WebserviceMethod(name:String, wsdlURL:String, requestXML:XML, responseXML:XML) 
		{
			_name = name;
			_wsdlURL = wsdlURL;
			_requestXML = requestXML;
			_responseXML = responseXML;
		}
		
		public function call(parameters:Array, callback:Function = null):WebserviceCall {
			var xmlString:String = '<?xml version="1.0" encoding="utf-8"?>';
			xmlString += '<soap:Envelope' + createNamespaceDeclerations() + '>';
			xmlString += createHeader();
			xmlString += createBody(parameters);
			xmlString += '</soap:Envelope>';
			
			
			var call:WebserviceCall = new WebserviceCall(_wsdlURL, _name, _requestXML.namespace("tns"), XML(xmlString), callback);
			
			if (_decoder != null)
				call.decoder = _decoder;
			
			call.timeout = _timeout;
			call.responseDecleration = XML(_responseXML.toXMLString());
			call.complexTypes = _complexTypes;
			call.name = _name;
			call.load();
			
			return call;
		}
		
		private function createNamespaceDeclerations():String {
			var tempString:String = ' xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"';
			return tempString;
		}
		
		private function createBody(parameters:Array):String {
			var tempString:String = '<soap:Body>';
			tempString += '<' + _name + ' xmlns="' + _requestXML.namespace("tns").uri + '">';
			
			tempString += formBody(_requestXML, parameters);
			
			tempString += '</' + _name + '>';
			tempString += '</soap:Body>';
			
			return tempString;
		}
		
		private function formBody(elementXML:XML, parameters:Array):String {
			var s:Namespace = elementXML.namespace("s");
			
			var complexType:XMLList = elementXML.s::complexType;
			var sequence:XMLList = complexType.s::sequence;
			var elements:XMLList = sequence.s::element;
			
			var tempString:String = "";
			var iterator:int = 0;
			
			for each (var element:XML in elements) 
			{
				if (element.@type.split(":")[0] != "tns") {
					tempString += "<" + element.@name + ">";
					tempString += parameters[iterator];
					tempString += "</" + element.@name + ">";
				} else {
					if (element.@type.indexOf("ArrayOf") != -1) {
							
						tempString += "<" + element.@name + ">";
						tempString += createArray(element.@type.split(":")[1], parameters[iterator]);
						tempString += "</" + element.@name + ">";
						
					} else {
						tempString += "<" + element.@name + ">";
						tempString += serializeComplexType(element.@type.split(":")[1], parameters[iterator]);
						tempString += "</" + element.@name + ">";
					
					}
						
				}
				
				iterator++;
			}
			
			return tempString;
		}
		
		private function serializeComplexType(complexTypesName:String, object:*):String {
			var objectXML:XML = findComplexType(complexTypesName);
			var tempString:String = "";
			
			var s:Namespace = _requestXML.namespace("s");
			
			switch(objectXML.localName())
			{
				case "complexType":
					var sequence:XMLList = objectXML.s::sequence;
					var elements:XMLList = sequence.s::element;
					for each (var element:XML in elements) 
					{
						if (object[element.@name] != null)
						{
							if (element.@type.split(":")[0] != "tns")
							{
								tempString += "<" + element.@name + ">";
								tempString += object[element.@name];
								tempString += "</" + element.@name + ">";
							}
							else
							{
								
								if (element.@type.indexOf("ArrayOf") != -1)
								{
									
									tempString += "<" + element.@name + ">";
									tempString += createArray(element.@type.split(":")[1], object[element.@name]);
									tempString += "</" + element.@name + ">";
									
								}
								else
								{
								
									tempString += "<" + element.@name + ">";
									tempString += serializeComplexType(element.@type.split(":")[1], object[element.@name]);
									tempString += "</" + element.@name + ">";
								
								}
								
							}
						}
					}
				break;
				
				case "simpleType":
					if(_controlRestrictions) {
						var restrictions:XMLList = objectXML.s::restriction;
						var enumerations:XMLList = restrictions.s::enumeration;
						var validValue:Boolean = false;
						
						for each (var enumerationElement:XML in enumerations) 
						{
							if (String(enumerationElement.@value) == String(object))
							{
								validValue = true;
							}
						}
						
						if (validValue)
						{
							return String(object);
						}
						else
						{
							throw new Error(String(object) + " is not a valid value for the element " + complexTypesName);
						}
					}
					else
					{
						return String(object);
					}
					
				break;
				
				default:
					throw new Error("Unkown type of the element " + complexTypesName);
				break;
			}
			
			
			return tempString;
		}
		
		private function createArray(elementType:String, object:Array):String {
			var objectXML:XML = findComplexType(elementType);
			var tempString:String = "";
			trace(objectXML);
			
			var s:Namespace = _requestXML.namespace("s");
			
			var sequence:XMLList = objectXML.s::sequence;
			var elements:XMLList = sequence.s::element;
			var element:XML = elements[0];
			var i:int;
			
			var iterator:int = object.length;
			
				if (element.@type.split(":")[0] != "tns") {
					for (i = 0; i < iterator; i++) 
					{
						tempString += "<" + element.@name + ">";
						tempString += object[i];
						tempString += "</" + element.@name + ">";
					}
				} else {
					for (i = 0; i < iterator; i++) 
					{
						tempString += "<" + element.@name + ">";
						tempString += serializeComplexType(element.@type.split(":")[1], object[i]);
						tempString += "</" + element.@name + ">";
					}
				}
			
			return tempString;
		}
		
		private function findComplexType(name:String):XML {
			for each (var complexType:XML in _complexTypes) 
			{
				if (complexType.@name == name)
					return complexType;
			}
			
			return new XML();
		}
		
		private function createHeader():String {
			var tempString:String = "";
			tempString += "<soap:Header>";
			
			if (_envelopeHeader != null) {
				var tempNS:Namespace = new Namespace(_requestXML.namespace("tns").uri);
				_envelopeHeader.setNamespace(tempNS)
				tempString += _envelopeHeader.toXMLString();
			}
				
			tempString += "</soap:Header>";
			return tempString;
		}
		
		public function get envelopeHeader():XML { return _envelopeHeader; }
		
		public function set envelopeHeader(value:XML):void 
		{
			_envelopeHeader = value;
		}
		
		public function get name():String { return _name; }
		
		internal function set complexTypes(value:Array):void 
		{
			_complexTypes = value;
		}
		
		public function get timeout():int { return _timeout; }
		
		public function set timeout(value:int):void 
		{
			_timeout = value;
		}
		
		public function get decoder():WizardDecoder { return _decoder; }
		
		public function set decoder(value:WizardDecoder):void 
		{
			_decoder = value;
		}
		
		public function get controlRestrictions():Boolean { return _controlRestrictions; }
		
		public function set controlRestrictions(value:Boolean):void 
		{
			_controlRestrictions = value;
		}
		
	}
	
}