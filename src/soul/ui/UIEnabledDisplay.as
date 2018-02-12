package soul.ui
{
	import flash.display.DisplayObject;

	/**
	 *  负责用来显示skin Enabled 状态的基类
	 * @author Ajex
	 * 
	 */	
	public class UIEnabledDisplay extends UIComponent
	{
		
		protected var normalSkin:DisplayObject;
		protected var disabledSkin:DisplayObject;
		public function UIEnabledDisplay(normalSkin:DisplayObject,disabledSkin:DisplayObject=null)
		{
			this.normalSkin = normalSkin;
			this.disabledSkin = disabledSkin;
			if(this.normalSkin) this.addChild(this.normalSkin);
		}
		override public function set enabled(v:Boolean):void
		{
			if(super.enabled == v) return;
			if(!normalSkin||!disabledSkin) return;
			
			if(normalSkin.parent) normalSkin.parent.removeChild(normalSkin);
			if(disabledSkin.parent) disabledSkin.parent.removeChild(disabledSkin);
			if(v)
			{
				this.addChild(this.normalSkin);
			}
			else
			{
				this.addChild(this.disabledSkin);
			}
			super.enabled = v;
		}
		override public function destory():void
		{
			super.destory();
			this.removeAllChildren();
			normalSkin = null;
			disabledSkin = null;
		}
		override protected function updateSize():void
		{
			if(normalSkin)
			{
				normalSkin.width = BaseWidth
				normalSkin.height = BaseHeight;
			}
			if(disabledSkin)
			{
				disabledSkin.width = BaseWidth;
				disabledSkin.height = BaseHeight;
			}
		}
	}
}