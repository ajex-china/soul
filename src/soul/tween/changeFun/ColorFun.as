package soul.tween.changeFun
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	
	import soul.FrameworkInfo;
	import soul.tween.TweenContainer;
	import soul.tween.TweenLite;
	import soul.tween.TweenMax;
	import soul.tween.easing.Back;
	
	public class ColorFun extends ChangeFun
	{
		protected var color:uint = 0x000000;
		protected var shape:Shape;
		public function ColorFun(container:TweenContainer)
		{
			super(container);
			shape = new Shape();
		}
		override protected function hideHandler():void
		{
			if(tweenContainer.showData)
			{
				if(tweenContainer.showData.color)
				{
					color = tweenContainer.showData.color;
				}
			}
			
			if(tweenContainer.oldDis)
			{
				shape.graphics.clear();
				shape.graphics.beginFill(color);
				shape.graphics.drawRect(0,0,FrameworkInfo.stage.stageWidth,FrameworkInfo.stage.stageHeight);
				shape.graphics.endFill();
				tweenContainer.addChild(shape);
				shape.alpha = 0;
				TweenLite.to(shape,tweenContainer.changeDuration/2,{alpha:1,onComplete:hideComplete});
//				TweenMax.to(tweenContainer.oldDis,0, {colorMatrixFilter:{colorize:color, amount:0}});
//				TweenMax.to(tweenContainer.oldDis, tweenContainer.changeDuration/2, {colorMatrixFilter:{colorize:color, amount:1},onComplete:hideComplete});
			}
			else
			{
				hideComplete();
			}
		}
		protected function hideComplete():void
		{
			showHandler();
			if(tweenContainer.oldDis)
			{
				if(tweenContainer.oldDis.parent) tweenContainer.oldDis.parent.removeChild(tweenContainer.oldDis);
			}
			
		}
		override protected function showHandler():void
		{
			tweenContainer.addChild(tweenContainer.newDis);
			tweenContainer.addChild(shape);
			TweenLite.to(shape,tweenContainer.changeDuration/2,{alpha:0,onComplete:hideComplete});
//			TweenMax.to(tweenContainer.newDis,0, {colorMatrixFilter:{colorize:color, amount:1}});
//			TweenMax.to(tweenContainer.newDis, tweenContainer.changeDuration/2, {colorMatrixFilter:{colorize:color, amount:0},onComplete:showComplete});
			
		}
		protected function showComplete():void
		{
			if(shape.parent) shape.parent.removeChild(shape);
			complete();
		}
		override protected function killTween():void
		{
			TweenLite.killTweensOf(tweenContainer.oldDis);
			TweenLite.killTweensOf(tweenContainer.newDis);
			if(shape.parent) shape.parent.removeChild(shape);
//			TweenMax.to(tweenContainer.newDis,0, {colorMatrixFilter:{colorize:color, amount:0}});
		}
	}
}