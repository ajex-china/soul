package soul.ui
{
	import soul.display.BaseText;
	
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	/**
	 * 按钮组件:
	 * 如果不需要用到文本的按钮请使用BaseButton 
	 * @author Ajex
	 * 
	 */
	public class Button extends BaseButton
	{
		
		public var selectDownFontColor:uint = 0x000000;
		public var selectOverFontColor:uint = 0x000000;
		public var selectUpFontColor:uint = 0x000000;
		public var selectDisabledFontColor:uint = 0x999999;
		public var normalDownFontColor:uint = 0x000000;
		public var normalOverFontColor:uint = 0x000000;
		public var normalUpFontColor:uint = 0x000000;
		public var normalDisabledFontColor:uint = 0x999999;
		
		private var _label:String="按 钮";
		public var labelUI:BaseText;
		public function Button(skin:Class=null)
		{
			super(skin);
		}
		override protected function constructor():void
		{
			super.constructor();
			labelUI = new BaseText();
			labelUI.text=_label;
			labelUI.align = TextFormatAlign.CENTER;
			labelUI.autoSize = TextFieldAutoSize.NONE;
			labelUI.mouseEnabled = false;
			labelUI.color = normalUpFontColor;
			this.addChild(labelUI);
		}
		override protected function setStyle():void
		{
			setSize(82,22,false);
		}
		override protected function mouseOverHandler(e:MouseEvent):void
		{
			super.mouseOverHandler(e);
			labelUI.color = selected?selectOverFontColor:normalOverFontColor;
		}
		override protected function mouseOutHandler(e:MouseEvent):void
		{
			super.mouseOutHandler(e);
			labelUI.color = selected?selectUpFontColor:normalUpFontColor;
		}
		override protected function mouseDownHandler(e:MouseEvent):void
		{
			super.mouseDownHandler(e);
			labelUI.color = selected?selectDownFontColor:normalDownFontColor;
		}
		override protected function mouseUpHandler(e:MouseEvent):void
		{
			super.mouseUpHandler(e);
			labelUI.color = selected?selectOverFontColor:normalOverFontColor;
		}
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			if(value)
			{
				labelUI.color = selected?selectUpFontColor:normalUpFontColor;
			}
			else
			{
				labelUI.color =  selected?selectDisabledFontColor:normalDisabledFontColor;
			}
		}
		
		override public function set selected(value:Boolean):void
		{
			if(enabled == false) return;
			super.selected = value
			labelUI.color = selected?selectUpFontColor:normalUpFontColor;
		}
		
		public function get FontSize():int
		{
			return labelUI.size;
		}
		/**
		 *字体大小 
		 * @param value
		 * 
		 */		
		public function set FontSize(value:int):void
		{
			labelUI.size = value;
			updataText();
		}
		public function get label():String
		{
			return _label;
		}
		/**
		 * 按鈕文字 
		 * @param value
		 * 
		 */		
		public function set label(value:String):void
		{
			_label = value;
			if(!labelUI) return;
			labelUI.text = value;
			updataText();
		}
		override protected function updateSize():void
		{
			super.updateSize();
			updataText();
		}
		protected function updataText():void
		{
			labelUI.width = BaseWidth;
			labelUI.height = labelUI.textHeight + 5;
			if(labelUI.height > BaseHeight) labelUI.height = BaseHeight;
			labelUI.y = BaseHeight/2 - labelUI.height/2;
			labelUI.color = normalUpFontColor;
		}
		override public function destory():void
		{
			super.destory();
			labelUI = null;
		}
	}
}