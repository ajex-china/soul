package soul.ui.skin
{
	import soul.ui.DrawerParentItemRender;
	import soul.ui.UIComponent;
	
	import flash.display.DisplayObject;
	
	public class DrawerParentItemRenderSkin extends Skin
	{
		private var _ui:DrawerParentItemRender;
		public function DrawerParentItemRenderSkin(ui:UIComponent=null)
		{
			super(ui);
			if(!(ui is DrawerParentItemRender)) return;
			_ui = ui as DrawerParentItemRender;
			_ui.normalOverSkin = resource.getClassObject("DrawerParentRenderer_overSkin") as DisplayObject;
			_ui.normalDownSkin = resource.getClassObject("DrawerParentRenderer_downSkin") as DisplayObject;
			_ui.normalUpSkin = resource.getClassObject("DrawerParentRenderer_upSkin") as DisplayObject;
			_ui.normalDisabledSkin = resource.getClassObject("DrawerParentRenderer_disabledSkin") as DisplayObject;
			_ui.selectOverSkin = resource.getClassObject("DrawerParentRenderer_overSkin") as DisplayObject;
			_ui.selectDownSkin = resource.getClassObject("DrawerParentRenderer_downSkin") as DisplayObject;
			_ui.selectUpSkin = resource.getClassObject("DrawerParentRenderer_upSkin") as DisplayObject;
			_ui.selectDisabledSkin = resource.getClassObject("DrawerParentRenderer_disabledSkin") as DisplayObject;
			_ui.icon_open_skin = resource.getClassObject("openArrow") as DisplayObject;
			_ui.icon_close_skin = resource.getClassObject("closeArrow") as DisplayObject;
			
		}
	}
}