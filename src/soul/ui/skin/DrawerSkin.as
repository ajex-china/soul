package soul.ui.skin
{
	import soul.ui.HScrollBar;
	import soul.ui.Drawer;
	import soul.ui.UIComponent;
	import soul.ui.VScrollBar;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public class DrawerSkin extends Skin
	{
		private var _ui:Drawer;
		public function DrawerSkin(ui:UIComponent)
		{
			super(ui);
			if(!(ui is Drawer)) return;
			_ui = ui as Drawer;
			_ui.vScrollBar = new VScrollBar();
			//_ui.hScrollBar = new HScrollBar();
			_ui.background = resource.getClassObject("Drawer_skin") as DisplayObject;
		}
	}
}