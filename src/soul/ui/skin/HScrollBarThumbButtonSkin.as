package soul.ui.skin
{
	import soul.ui.BaseButton;
	import soul.ui.UIComponent;
	
	import flash.display.DisplayObject;
	
	public class HScrollBarThumbButtonSkin extends Skin
	{
		private var _ui:BaseButton;
		public function HScrollBarThumbButtonSkin(ui:UIComponent)
		{
			if(!(ui is BaseButton)) return;
			_ui = ui as BaseButton;
			_ui.normalOverSkin = resource.getClassObject("HScrollThumb_overSkin") as DisplayObject;
			_ui.normalDownSkin = resource.getClassObject("HScrollThumb_downSkin") as DisplayObject;
			_ui.normalUpSkin = resource.getClassObject("HScrollThumb_upSkin") as DisplayObject;
			_ui.normalDisabledSkin = resource.getClassObject("HScrollThumb_upSkin") as DisplayObject;
			_ui.selectOverSkin = resource.getClassObject("HScrollThumb_overSkin") as DisplayObject;
			_ui.selectDownSkin = resource.getClassObject("HScrollThumb_downSkin") as DisplayObject;
			_ui.selectUpSkin = resource.getClassObject("HScrollThumb_upSkin") as DisplayObject;
			_ui.selectDisabledSkin = resource.getClassObject("HScrollThumb_upSkin") as DisplayObject;
		}
	}
}