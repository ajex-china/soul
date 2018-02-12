package soul.ui.skin
{
	import soul.ui.DrawerChildItemRender;
	import soul.ui.UIComponent;
	
	import flash.display.DisplayObject;
	
	public class DrawerChildItemRenderSkin extends Skin
	{
		private var _ui:DrawerChildItemRender;
		public function DrawerChildItemRenderSkin(ui:UIComponent=null)
		{
			super(ui);
			if(!(ui is DrawerChildItemRender)) return;
			_ui = ui as DrawerChildItemRender;
			_ui.normalOverSkin = resource.getClassObject("DrawerChildRenderer_overSkin") as DisplayObject;
			_ui.normalDownSkin = resource.getClassObject("DrawerChildRenderer_downSkin") as DisplayObject;
			_ui.normalUpSkin = resource.getClassObject("DrawerChildRenderer_upSkin") as DisplayObject;
			_ui.normalDisabledSkin = resource.getClassObject("DrawerChildRenderer_disabledSkin") as DisplayObject;
			_ui.selectOverSkin = resource.getClassObject("DrawerChildRenderer_selectedOverSkin") as DisplayObject;
			_ui.selectDownSkin = resource.getClassObject("DrawerChildRenderer_selectedDownSkin") as DisplayObject;
			_ui.selectUpSkin = resource.getClassObject("DrawerChildRenderer_selectedUpSkin") as DisplayObject;
			_ui.selectDisabledSkin = resource.getClassObject("DrawerChildRenderer_selectedDisabledSkin") as DisplayObject;
		}
	}
}