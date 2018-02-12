package soul.ui.skin
{
	import soul.ui.RadioButton;
	import soul.ui.UIComponent;
	
	import flash.display.DisplayObject;
	
	public class RadioButtonSkin extends Skin
	{
		private var _ui:RadioButton
		public function RadioButtonSkin(ui:UIComponent)
		{
			if(!(ui is RadioButton)) return;
			_ui = ui as RadioButton;
			_ui.normalOverSkin = resource.getClassObject("RadioButton_overIcon") as DisplayObject;
			_ui.normalDownSkin = resource.getClassObject("RadioButton_downIcon") as DisplayObject;
			_ui.normalUpSkin = resource.getClassObject("RadioButton_upIcon") as DisplayObject;
			_ui.normalDisabledSkin = resource.getClassObject("RadioButton_disabledIcon") as DisplayObject;
			_ui.selectOverSkin = resource.getClassObject("RadioButton_selectedOverIcon") as DisplayObject;
			_ui.selectDownSkin = resource.getClassObject("RadioButton_selectedDownIcon") as DisplayObject;
			_ui.selectUpSkin = resource.getClassObject("RadioButton_selectedUpIcon") as DisplayObject;
			_ui.selectDisabledSkin = resource.getClassObject("RadioButton_selectedDisabledIcon") as DisplayObject;
			
			_ui.normalOverSkin.x = _ui.leftSpace;
			_ui.normalDownSkin.x = _ui.leftSpace;
			_ui.normalUpSkin.x = _ui.leftSpace;
			_ui.normalDisabledSkin.x = _ui.leftSpace;
			_ui.selectOverSkin.x = _ui.leftSpace;
			_ui.selectDownSkin.x = _ui.leftSpace;
			_ui.selectUpSkin.x = _ui.leftSpace;
			_ui.selectDisabledSkin.x = _ui.leftSpace;
		}
	}
}