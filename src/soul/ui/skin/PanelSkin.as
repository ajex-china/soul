package soul.ui.skin
{
	import soul.ui.BaseButton;
	import soul.ui.Panel;
	import soul.ui.UIComponent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class PanelSkin extends Skin
	{
		private var _ui:Panel;
		public function PanelSkin(ui:UIComponent=null)
		{
			super(ui);
			if(!(ui is Panel)) return;
			_ui = ui as Panel;
			_ui.topSkin =  resource.getClassObject("panel_topSkin") as DisplayObject;
			_ui.backgroudSkin = resource.getClassObject("panel_Skin") as DisplayObject;
			_ui.exitButton = new BaseButton(DeleteButtonSkin);
			_ui.exitButton.y = 10;
			_ui.exitButton.buttonMode = true;
		}
	}
}