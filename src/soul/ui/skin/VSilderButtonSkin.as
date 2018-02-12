package soul.ui.skin
{
	import soul.ui.BaseButton;
	import soul.ui.UIComponent;
	
	import flash.display.DisplayObject;
	
	public class VSilderButtonSkin extends Skin
	{
		private var _ui:BaseButton;
		public function VSilderButtonSkin(ui:UIComponent=null)
		{
			super(ui);
			if(!(ui is BaseButton)) return;
			_ui = ui as BaseButton;
			_ui.normalOverSkin = resource.getClassObject("VSliderThumb_overSkin") as DisplayObject;
			_ui.normalDownSkin = resource.getClassObject("VSliderThumb_downSkin") as DisplayObject;
			_ui.normalUpSkin = resource.getClassObject("VSliderThumb_upSkin") as DisplayObject;
			_ui.normalDisabledSkin = resource.getClassObject("VSliderThumb_disabledSkin") as DisplayObject;
			_ui.selectOverSkin = resource.getClassObject("VSliderThumb_overSkin") as DisplayObject;
			_ui.selectDownSkin = resource.getClassObject("VSliderThumb_downSkin") as DisplayObject;
			_ui.selectUpSkin = resource.getClassObject("VSliderThumb_upSkin") as DisplayObject;
			_ui.selectDisabledSkin = resource.getClassObject("VSliderThumb_disabledSkin") as DisplayObject;
		}
	}
}