package soul.ui.skin
{
	import soul.ui.HScrollBar;
	import soul.ui.ScrollContainer;
	import soul.ui.UIComponent;
	import soul.ui.VScrollBar;
	
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class ScrollContainerSkin extends Skin
	{
		private var _ui:ScrollContainer;
		public function ScrollContainerSkin(ui:UIComponent=null)
		{
			if(!(ui is ScrollContainer)) return;
			_ui = ui as ScrollContainer;
			_ui.vScrollBar = new VScrollBar();
			_ui.hScrollBar = new HScrollBar();
		}
	}
}