package soul.ui
{
	import soul.ui.skin.Skin;
	import soul.utils.Util;
	
	import flash.geom.Rectangle;
	/**
	 *canvas画布组件:
	 * 在flash显示基类的基础上加上了不透明度和固定的大小 
	 * @author Ajex
	 * 
	 */
	public class Canvas extends UIComponent
	{
		public function Canvas(skin:Class=null)
		{
			super(skin);
		}
		override protected function setStyle():void
		{
			setSize(200,200,false);
		}
		protected function drawSize():void
		{
			this.graphics.clear();
			this.graphics.beginFill(0,0);
			this.graphics.drawRect(0,0,width,height);
			this.graphics.endFill();
		}
//		public function get clipContent():Boolean
//		{
//			return _clipContent;
//		}
//		/**
//		 * 是否可以超过边界 
//		 * @param value
//		 * 
//		 */		
//		public function set clipContent(value:Boolean):void
//		{
//			if(_clipContent == value) return;
//			_clipContent = value;
//			if(_clipContent == true)
//			{
//				this.scrollRect = new Rectangle(0,0,BaseWidth,BaseHeight);
//			}
//			else
//			{
//				this.scrollRect = null;
//				
//			}
//			Util.breakScrollRect(this);
//		}
		override protected function updateSize():void
		{
			drawSize();
			if(_clipContent == true) 	
			{
				this.scrollRect = new Rectangle(0,0,BaseWidth,BaseHeight);
				Util.breakScrollRect(this);
			}
		}
	}
}