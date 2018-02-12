package soul.ui.skin
{
	import soul.ui.BaseButton;
	import soul.ui.UIComponent;
	
	import flash.display.DisplayObject;
	
	public class HSilderButtonSkin extends Skin
	{
		private var _ui:BaseButton;
		public function HSilderButtonSkin(ui:UIComponent=null)
		{
			super(ui);
			if(!(ui is BaseButton)) return;
			_ui = ui as BaseButton;
			_ui.normalOverSkin = resource.getClassObject("HSliderThumb_overSkin") as DisplayObject;
			_ui.normalDownSkin = resource.getClassObject("HSliderThumb_downSkin") as DisplayObject;
			_ui.normalUpSkin = resource.getClassObject("HSliderThumb_upSkin") as DisplayObject;
			_ui.normalDisabledSkin = resource.getClassObject("HSliderThumb_disabledSkin") as DisplayObject;
			_ui.selectOverSkin = resource.getClassObject("HSliderThumb_overSkin") as DisplayObject;
			_ui.selectDownSkin = resource.getClassObject("HSliderThumb_downSkin") as DisplayObject;
			_ui.selectUpSkin = resource.getClassObject("HSliderThumb_upSkin") as DisplayObject;
			_ui.selectDisabledSkin = resource.getClassObject("HSliderThumb_disabledSkin") as DisplayObject;
		}
	}
}