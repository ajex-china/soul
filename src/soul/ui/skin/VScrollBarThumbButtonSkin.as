package soul.ui.skin
{
	import soul.ui.BaseButton;
	import soul.ui.UIComponent;
	
	import flash.display.DisplayObject;
	
	public class VScrollBarThumbButtonSkin extends Skin
	{
		private var _ui:BaseButton;
		public function VScrollBarThumbButtonSkin(ui:UIComponent)
		{
			if(!(ui is BaseButton)) return;
			_ui = ui as BaseButton;
			_ui.normalOverSkin = resource.getClassObject("VScrollThumb_overSkin") as DisplayObject;
			_ui.normalDownSkin = resource.getClassObject("VScrollThumb_downSkin") as DisplayObject;
			_ui.normalUpSkin = resource.getClassObject("VScrollThumb_upSkin") as DisplayObject;
			_ui.normalDisabledSkin = resource.getClassObject("VScrollThumb_upSkin") as DisplayObject;
			_ui.selectOverSkin = resource.getClassObject("VScrollThumb_overSkin") as DisplayObject;
			_ui.selectDownSkin = resource.getClassObject("VScrollThumb_downSkin") as DisplayObject;
			_ui.selectUpSkin = resource.getClassObject("VScrollThumb_upSkin") as DisplayObject;
			_ui.selectDisabledSkin = resource.getClassObject("VScrollThumb_upSkin") as DisplayObject;
		}
	}
}