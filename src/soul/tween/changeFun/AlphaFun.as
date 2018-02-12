package soul.tween.changeFun
{
	import flash.display.DisplayObject;
	
	import soul.tween.TweenContainer;
	import soul.tween.TweenLite;
	import soul.tween.easing.Back;
	import soul.tween.easing.Linear;

	public class AlphaFun extends ChangeFun
	{
		public function AlphaFun(container:TweenContainer)
		{
			super(container);
		}
		override protected function hideHandler():void
		{
			showHandler();
			if(tweenContainer.oldDis)
			{
				tweenContainer.oldDis.alpha = 1;
				TweenLite.to(tweenContainer.oldDis,tweenContainer.changeDuration,{alpha:0,onComplete:hideComplete,ease:Linear.easeNone});
			}
		}
		protected function hideComplete():void
		{
			if(tweenContainer.oldDis)
			{
				if(tweenContainer.oldDis.parent) tweenContainer.oldDis.parent.removeChild(tweenContainer.oldDis);
			}
		}
		override protected function showHandler():void
		{
			tweenContainer.addChild(tweenContainer.newDis);
			tweenContainer.newDis.alpha = 0;
			TweenLite.to(tweenContainer.newDis,tweenContainer.changeDuration + 0.1,{alpha:1,onComplete:showComplete});
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
		}
	}
}