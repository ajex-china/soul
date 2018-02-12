package soul.ui.skin
{
	import soul.ui.List;
	import soul.ui.ListItemRender;
	import soul.ui.UIComponent;
	import soul.ui.VScrollBar;
	
	import flash.display.DisplayObject;
	
	public class ListSkin extends Skin
	{
		private var _ui:List;
		public function ListSkin(ui:UIComponent)
		{
			super(ui);
			if(!(ui is List)) return;
			_ui = ui as List;
			_ui.vScrollBar = new VScrollBar();
			_ui.background = resource.getClassObject("List_skin") as DisplayObject;
			_ui.itemRender = ListItemRender;
		}
	}
}