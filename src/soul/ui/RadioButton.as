package soul.ui
{
	import soul.ui.skin.RadioButtonSkin;
	
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	/**
	 *单选框组件 
	 * @author Ajex
	 * 
	 */
	public class RadioButton extends Button
	{
		public var leftSpace:Number = 2;
		private var _groupName:String;
		private var _group:RadioButtonGroup;
		private var _value:Object;
		public function RadioButton()
		{
			super();
		}
		override protected function constructor():void
		{
			super.constructor();
			labelUI.text="选 项";
			labelUI.leftMargin = leftSpace + normalUpSkin.width + 5;
			labelUI.align = TextFormatAlign.LEFT;
			groupName = "defaultRadioButtonGroup";
		}
		override protected function setStyle():void
		{
			setSize(70,22,false);
		}
		
		override public function setDefaultSkin():void
		{
			setSkin(RadioButtonSkin);
		}
		public function get groupName():String
		{
			return _groupName;
		}
		/**
		 * radio集名 
		 * @param value
		 * 
		 */		
		public function set groupName(value:String):void
		{
			_groupName = value;
			if (_group != null) {
				_group.removeRadioButton(this);
			}
			_group = RadioButtonGroup.getGroup(_groupName);
			_group.addRadioButton(this);
		}
		/**
		 * 获得集 
		 * @return 
		 * 
		 */		
		public function get group():RadioButtonGroup {
			return _group;
		}
		override protected function mouseClickHandler(e:MouseEvent):void
		{
			selected = true;
		}
		
		override protected function updateSize():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0x000000,0);
			this.graphics.drawRect(0,0,BaseWidth,BaseHeight);
			this.graphics.endFill();
			
			this.labelUI.width = BaseWidth;
			
			this.normalOverSkin.y = BaseHeight/2 - this.normalOverSkin.height/2;
			this.normalDownSkin.y = BaseHeight/2 - this.normalDownSkin.height/2;
			this.normalUpSkin.y = BaseHeight/2 - this.normalUpSkin.height/2;
			this.normalDisabledSkin.y = BaseHeight/2 - this.normalDisabledSkin.height/2;
			this.selectOverSkin.y = BaseHeight/2 - this.selectOverSkin.height/2;
			this.selectDownSkin.y = BaseHeight/2 - this.selectDownSkin.height/2;
			this.selectUpSkin.y = BaseHeight/2 - this.selectUpSkin.height/2;
			this.selectDisabledSkin.y = BaseHeight/2 - this.selectDisabledSkin.height/2;
			
			updataText();
		}
		override public function destory():void
		{
			super.destory()
			_group.removeRadioButton(this);
			_group = null;
			_value = null;
		}
	}
}