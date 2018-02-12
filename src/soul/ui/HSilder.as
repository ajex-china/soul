package soul.ui
{
	import soul.ui.skin.HSilderSkin;

	/**
	 *横向滑动条 
	 * @author Ajex
	 * 
	 */	
	public class HSilder extends Silder
	{
		public function HSilder(skin:Class=null)
		{
			super(skin);
		}
		override public function setDefaultSkin():void
		{
			setSkin(HSilderSkin);
		}
		override protected function setStyle():void
		{
			direction = "H";
			setSize(140,15,false);
		}
	}
}