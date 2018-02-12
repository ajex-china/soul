package soul.ui.skin
{
	import soul.ui.BaseButton;
	import soul.ui.ScrollBar;
	import soul.ui.UIComponent;
	import soul.ui.UIEnabledDisplay;
	
	import flash.display.DisplayObject;
	
	public class HScrollBarSkin extends Skin
	{
		private var _ui:ScrollBar;
		public function HScrollBarSkin(ui:UIComponent)
		{
			if(!(ui is ScrollBar)) return;
			_ui = ui as ScrollBar;
			_ui.upArrow = new BaseButton(HScrollBarUpButtonSkin);
			_ui.downArrow = new BaseButton(HScrollBarDownButtonSkin);
			_ui.thumb = new BaseButton(HScrollBarThumbButtonSkin);
			_ui.background = new UIEnabledDisplay(resource.getClassObject("HScrollTrack_skin"));
		}
	}
}