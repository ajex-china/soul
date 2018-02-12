package soul.ui.skin
{
	import soul.ui.BaseButton;
	import soul.ui.ScrollBar;
	import soul.ui.UIComponent;
	import soul.ui.UIEnabledDisplay;
	
	import flash.display.DisplayObject;
	
	public class VScrollBarSkin extends Skin
	{
		private var _ui:ScrollBar;
		public function VScrollBarSkin(ui:UIComponent)
		{
			if(!(ui is ScrollBar)) return;
			_ui = ui as ScrollBar;
			_ui.upArrow = new BaseButton(VScrollBarUpButtonSkin);
			_ui.downArrow = new BaseButton(VScrollBarDownButtonSkin);
			_ui.thumb = new BaseButton(VScrollBarThumbButtonSkin);
			_ui.background = new UIEnabledDisplay(resource.getClassObject("VScrollTrack_skin"));
		}
	}
}