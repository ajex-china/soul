/**
 *过场时间太短看不出效果 
 */
package soul.tween.changeFun
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import soul.display.BaseSprite;
	import soul.display.ReversalItem;
	import soul.tween.TweenContainer;
	import soul.tween.TweenLite;
	import soul.utils.Util;
	
	public class ShadesReversalFun extends ChangeFun
	{
		protected var count:int = 10;
		protected var arrow:String="right";
		protected var newBitmapList:Array;
		protected var newBitmap:Bitmap = new Bitmap();
		protected var oldBitmapList:Array;
		protected var oldBitmap:Bitmap = new Bitmap();
		protected var itemCon:BaseSprite = new BaseSprite();
		protected var smoothing:Boolean = false;
		public function ShadesReversalFun(container:TweenContainer)
		{
			super(container);
		}
		override protected function hideHandler():void
		{
			if(tweenContainer.showData)
			{
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
				if(tweenContainer.oldDis.parent) tweenContainer.oldDis.parent.removeChild(tweenContainer.oldDis);
			}
			showHandler();
		}
		override protected function showHandler():void
		{
			var bitData:BitmapData = new BitmapData(tweenContainer.newDis.width,tweenContainer.newDis.height,true,0);
			bitData.draw(tweenContainer.newDis);
			newBitmap.bitmapData = bitData;
			
			if(tweenContainer.oldDis)
			{
				bitData = new BitmapData(tweenContainer.oldDis.width,tweenContainer.oldDis.height,true,0);
				bitData.draw(tweenContainer.oldDis);
			}
			else
			{
				bitData = new BitmapData(tweenContainer.newDis.width,tweenContainer.newDis.height,true,0);
			}
			oldBitmap.bitmapData = bitData;
			
			tweenContainer.addChild(itemCon);
			if(arrow == "left"||arrow=="right")
			{
				newBitmapList = Util.copyPixel(newBitmap.bitmapData,count,1);
				oldBitmapList = Util.copyPixel(oldBitmap.bitmapData,count,1);
			}
			else
			{
				newBitmapList = Util.copyPixel(newBitmap.bitmapData,1,count);
				oldBitmapList = Util.copyPixel(oldBitmap.bitmapData,1,count);
			}
			
			var i:int = 0
			for(i = 0; i < newBitmapList.length;i++)
			{
				var item:ReversalItem ;
				oldBitmapList[i].width += 0.1;
				newBitmapList[i].width += 0.1;//防止计算中出现小数而有缝隙			
				oldBitmapList[i].height += 0.1;
				newBitmapList[i].height += 0.1;//防止计算中出现小数而有缝隙	
				oldBitmapList[i].smoothing = smoothing;
				newBitmapList[i].smoothing = smoothing;
				if(arrow == "left"||arrow=="right")
				{
					item = new ReversalItem(oldBitmapList[i],newBitmapList[i],tweenContainer.changeDuration/2,"y");
					item.x = tweenContainer.newDis.x + i%count * (Math.round(tweenContainer.newDis.width/count));
				}
				else
				{
					item = new ReversalItem(oldBitmapList[i],newBitmapList[i],tweenContainer.changeDuration/2,"x");
					item.y = tweenContainer.newDis.y + i%count * (Math.round(tweenContainer.newDis.height/count));
				}
				itemCon.addChild(item);
			}
			for(i = 0; i < newBitmapList.length;i++)
			{
				var delayNum:Number = 0;
				if(arrow=="right"||arrow=="down")
				{
					delayNum= tweenContainer.changeDuration/2/newBitmapList.length*i;
				}
				else
				{
					delayNum= tweenContainer.changeDuration/2/newBitmapList.length*(newBitmapList.length-i - 1);
				}
				
				TweenLite.delayedCall(delayNum,ReversalItem(itemCon.getChildAt(i)).reversal);
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
			itemCon.removeAllChildren();
			if(itemCon.parent) itemCon.parent.removeChild(itemCon);
		}
	}
}