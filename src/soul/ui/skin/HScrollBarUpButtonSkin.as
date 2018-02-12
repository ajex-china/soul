package soul.ui.skin
{
	import soul.ui.BaseButton;
	import soul.ui.UIComponent;
	
	import flash.display.DisplayObject;
	
	public class HScrollBarUpButtonSkin extends Skin
	{
		private var _ui:BaseButton;
		public function HScrollBarUpButtonSkin(ui:UIComponent)
		{
			if(!(ui is BaseButton)) return;
			_ui = ui as BaseButton;
			_ui.normalOverSkin = resource.getClassObject("HScrollArrowUp_overSkin") as DisplayObject;
			_ui.normalDownSkin = resource.getClassObject("HScrollArrowUp_downSkin") as DisplayObject;
			_ui.normalUpSkin = resource.getClassObject("HScrollArrowUp_upSkin") as DisplayObject;
			_ui.normalDisabledSkin = resource.getClassObject("HScrollArrowUp_disabledSkin") as DisplayObject;
			_ui.selectOverSkin = resource.getClassObject("HScrollArrowUp_overSkin") as DisplayObject;
			_ui.selectDownSkin = resource.getClassObject("HScrollArrowUp_downSkin") as DisplayObject;
			_ui.selectUpSkin = resource.getClassObject("HScrollArrowUp_upSkin") as DisplayObject;
			_ui.selectDisabledSkin = resource.getClassObject("HScrollArrowUp_disabledSkin") as DisplayObject;
		}
	}
}