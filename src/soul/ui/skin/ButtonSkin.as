package soul.ui.skin
{
	import soul.ui.BaseButton;
	import soul.ui.UIComponent;
	
	import flash.display.DisplayObject;
	
	public class ButtonSkin extends Skin
	{
		private var _ui:BaseButton;
		public function ButtonSkin(ui:UIComponent)
		{
			super(ui)
			if(!(ui is BaseButton)) return;
			_ui = ui as BaseButton;
			_ui.normalOverSkin = resource.getClassObject("Button_overSkin") as DisplayObject;
			_ui.normalDownSkin = resource.getClassObject("Button_downSkin") as DisplayObject;
			_ui.normalUpSkin = resource.getClassObject("Button_upSkin") as DisplayObject;
			_ui.normalDisabledSkin = resource.getClassObject("Button_disabledSkin") as DisplayObject;
			_ui.selectOverSkin = resource.getClassObject("Button_overSkin") as DisplayObject;
			_ui.selectDownSkin = resource.getClassObject("Button_downSkin") as DisplayObject;
			_ui.selectUpSkin = resource.getClassObject("Button_upSkin") as DisplayObject;
			_ui.selectDisabledSkin = resource.getClassObject("Button_disabledSkin") as DisplayObject;
		}
	}
}