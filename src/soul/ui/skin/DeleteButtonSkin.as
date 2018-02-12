package soul.ui.skin
{
	import soul.ui.BaseButton;
	import soul.ui.UIComponent;
	
	import flash.display.DisplayObject;
	
	public class DeleteButtonSkin extends Skin
	{
		private var _ui:BaseButton;
		public function DeleteButtonSkin(ui:UIComponent=null)
		{
			super(ui)
			if(!(ui is BaseButton)) return;
			_ui = ui as BaseButton;
			_ui.normalOverSkin = resource.getClassObject("deleteButton_overSkin") as DisplayObject;
			_ui.normalDownSkin = resource.getClassObject("deleteButton_overSkin") as DisplayObject;
			_ui.normalUpSkin = resource.getClassObject("deleteButton_upSkin") as DisplayObject;
			_ui.normalDisabledSkin = resource.getClassObject("deleteButton_upSkin") as DisplayObject;
			_ui.selectOverSkin = resource.getClassObject("deleteButton_overSkin") as DisplayObject;
			_ui.selectDownSkin = resource.getClassObject("deleteButton_overSkin") as DisplayObject;
			_ui.selectUpSkin = resource.getClassObject("deleteButton_upSkin") as DisplayObject;
			_ui.selectDisabledSkin = resource.getClassObject("deleteButton_upSkin") as DisplayObject;
		}
	}
}