package soul.ui
{
	import soul.ui.skin.VScrollBarSkin;
	/**
	 *纵向滚动条 
	 * @author Ajex
	 * 
	 */	
	public class VScrollBar extends ScrollBar
	{
		public function VScrollBar(skin:Class=null)
		{
			super(skin);
		}
		override public function setDefaultSkin():void
		{
			setSkin(VScrollBarSkin);
		}
		override protected function setStyle():void
		{
			//isThumbSize = true;
			direction = "V";
			setSize(14,320,false);
		}
	}
}