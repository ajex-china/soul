package soul.ui.skin
{
	import soul.ui.BaseButton;
	import soul.ui.UIComponent;
	
	import flash.display.DisplayObject;

	public class VScrollBarUpButtonSkin extends Skin
	{
		private var _ui:BaseButton;
		public function VScrollBarUpButtonSkin(ui:UIComponent)
		{
			if(!(ui is BaseButton)) return;
			_ui = ui as BaseButton;
			_ui.normalOverSkin = resource.getClassObject("VScrollArrowUp_overSkin") as DisplayObject;
			_ui.normalDownSkin = resource.getClassObject("VScrollArrowUp_downSkin") as DisplayObject;
			_ui.normalUpSkin = resource.getClassObject("VScrollArrowUp_upSkin") as DisplayObject;
			_ui.normalDisabledSkin = resource.getClassObject("VScrollArrowUp_disabledSkin") as DisplayObject;
			_ui.selectOverSkin = resource.getClassObject("VScrollArrowUp_overSkin") as DisplayObject;
			_ui.selectDownSkin = resource.getClassObject("VScrollArrowUp_downSkin") as DisplayObject;
			_ui.selectUpSkin = resource.getClassObject("VScrollArrowUp_upSkin") as DisplayObject;
			_ui.selectDisabledSkin = resource.getClassObject("VScrollArrowUp_disabledSkin") as DisplayObject;
		}
	}
}