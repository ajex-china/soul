package soul.ui
{
	import soul.ui.skin.HScrollBarSkin;

	/**
	 *横向滚动条 
	 * @author Ajex
	 * 
	 */	
	public class HScrollBar extends ScrollBar
	{
		public function HScrollBar(skin:Class=null)
		{
			super(skin);
		}
		override public function setDefaultSkin():void
		{
			setSkin(HScrollBarSkin);
		}
		override protected function setStyle():void
		{
			//isThumbSize = true;
			direction = "H";
			setSize(320,14,false);
		}
	}
}