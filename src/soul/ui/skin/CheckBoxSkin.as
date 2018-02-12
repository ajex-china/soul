package soul.ui.skin
{
	import soul.ui.CheckBox;
	import soul.ui.UIComponent;
	
	import flash.display.DisplayObject;
	
	public class CheckBoxSkin extends Skin
	{
		private var _ui:CheckBox;
		public function CheckBoxSkin(ui:UIComponent)
		{
			super(ui)
			if(!(ui is CheckBox)) return;
			_ui = ui as CheckBox;
			_ui.normalOverSkin = resource.getClassObject("CheckBox_overIcon") as DisplayObject;
			_ui.normalDownSkin = resource.getClassObject("CheckBox_downIcon") as DisplayObject;
			_ui.normalUpSkin = resource.getClassObject("CheckBox_upIcon") as DisplayObject;
			_ui.normalDisabledSkin = resource.getClassObject("CheckBox_disabledIcon") as DisplayObject;
			_ui.selectOverSkin = resource.getClassObject("CheckBox_selectedOverIcon") as DisplayObject;
			_ui.selectDownSkin = resource.getClassObject("CheckBox_selectedDownIcon") as DisplayObject;
			_ui.selectUpSkin = resource.getClassObject("CheckBox_selectedUpIcon") as DisplayObject;
			_ui.selectDisabledSkin = resource.getClassObject("CheckBox_selectedDisabledIcon") as DisplayObject;
			
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