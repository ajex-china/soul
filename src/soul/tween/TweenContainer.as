/**
 *特效切换容器 
 */
package soul.tween
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	import soul.display.BaseSprite;
	import soul.tween.changeFun.AlphaFun;
	import soul.tween.changeFun.ChangeFun;

	public class TweenContainer extends BaseSprite
	{
		public var showFun:ChangeFun;
		
		public var showCls:Class;
		public var showData:Object;
		public var oldDis:DisplayObject;
		public var newDis:DisplayObject;
		public var changeDuration:Number;
		
		
		public var isTween:Boolean;
		
		/**
		 * 缓动展示对象 
		 * @param dis 展示对象
		 * @param cls 展示方式
		 * @param data 展示数据
		 * 
		 */		
		public function showDis(dis:DisplayObject,cls:Class  = null,data:Object = null):void
		{
			if(newDis == dis) return;
			if(isTween) showFun.complete();
			showCls = cls;
			if(!showCls) showCls = AlphaFun;
			showData = data;
			showFun = new showCls(this);
			var delay:int = 1;
			if(data)
			{
				if(data.delay)
				{
					delay = data.delay
				}
			}
			showFun.change(dis,delay,data);
		}

	}
}