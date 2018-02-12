package soul.ui.skin
{
	import soul.ui.UIComponent;
	import soul.manager.ResourceManager;
	
	import flash.display.DisplayObject;

	public class Skin
	{
		public var resource:ResourceManager = ResourceManager.getInstance();
		private var _ui:UIComponent;
		public function Skin(ui:UIComponent=null)
		{
			_ui = ui;
		}
	}
}