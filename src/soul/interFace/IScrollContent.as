package soul.interFace
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	
	[Event(name="scroll",type="flash.events.Event")]
	
	/**
	 * 滚动容器接口
	 * @author flashyiyi
	 * 
	 */
	public interface IScrollContent extends IEventDispatcher
	{
		/**
		 * 目标
		 * @return 
		 * 
		 */
		function get content():DisplayObject;
		
		/**
		 * 真实的宽度 
		 * @return 
		 * 
		 */		
		function get realWidth():Number
		
		/**
		 * 真实的高度 
		 * @return 
		 * 
		 */			
		function get realHeight():Number
			
		/**
		 * 最大横向范围
		 * @return 
		 * 
		 */
		function get maxScrollH():int
		/**
		 * 最大纵向范围
		 * @return 
		 * 
		 */
		function get maxScrollV():int
		/**
		 * 横向滚动坐标
		 * @return 
		 * 
		 */
		function get scrollH():int
		function set scrollH(value:int):void
		/**
		 * 纵向滚动坐标
		 * @return 
		 * 
		 */
		function get scrollV():int
		function set scrollV(value:int):void
		
		
		/**
		 * 鼠标滚动方向
		 * @return 
		 * 
		 */
		function get wheelDirect():String
		function set wheelDirect(value:String):void
		
		/**
		 * 鼠标滚动速度
		 * @return 
		 * 
		 */
		function get wheelSpeed():Number
		function set wheelSpeed(value:Number):void
		
//		function addHScrollBar(skin:* = null):void
//		function addVScrollBar(skin:* = null):void
//		function removeHScrollBar():void
//		function removeVScrollBar():void
	}
}