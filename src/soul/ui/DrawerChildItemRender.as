package soul.ui
{
	import soul.ui.skin.DrawerChildItemRenderSkin;
	import soul.utils.Util;
	/**
	 *抽屉组件的子项呈示器 
	 * @author Ajex
	 * 
	 */
	public class DrawerChildItemRender extends ListItemRender
	{
		public function DrawerChildItemRender()
		{
			super();
		}
		override public function setDefaultSkin():void
		{
			setSkin(DrawerChildItemRenderSkin);
		}
	}
}