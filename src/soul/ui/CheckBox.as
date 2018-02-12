package soul.ui
{
	import soul.ui.skin.CheckBoxSkin;
	
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	/**
	 * 复选框组件CheckBox:
	 * @author Ajex
	 * 
	 */
	public class CheckBox extends Button
	{
		public var leftSpace:Number = 2;
		public function CheckBox()
		{
			super();
		}
		override protected function constructor():void
		{
			super.constructor();
			labelUI.text="选 项";
			labelUI.leftMargin = leftSpace + normalUpSkin.width + 5;
			labelUI.align = TextFormatAlign.LEFT;
		}
		override protected function setStyle():void
		{
			setSize(70,22,false);
		}
		
		override public function setDefaultSkin():void
		{
			setSkin(CheckBoxSkin);
		}
		override protected function mouseClickHandler(e:MouseEvent):void
		{
			selected = !selected;
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
	}
}