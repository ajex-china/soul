/**
 *淡入淡出方法 hideX hideY为旧对象的隐藏方位 showX showY为新对象的显示方位 
 */
package soul.tween.changeFun
{
	import soul.tween.TweenContainer;
	import soul.tween.TweenLite;
	import soul.tween.easing.Back;
	
	public class MoveAlphaFun extends ChangeFun
	{
		protected var oldX:Number;
		protected var oldY:Number;
		public function MoveAlphaFun(container:TweenContainer)
		{
			super(container);
		}
		override protected function hideHandler():void
		{
			oldX = tweenContainer.newDis.x;
			oldY = tweenContainer.newDis.y;
			if(tweenContainer.oldDis)
			{
				tweenContainer.oldDis.alpha = 1;
				TweenLite.to(tweenContainer.oldDis,tweenContainer.changeDuration,{alpha:0,x:tweenContainer.showData.hideX,y:tweenContainer.showData.hideY,onComplete:hideComplete});
			}
			else
			{
				hideComplete();
			}
		}
		protected function hideComplete():void
		{
			if(tweenContainer.oldDis)
			{
				tweenContainer.oldDis.x = oldX;
				tweenContainer.oldDis.y = oldY;
			}
			showHandler();
			if(tweenContainer.oldDis)
			{
				if(tweenContainer.oldDis.parent) tweenContainer.oldDis.parent.removeChild(tweenContainer.oldDis);
			}
			
		}
		override protected function showHandler():void
		{
			tweenContainer.addChild(tweenContainer.newDis);
			tweenContainer.newDis.alpha = 1;
			TweenLite.from(tweenContainer.newDis,tweenContainer.changeDuration,{alpha:0,x:tweenContainer.showData.showX,y:tweenContainer.showData.showY,onComplete:showComplete});
		}
		protected function showComplete():void
		{
			complete();
		}
		override protected function killTween():void
		{
			TweenLite.killTweensOf(tweenContainer.oldDis);
			TweenLite.killTweensOf(tweenContainer.newDis);
			tweenContainer.newDis.alpha = 1;
			tweenContainer.newDis.x = oldX;
			tweenContainer.newDis.y = oldY;
		}
	}
}