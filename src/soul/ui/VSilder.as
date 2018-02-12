package soul.ui
{
	import soul.ui.skin.VSilderSkin;

	/**
	 *纵向滑动条 
	 * @author Ajex
	 * 
	 */	
	public class VSilder extends Silder
	{
		public function VSilder(skin:Class=null)
		{
			super(skin);
		}
		override public function setDefaultSkin():void
		{
			setSkin(VSilderSkin);
		}
		override protected function setStyle():void
		{
			direction = "V";
			setSize(15,140,false);
		}
	}
}