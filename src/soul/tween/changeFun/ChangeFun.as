package soul.tween.changeFun
{
	import soul.tween.TweenContainer;
	
	import flash.display.DisplayObject;

	public class ChangeFun
	{
		protected var completeFunction:Function;
		protected var parameterList:Array;
		protected var tweenContainer:TweenContainer;
		public function ChangeFun(container:TweenContainer)
		{
			tweenContainer = container;
		}
		public function change(dis:DisplayObject,duration:Number = 1,data:Object = null):void
		{
			tweenContainer.newDis = dis;
			tweenContainer.changeDuration = duration;
			tweenContainer.showData = data;
			if(data)
			{
				if(data.onComplete)
				{
					completeFunction = data.onComplete;
				}
				if(data.onCompleteParams)
				{
					parameterList = data.onCompleteParams
				}
			}
			tweenContainer.isTween = true;
			hideHandler();
		}
		protected function hideHandler():void
		{
			
		}
		protected function showHandler():void
		{
			
		}
		protected function killTween():void
		{
			
		}
		public function complete():void
		{
			killTween();
			if(tweenContainer.oldDis)
			{
				if(tweenContainer.oldDis.parent) tweenContainer.oldDis.parent.removeChild(tweenContainer.oldDis);
			}
			tweenContainer.oldDis = tweenContainer.newDis;
			tweenContainer.addChild(tweenContainer.oldDis);
			if(completeFunction!=null)
			{
				completeFunction.apply(this,parameterList);
			}
			tweenContainer.isTween = false;
		}
	}
}