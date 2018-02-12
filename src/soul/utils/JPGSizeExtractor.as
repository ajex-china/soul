package soul.utils
{
	import flash.net.URLStream;
	import flash.net.URLRequest;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.utils.Endian;
	
	/**
	 * jpg图片加载类 可以预先加载图片信息 
	 * @author Administrator
	 * 
	 */	
	public class JPGSizeExtractor extends URLStream
	{
		protected static const SOF0:Array=[0xFF, 0xC0, 0x00, 0x11, 0x08];
		public static const PARSE_COMPLETE:String="parseComplete";
		public static const PARSE_FAILED:String="parseFailed";
		protected var dataLoaded:uint;
		protected var jpgWidth:uint;
		protected var jpgHeight:uint;
		protected var jumpLength:uint;
		protected var stopWhenParseComplete:Boolean;
		protected var traceDebugInfo:Boolean;
		
		public function JPGSizeExtractor()
		{
			endian=Endian.BIG_ENDIAN;
		}
		
		protected function jumpBytes(count:uint):void
		{
			for (var i:uint=0; i < count; i++)
			{
				readByte();
			}
		}
		
		protected function progressHandler(e:ProgressEvent):void
		{
			dataLoaded=bytesAvailable;
			var APPSections:Array=new Array();
			for (var i:int=1; i < 16; i++)
			{
				APPSections[i]=[0xFF, 0xE0 + i];
			}
			var index:uint=0;
			var byte:int=0;
			var address:int=0;
			while (bytesAvailable >= SOF0.length + 4)
			{
				var match:Boolean=false;
				// Only look for new APP table if no jump is in queue
				if (jumpLength == 0)
				{
					byte=readUnsignedByte();
					address++;
					// Check for APP table
					for each (var APP:Array in APPSections)
					{
						if (byte == APP[index])
						{
							match=true;
							if (index + 1 >= APP.length)
							{
								if (traceDebugInfo)
									trace("APP" + Number(byte - 0xE0).toString(16).toUpperCase() + " found at 0x" + address.toString(16).toUpperCase());
								// APP table found, skip it as it may contain thumbnails in JPG (we don't want their SOF's)
								jumpLength=readUnsignedShort() - 2; // -2 for the short we just read
							}
						}
					}
				}
				// Jump here, so that data has always loaded
				if (jumpLength > 0)
				{
					if (traceDebugInfo)
						trace("Trying to jump " + jumpLength + " bytes (available " + Math.round(Math.min(bytesAvailable / jumpLength, 1) * 100) + "%)");
					if (bytesAvailable >= jumpLength)
					{
						if (traceDebugInfo)
							trace("Jumping " + jumpLength + " bytes to 0x" + Number(address + jumpLength).toString(16).toUpperCase());
						jumpBytes(jumpLength);
						match=false;
						jumpLength=0;
					}
					else
						break; // Load more data and continue
				}
				else
				{
					// Check for SOF
					if (byte == SOF0[index])
					{
						match=true;
						if (index + 1 >= SOF0.length)
						{
							// Matched SOF0
							if (traceDebugInfo)
								trace("SOF0 found at 0x" + address.toString(16).toUpperCase());
							jpgHeight=readUnsignedShort();
							jpgWidth=readUnsignedShort();
							if (traceDebugInfo)
								trace("Dimensions: " + jpgWidth + " x " + jpgHeight);
							removeEventListener(ProgressEvent.PROGRESS, progressHandler); // No need to look for dimensions anymore
							if (stopWhenParseComplete && connected)
								close();
							dispatchEvent(new Event(PARSE_COMPLETE));
							break;
						}
					}
					if (match)
					{
						index++;
					}
					else
					{
						index=0;
					}
				}
			}
		}
		
		protected function fileCompleteHandler(e:Event):void
		{
			if (!jpgWidth || jpgHeight)
				dispatchEvent(new Event(PARSE_FAILED));
		}
		
		public function extractSize(fileURL:String, stopWhenParsed:Boolean=true):void
		{
			addEventListener(ProgressEvent.PROGRESS, progressHandler);
			addEventListener(Event.COMPLETE, fileCompleteHandler);
			dataLoaded=0;
			jumpLength=0;
			if (traceDebugInfo)
				trace("Started loading '" + fileURL + "'");
			stopWhenParseComplete=stopWhenParsed;
			super.load(new URLRequest(fileURL));
		}
		
		public function get loaded():uint
		{
			return dataLoaded;
		}
		
		public function get width():uint
		{
			return jpgWidth;
		}
		
		public function get height():uint
		{
			return jpgHeight;
		}
		
		public function set debug(newDebug:Boolean):void
		{
			traceDebugInfo=newDebug;
		}
		
		public function get debug():Boolean
		{
			return traceDebugInfo;
		}
	}
}
