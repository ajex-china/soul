package soul.ui.skin
{
	import soul.ui.ListItemRender;
	import soul.ui.UIComponent;
	
	import flash.display.DisplayObject;
	
	public class ListItemRenderSkin extends Skin
	{
		private var _ui:ListItemRender;
		public function ListItemRenderSkin(ui:UIComponent)
		{
			if(!(ui is ListItemRender)) return;
			_ui = ui as ListItemRender;
			_ui.normalOverSkin = resource.getClassObject("CellRenderer_overSkin") as DisplayObject;
			_ui.normalDownSkin = resource.getClassObject("CellRenderer_downSkin") as DisplayObject;
			_ui.normalUpSkin = resource.getClassObject("CellRenderer_upSkin") as DisplayObject;
			_ui.normalDisabledSkin = resource.getClassObject("CellRenderer_disabledSkin") as DisplayObject;
			_ui.selectOverSkin = resource.getClassObject("CellRenderer_selectedOverSkin") as DisplayObject;
			_ui.selectDownSkin = resource.getClassObject("CellRenderer_selectedDownSkin") as DisplayObject;
			_ui.selectUpSkin = resource.getClassObject("CellRenderer_selectedUpSkin") as DisplayObject;
			_ui.selectDisabledSkin = resource.getClassObject("CellRenderer_selectedDisabledSkin") as DisplayObject;
		}
	}
}