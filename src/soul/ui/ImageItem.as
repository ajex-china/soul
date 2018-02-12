package soul.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import soul.debug.AS3Debugger;
	import soul.events.LoadingEvent;
	import soul.manager.ResourceManager;
	import soul.manager.SingleLoadManager;
	
	/**
	 *位图组件 
	 * @author Ajex
	 * 
	 */	
	public class ImageItem extends Canvas
	{
		private var _source:String;
		protected var bitmap:Bitmap = new Bitmap();
		public var loadingDisplayObject:DisplayObject;
		private var _bitmapWidth:Number;
		private var _bitmapHeight:Number;
		public function ImageItem()
		{
			super();
		}
		public function get source():String
		{
			return _source;
		}
		
		public function set source(value:String):void
		{
			if(_source) 
			{
				SingleLoadManager.getInstance().unload(_source);
			}
			bitmap.bitmapData = null;
			_source = value;
			ResourceManager.getInstance().removeResouce(source);
			this.addEventListener(LoadingEvent.SINGLE_LOAD_COMPLETE,loadCompleteHandler);
			SingleLoadManager.getInstance().load(this,_source,0,null);
			if(loadingDisplayObject) this.addChild(loadingDisplayObject);
		}
		public function setBitmap(bitmap:Bitmap):void
		{
			if(!bitmap)
			{
				AS3Debugger.Trace("imageItem设置的图片不存在")
				return;
			}
			bitmap.bitmapData = bitmap.bitmapData;
		}
		public function getBitmap():Bitmap
		{
			return bitmap;
		}
		protected function loadCompleteHandler(e:LoadingEvent):void
		{
			this.removeEventListener(LoadingEvent.SINGLE_LOAD_COMPLETE,loadCompleteHandler);
			if(!ResourceManager.getInstance().getResouce(_source)) return;
			bitmap.bitmapData = (ResourceManager.getInstance().getResouce(_source) as Bitmap).bitmapData;
			if(loadingDisplayObject)
			{
				if(this.contains(loadingDisplayObject))
				{
					this.removeChild(loadingDisplayObject);
				}
			}
			if(!isNaN(_bitmapWidth)) 
			{
				bitmap.width = _bitmapWidth;
			}
			if(!isNaN(_bitmapHeight)) 
			{
				bitmap.height = _bitmapHeight;
			}
			if(!isSetW)
			{
				this.width = bitmap.width;
			}
			if(!isSetH)
			{
				this.height = bitmap.height;
			}
			if(!isSetW||!isSetH)
			{
				vaildNow();
			}
			this.addChild(bitmap);
			this.dispatchEvent(new Event(Event.COMPLETE));
			
		}
		protected var isSetW:Boolean = false;
		protected var isSetH:Boolean = false
		override public function set width(value:Number):void
		{
			isSetW = true;
			super.width = value;
		}
		override public function set height(value:Number):void
		{
			isSetH = true;
			super.height = value;
		}
		
		public function get bitmapWidth():Number
		{
			return _bitmapWidth;
		}
		/**
		 *设置图片宽
		 * @param value
		 * 
		 */		
		public function set bitmapWidth(value:Number):void
		{
			_bitmapWidth = value;
			bitmap.width = _bitmapWidth;
		}
		
		public function get bitmapHeight():Number
		{
			return _bitmapHeight;
		}
		/**
		 *设置图片高 
		 * @param value
		 * 
		 */		
		public function set bitmapHeight(value:Number):void
		{
			_bitmapHeight = value;
			bitmap.height = _bitmapHeight;
		}
		
		
	}
}