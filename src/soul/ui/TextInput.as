package soul.ui
{
	import soul.display.BaseText;
	import soul.ui.skin.TextInputSkin;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.StyleSheet;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormatAlign;

	[Event(name="text_input",type="flash.events.TextEvent")]
	/**
	 *输入框组件 
	 * @author Ajex
	 * 
	 */	
	public class TextInput extends Label
	{
		public var normalSkin:DisplayObject;
		public var disabledSkin:DisplayObject;
		public var backgroundSkin:DisplayObject;
		public var disabledFontColor:uint = 0x999999;
		public var defaultFontColor:uint = 0x000000;
		private var _backgoundVisibled:Boolean;
		
		public function TextInput(skin:Class=null)
		{
			super(skin);
		}
		override protected function constructor():void
		{
			super.constructor();
			text = "";
			backgroundSkin = normalSkin;
			this.addChildAt(backgroundSkin,0);
			baseText.addEventListener(TextEvent.TEXT_INPUT,inputHandler);
		}
		protected function inputHandler(e:TextEvent):void
		{
			this.dispatchEvent(e);
		}
		override protected function setStyle():void
		{
			baseText.type = TextFieldType.INPUT;
			baseText.autoSize = TextFieldAutoSize.NONE;
			baseText.align = TextFormatAlign.LEFT;
			baseText.color = defaultFontColor;
			setSize(100,22,false);
		}
		override public function setDefaultSkin():void
		{
			setSkin(TextInputSkin);
		}
		public function get backgoundVisibled():Boolean
		{
			return _backgoundVisibled;
		}
		/**
		 * 是否显示输入框背景 
		 * @param value
		 * 
		 */		
		public function set backgoundVisibled(value:Boolean):void
		{
			_backgoundVisibled = value;
			normalSkin.visible = value;
			disabledSkin.visible = value;
		}


		override public function set enabled(value:Boolean):void
		{
			if(enabled == value) return;
			super.enabled = value;
			baseText.mouseEnabled = value;
			if(backgroundSkin.parent) backgroundSkin.parent.removeChild(backgroundSkin);
			if(enabled)
			{
				backgroundSkin = normalSkin;
				this.color = defaultFontColor;
			}
			else
			{
				backgroundSkin = disabledSkin;
				this.color = disabledFontColor;
			}
			this.addChildAt(backgroundSkin,0);
		}
		protected override function updateSize():void
		{
			super.updateSize();
			normalSkin.width = BaseWidth;
			normalSkin.height = BaseHeight;
			
			disabledSkin.width = BaseWidth;
			disabledSkin.height = BaseHeight;
		}
		override public function destory():void
		{
			baseText.removeEventListener(TextEvent.TEXT_INPUT,inputHandler);
			super.destory();
			normalSkin = null;
			disabledSkin = null;
			backgroundSkin = null;
		}
	}
}