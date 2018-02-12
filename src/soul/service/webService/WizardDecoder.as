package soul.service.webService
{
	import flash.utils.Dictionary;
	
	public class WizardDecoder
	{
		private var _complexTypes	:	Array;
		private var s				:	Namespace;
		private var _mappedClasses	:	Dictionary;
		
		public function WizardDecoder() { _mappedClasses = new Dictionary(); }
		
		internal function decode(xml:XML, decleration:XML, methodName:String):*
		{
			var soap:Namespace	= xml.namespace("soap");
			var body:XMLList	= xml.soap::Body;
			var response:XML	= body.children()[0];
			var result:XML		= response.children()[0];
			
			s = decleration.namespace("s");
			
			var complexType:XMLList = decleration.s::complexType;
			
			if (complexType.s::sequence == undefined)
			{
				return null;
			}
			
			var sequence:XMLList		= complexType.s::sequence;
			var elementDescription:XML	= sequence.children()[0];
			var type:String				= elementDescription.@type;
			
			return newObject(result, type);
		}
		
		private function getMappedClass(typeName:String):Class {
			if (typeName.indexOf("tns:") > -1)
				typeName = typeName.split(":")[1];

			return _mappedClasses[typeName];
		}
		
		public function insertClass(mappedClass:Class, typeName:String = ""):void {
			if (mappedClass == null)
				throw new Error("Mapped class cannot be null");
			
			if (typeName == "") {
				var reg:RegExp = new RegExp("\\[ [^\\s]* \\  (?P<name> [^\\s]*) \\]", "mx");
				typeName = reg.exec(String(mappedClass)).name
			}
			
			_mappedClasses[typeName] = mappedClass;
		}
		
		private function newObject(valueXML:XML, type:String):* {
			if (valueXML == null)
				return null;
				
			if (valueXML.hasSimpleContent() && type.indexOf("ArrayOf") == -1) {
				return createSimpleObject(valueXML, type);
			} else {
				if (type.indexOf("ArrayOf") > -1) {
					return createArray(valueXML, getComplexType(type));
				} else {
					return createObject(valueXML, getComplexType(type));
				}
				
			}
		}
		
		private function createObject(valueXML:XML, descriptionalXML:XML):* {
			var tempObject:*;
			if(getMappedClass(descriptionalXML.@name) == null)
				tempObject = new Object();
			else {
				var myClass:Class = getMappedClass(descriptionalXML.@name) as Class;
				tempObject = new myClass();
			}
			
			if (descriptionalXML.s::sequence == undefined)
				return void;
			
			var sequence:XMLList = descriptionalXML.s::sequence;
			var ns:Namespace = valueXML.namespace();
			
			for each (var elementXML:XML in sequence.children()) 
			{
				var currentValue:XML = valueXML.ns::[elementXML.@name][0];
				
				if(currentValue != null) {
					
					tempObject[elementXML.@name] = newObject(currentValue, elementXML.@type );
				
				} else {
					tempObject[elementXML.@name] = null;
				}
				
				
			}
			
			var attributes:XMLList = descriptionalXML.s::attribute;
			
			for each (var attributeXML:XML in attributes) 
			{
				tempObject[attributeXML.@name] = 
					createSimpleObject(valueXML["@" + attributeXML.@name], attributeXML.@type);
			}
			
			return tempObject;
		}
		
		private function createArray(valueXML:XML, descriptionalXML:XML):Array {
			if (descriptionalXML.@name != "ArrayOfAnyType")
				return createTypedArray(valueXML, descriptionalXML);
			else
				return createUntypedArray(valueXML);
				
		}
		
		private function createTypedArray(valueXML:XML, descriptionalXML:XML):Array {
			var tempArr:Array = new Array;
			
			//If the return value is void
			if (descriptionalXML.s::sequence == undefined)
				return null;
			
			var sequence:XMLList = descriptionalXML.s::sequence;
			var elementXML:XML = sequence.children()[0];
			
			for each (var currentValue:XML in valueXML.children()) 
			{
				var newPost:* = newObject(currentValue, elementXML.@type);
				tempArr.push(newPost);
			}
			
			return tempArr;
			
		}
		
		private function createUntypedArray(valueXML:XML):Array {
			var tempArr:Array = new Array;
			var xsi:Namespace = valueXML.namespace("xsi");
			for each (var nod:XML in valueXML.children()) 
			{
				var type:String = nod.@xsi::type;
				
				if(type.indexOf("xsd:") > -1)
					type = nod.@xsi::type.split(":")[1];
					
				tempArr.push(newObject(nod, type));
			}
			return tempArr;
		}
		
		
		private function createSimpleObject(value:String, type:String):* {
			if (type.indexOf("s:") > -1)
				type = type.split(":")[1];
			
			switch(type) {
				case "string":
					return String(value);
				break;
				
				case "boolean":
					return value == "true";
				break;
				
				default:
					var toReturn:Number = Number(value);
					//if (isNaN(toReturn))
					//	return String(value);
						
					return toReturn;
				break;
			}
		}
		
		public function insertComplexTypes(complexTypes:Array):void
		{
			_complexTypes = complexTypes.concat();
		}
		
		
		private function getComplexType(typeName:String):XML {
			if (typeName.indexOf("tns:") > -1)
				typeName = typeName.split(":")[1];
			
			for each (var element:XML in _complexTypes) 
			{
				if (element.@name == typeName) {
					
					if (element.s::complexContent != undefined)
					{
						//Has complex content
						var cc:XML = element.s::complexContent[0];
						if (cc.s::extension != undefined)
						{
							//Extends another class
							var newElement:XML = element.copy();
							newElement.setChildren( "" );
							
							var extension:XML = cc.s::extension[0].copy();
							var baseDefinition:XML = getComplexType(extension.@base);
							
							mergeXML(newElement, extension);
							mergeXML(newElement, baseDefinition);
							
							element = newElement;
						}
					}
					
					return element;
				}
			}
			
			trace("Not found!");
			return null;
		}
		
		private function mergeXML(baseXML:XML, additionXML:XML):void
		{
			var tags:XMLList = additionXML.s::*;
			for each (var tag:XML in tags) 
			{
				baseXML.appendChild(tag);
			}
		}
		
	}
	
}