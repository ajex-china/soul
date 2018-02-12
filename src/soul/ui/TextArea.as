package soul.ui
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormatAlign;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import soul.display.BaseText;
	import soul.interFace.IScrollContent;
	import soul.ui.skin.TextAreaSkin;
	
	[Event(name="scroll",type="flash.events.Event")]
	/**
	 *文本区域组件 
	 * @author Ajex
	 * 
	 */	
	public class TextArea extends TextInput implements IScrollContent
	{
		/**
		 * 横向滚动条
		 */
		public var hScrollBar:HScrollBar;
		
		/**
		 * 纵向滚动条
		 */
		public var vScrollBar:VScrollBar;
		
		/**
		 *添加文字的时候是否自动滚动到最底
		 */		
		public var autoScrollMax:Boolean = true;
		
		private var _autoUpdateScroll:Boolean;
		
		
		private var _wheelSpeed:Number = 1.0;
		private var _wheelDirect:String = "V";
		
		private var _intervalID:uint;
		public var intervalTime:Number = 500;
		public function TextArea(skin:Class=null)
		{
			super(skin);
		}
		override protected function constructor():void
		{
			super.constructor();
			if(hScrollBar) 
			{
				hScrollBar.target = baseText;
				hScrollBar.detra = 1;
				hScrollBar.isTween = false;
				this.addChild(hScrollBar);
			}
			if(vScrollBar)
			{
				vScrollBar.target = baseText;
				vScrollBar.detra = 1;
				vScrollBar.isTween = false;
				this.addChild(vScrollBar);
			}
			baseText.addEventListener(Event.SCROLL,scrollHandler);
		}
		override protected function init():void
		{
			super.init();
			autoUpdateScroll = true;
		}
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			if(hScrollBar) 
			{
				hScrollBar.enabled = value;
			}
			if(vScrollBar)
			{
				vScrollBar.enabled = value;
			}
		}
		
		protected var oldRealWidth:Number;
		protected var oldRealHeight:Number;
		protected function intervalHandler():void
		{
			if(vScrollBar)
			{
				if(vScrollBar.isDrag) return;
			}
			if(hScrollBar)
			{
				if(hScrollBar.isDrag) return;
			}
			if(oldRealWidth == realWidth && oldRealHeight == realHeight) return;
			oldRealWidth = realWidth;
			oldRealHeight = realHeight;
			updateDisplayList();
		}
		public function get autoUpdateScroll():Boolean
		{
			return _autoUpdateScroll;
		}
		/**
		 * 是否自动更新scroll 
		 * @param value
		 * 
		 */		
		public function set autoUpdateScroll(value:Boolean):void
		{
			if(_autoUpdateScroll == value) return;
			_autoUpdateScroll = value;
			if(_autoUpdateScroll)
			{
				_intervalID = setInterval(intervalHandler,intervalTime);
			}
			else
			{
				clearInterval(_intervalID);
			}
		}
		override protected function setStyle():void
		{
			baseText.type = TextFieldType.INPUT;
			baseText.align = TextFormatAlign.LEFT;
			baseText.autoSize = TextFieldAutoSize.NONE;
			baseText.color = defaultFontColor;
			baseText.wordWrap = true;
			baseText.multiline = true;
			text = "";
			setSize(150,120,false);
		}
		override public function setDefaultSkin():void
		{
			setSkin(TextAreaSkin);
		}
		override protected function inputHandler(e:TextEvent):void
		{
			invalidateSize();
			super.inputHandler(e);
		}
		private function scrollHandler(event:Event):void
		{
			dispatchEvent(event);
		}
		/**
		 * 获得文本实例 
		 * @return 
		 * 
		 */		
		public function get content():DisplayObject
		{
			return baseText;
		}
		public function get maxScrollH():int
		{
			return baseText.maxScrollH;;
		}
		
		public function get maxScrollV():int
		{
			return baseText.maxScrollV - 1;
		}
		
		public function get scrollH():int
		{
			return baseText.scrollH;
		}
		
		public function set scrollH(v:int):void
		{
			baseText.scrollH = v;
		}
		
		public function get scrollV():int
		{
			return baseText.scrollV - 1;
		}
		
		public function set scrollV(v:int):void
		{
			baseText.scrollV = v + 1;
		}
		
		public function get wheelDirect():String
		{
			return _wheelDirect;
		}
		
		public function set wheelDirect(v:String):void
		{
			_wheelDirect = v;
		}
		
		public function get wheelSpeed():Number
		{
			return _wheelSpeed;
		}
		
		public function set wheelSpeed(v:Number):void
		{
			_wheelSpeed = v;
		}
		public function get realWidth():Number
		{
			return baseText.textWidth + 4;
		}
		
		public function get realHeight():Number
		{
			return baseText.textHeight + 4;
		}
		public override function set text(value:String):void
		{
			super.text = value;
			if(autoScrollMax)
			{
				this.scrollV = this.maxScrollV;
			}
		}
		public override function set htmlText(value:String):void
		{
			super.htmlText = value;
			if(autoScrollMax)
			{
				this.scrollV = this.maxScrollV;
			}
		}
		protected override function updateSize():void
		{
			var scrWidth:Number = BaseWidth - (vScrollBar?(BaseHeight<realHeight?vScrollBar.width:0):0);
			var scrHeight:Number = BaseHeight - (hScrollBar?(BaseWidth<realWidth?hScrollBar.height:0):0);
			
			baseText.width = scrWidth;
			baseText.height = scrHeight;
			
			normalSkin.width = scrWidth;
			normalSkin.height = scrHeight;
			
			disabledSkin.width = scrWidth;
			disabledSkin.height = scrHeight;
			
			if (hScrollBar)
			{
				hScrollBar.x = 0;
				hScrollBar.y = BaseHeight - hScrollBar.height;
				hScrollBar.width = scrWidth;
				hScrollBar.vaildNow();
			}
			
			if (vScrollBar)
			{
				vScrollBar.y = 0;
				vScrollBar.x = BaseWidth - vScrollBar.width;
				vScrollBar.height = scrHeight;
				vScrollBar.vaildNow();
			}
		}
		protected override function updateDisplayList():void
		{
			if (hScrollBar)
			{
				hScrollBar.vaildDisplayList();
			}
			if (vScrollBar)
			{
				vScrollBar.vaildDisplayList();
			}
		}
		
		public override function destory():void
		{
			baseText.removeEventListener(Event.SCROLL,scrollHandler);
			autoUpdateScroll = false;
			if (hScrollBar)
				hScrollBar.destory();
			
			if (vScrollBar)
				vScrollBar.destory();
			
			super.destory();
		}


	}
}