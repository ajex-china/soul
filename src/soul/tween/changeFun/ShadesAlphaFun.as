package soul.tween.changeFun
{
	import soul.tween.TweenContainer;
	import soul.tween.TweenLite;
	import soul.tween.TweenMax;
	import soul.utils.ArrayUtil;
	import soul.utils.Util;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class ShadesAlphaFun extends ChangeFun
	{
		protected var color:uint = 0xffffff;
		protected var count:int = 10;
		protected var arrow:String="right";
		protected var bitmapList:Array;
		protected var bitmap:Bitmap = new Bitmap();
		protected var smoothing:Boolean = false;
		public function ShadesAlphaFun(container:TweenContainer)
		{
			super(container);
		}
		override protected function hideHandler():void
		{
			if(tweenContainer.showData)
			{
				if(tweenContainer.showData.color)
				{
					color = tweenContainer.showData.color;
				}
				if(tweenContainer.showData.count)
				{
					count = tweenContainer.showData.count;
				}
				if(tweenContainer.showData.arrow)
				{
					arrow = tweenContainer.showData.arrow;
				}
				if(tweenContainer.showData.smoothing)
				{
					smoothing = tweenContainer.showData.smoothing;
				}
			}
			
			
			if(tweenContainer.oldDis)
			{
				TweenLite.delayedCall(tweenContainer.changeDuration,hideComplete)
			}
			showHandler();
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
			var bitData:BitmapData = new BitmapData(tweenContainer.newDis.width,tweenContainer.newDis.height,true,0);
			bitData.draw(tweenContainer.newDis);
			bitmap.bitmapData = bitData;
			
			if(arrow == "left"||arrow=="right")
			{
				bitmapList = Util.copyPixel(bitmap.bitmapData,count,1);
			}
			else
			{
				bitmapList = Util.copyPixel(bitmap.bitmapData,1,count);
			}
			
			var i:int = 0
			for(i = 0; i < bitmapList.length;i++)
			{
				bitmapList[i].width += 0.1;//防止计算中出现小数而有缝隙
				bitmapList[i].height += 0.1;//防止计算中出现小数而有缝隙
				bitmapList[i].smoothing = smoothing;
				TweenMax.to(bitmapList[i],0,{colorTransform:{tint:color, tintAmount:1},alpha:0});
				tweenContainer.addChild(bitmapList[i]);
				if(arrow == "left"||arrow=="right")
				{
					bitmapList[i].x = tweenContainer.newDis.x + i%count * (Math.round(tweenContainer.newDis.width/count));
				}
				else
				{
					bitmapList[i].y = tweenContainer.newDis.y + i%count * (Math.round(tweenContainer.newDis.height/count));
				}
				
			}
			for(i = 0; i < bitmapList.length;i++)
			{
				var delayNum:Number = 0;
				if(arrow=="right"||arrow=="down")
				{
					delayNum= tweenContainer.changeDuration/2/bitmapList.length*i;
				}
				else
				{
					delayNum= tweenContainer.changeDuration/2/bitmapList.length*(bitmapList.length-i - 1);
				}
				TweenMax.to(bitmapList[i],tweenContainer.changeDuration/2,{colorTransform:{tint:color, tintAmount:0},alpha:1,delay:delayNum})
			}
			TweenLite.delayedCall(tweenContainer.changeDuration+0.1,showComplete);
		}
		protected function showComplete():void
		{
			tweenContainer.addChild(tweenContainer.newDis);
			complete();
		}
		override protected function killTween():void
		{
			TweenLite.killDelayedCallsTo(showComplete);
			TweenLite.killDelayedCallsTo(hideComplete)
			delBitmap();
		}
		protected function delBitmap():void
		{
			bitmap.bitmapData = null;
			if(bitmapList)
			{
				var i:int = 0;
				for(i = 0; i < bitmapList.length;i++)
				{
					TweenMax.killTweensOf(bitmapList[i]);
					if(bitmapList[i].parent)
					{
						bitmapList[i].parent.removeChild(bitmapList[i])
					}
				}
			}
			bitmapList = null;
		}
	}
}