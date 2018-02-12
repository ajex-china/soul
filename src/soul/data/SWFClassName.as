package soul.data
{
	import soul.debug.AS3Debugger;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	/**
	 *swf 解析类 
	 * @author Administrator
	 * 
	 */	
	public class SWFClassName
	{
		
		private static var byteArray:ByteArray = null;
		private static var names:Array = null;
		private static var num:int = 0;
		
		public static function getClassName(bytes:ByteArray):Array
		{
			num = 0 ;
			names = [];
			byteArray = new ByteArray();
			byteArray.writeBytes(bytes);
			byteArray.position = 0;
			byteArray.endian = Endian.LITTLE_ENDIAN ;
			var compressModal:String = null;
			compressModal = byteArray.readUTFBytes(3);
			if (compressModal != "FWS" && compressModal != "CWS") 
			{
				AS3Debugger.Trace("不能识别的SWF文件格式");
			}
			byteArray.readByte()
			byteArray.readUnsignedInt();
			byteArray.readBytes(byteArray);
			byteArray.length = byteArray.length - 8;
			if (compressModal == "CWS")
			{
				byteArray.uncompress();
			}
			byteArray.position = 13
			var tag:int = 0;
			var tagFlag:int = 0;
			var tagLength:int = 0;
			var tagBytes:ByteArray = null;
			while (byteArray.bytesAvailable)
			{
				readSWFTag(byteArray);
			}
			byteArray.clear();
			return names;
			//return screen(names.splice(0, names.length));
		}
		
		private static function screen(list:Array):Array
		{
			var l:Array = [];
			for each(var name:String in list)
			{
				if (name.indexOf("_fla.") != -1)
				{
					continue;
				}
				l.push(name);
				AS3Debugger.Trace("[SWFClassName.screen]" + name);
			}
			return l;
		}
		
		private static function readSWFTag(bytes:ByteArray):void
		{
			var tag:int=bytes.readUnsignedShort();
			var tagFlag:int= tag >> 6;
			var tagl:int=tag & 63;                        
			if ((tagl & 63 )== 63)
			{
				tagl = bytes.readUnsignedInt();
			}
			if (tagFlag == 76) 
			{
				var tagContent:ByteArray=new ByteArray () ;
				if (tagl != 0) 
				{
					bytes.readBytes(tagContent,0,tagl);
				}
				getClass(tagContent);
			}
			else 
			{
				bytes.position = bytes.position + tagl;
			}
			return;
		}
		private static function getClass(bytes:ByteArray):void {
			
			var name:String = null;                        
			var l:int = readUI16(bytes);
			var count:int = 0;                        
			while (count < l)
			{                                
				readUI16(bytes);                                
				name = readToString(bytes);        
				names.push(name);
				count++;
				num++
				if(num > 400)
				{
					return ;
				}
			}
			return ;
		}
		
		private static function readToString(bytes:ByteArray):String 
		{
			var nameBytes:ByteArray = null;
			var l:int = 1;
			var num:int = 0;
			var name:String = null;
			while (true)
			{
				num = bytes.readByte();                                
				if (num == 0)
				{
					nameBytes = new ByteArray () ;
					nameBytes.writeBytes(bytes, bytes.position - l, l);
					nameBytes.position = 0;
					name = nameBytes.readUTFBytes(l);
					break;
				}
				l++;
			}
			return name;
		}
		
		private static function readUI16(bytes:ByteArray):int
		{
			var num1:Number = bytes.readUnsignedByte();
			var num2:Number = bytes.readUnsignedByte();                        
			return num1 +(num2 << 8);
		}
	}
}