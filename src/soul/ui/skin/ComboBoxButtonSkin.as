package soul.ui.skin
{
	import soul.ui.BaseButton;
	import soul.ui.UIComponent;
	
	import flash.display.DisplayObject;
	
	public class ComboBoxButtonSkin extends Skin
	{
		private var _ui:BaseButton;
		public function ComboBoxButtonSkin(ui:UIComponent)
		{
			super(ui)
			if(!(ui is BaseButton)) return;
			_ui = ui as BaseButton;
			_ui.normalOverSkin = resource.getClassObject("ComboBox_overSkin") as DisplayObject;
			_ui.normalDownSkin = resource.getClassObject("ComboBox_downSkin") as DisplayObject;
			_ui.normalUpSkin = resource.getClassObject("ComboBox_upSkin") as DisplayObject;
			_ui.normalDisabledSkin = resource.getClassObject("ComboBox_disabledSkin") as DisplayObject;
			_ui.selectOverSkin = resource.getClassObject("ComboBox_overSkin") as DisplayObject;
			_ui.selectDownSkin = resource.getClassObject("ComboBox_downSkin") as DisplayObject;
			_ui.selectUpSkin = resource.getClassObject("ComboBox_upSkin") as DisplayObject;
			_ui.selectDisabledSkin = resource.getClassObject("ComboBox_disabledSkin") as DisplayObject;
		}
	}
}