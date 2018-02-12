package soul.ui.skin
{
	import soul.ui.BaseButton;
	import soul.ui.UIComponent;
	
	import flash.display.DisplayObject;
	
	public class VScrollBarDownButtonSkin extends Skin
	{
		private var _ui:BaseButton;
		public function VScrollBarDownButtonSkin(ui:UIComponent)
		{
			if(!(ui is BaseButton)) return;
			_ui = ui as BaseButton;
			_ui.normalOverSkin = resource.getClassObject("VScrollArrowDown_overSkin") as DisplayObject;
			_ui.normalDownSkin = resource.getClassObject("VScrollArrowDown_downSkin") as DisplayObject;
			_ui.normalUpSkin = resource.getClassObject("VScrollArrowDown_upSkin") as DisplayObject;
			_ui.normalDisabledSkin = resource.getClassObject("VScrollArrowDown_disabledSkin") as DisplayObject;
			_ui.selectOverSkin = resource.getClassObject("VScrollArrowDown_overSkin") as DisplayObject;
			_ui.selectDownSkin = resource.getClassObject("VScrollArrowDown_downSkin") as DisplayObject;
			_ui.selectUpSkin = resource.getClassObject("VScrollArrowDown_upSkin") as DisplayObject;
			_ui.selectDisabledSkin = resource.getClassObject("VScrollArrowDown_disabledSkin") as DisplayObject;
		}
	}
}