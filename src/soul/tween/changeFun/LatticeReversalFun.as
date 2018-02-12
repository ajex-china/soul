/**
 *过场时间太短看不出效果  
 */
package soul.tween.changeFun
{
	import soul.display.ReversalItem;
	import soul.tween.TweenContainer;
	import soul.tween.TweenLite;
	import soul.display.BaseSprite;
	import soul.utils.ArrayUtil;
	import soul.utils.Util;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class LatticeReversalFun extends ChangeFun
	{
		protected var row:int = 8;
		protected var column:int = 6;
		protected var oldBitmapList:Array;
		protected var oldBitmap:Bitmap = new Bitmap();
		protected var newBitmapList:Array;
		protected var newBitmap:Bitmap = new Bitmap();
		protected var itemCon:BaseSprite = new BaseSprite();
		protected var smoothing:Boolean = false;
		public function LatticeReversalFun(container:TweenContainer)
		{
			super(container);
		}
		override protected function hideHandler():void
		{
			if(tweenContainer.showData)
			{
				if(tweenContainer.showData.row)
				{
					row = tweenContainer.showData.row;
				}
				if(tweenContainer.showData.column)
				{
					column = tweenContainer.showData.column;
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
			newBitmapList = Util.copyPixel(newBitmap.bitmapData,row,column);
			
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
			oldBitmapList = Util.copyPixel(oldBitmap.bitmapData,row,column);
			
			tweenContainer.addChild(itemCon);
			
			var i:int = 0;
			for(i = 0; i < oldBitmapList.length;i++)
			{
				oldBitmapList[i].width += 0.1;
				newBitmapList[i].width += 0.1;//防止计算中出现小数而有缝隙		
				oldBitmapList[i].height += 0.1;
				newBitmapList[i].height += 0.1;//防止计算中出现小数而有缝隙		
				oldBitmapList[i].smoothing = smoothing;
				newBitmapList[i].smoothing = smoothing;
				var item:ReversalItem = new ReversalItem(oldBitmapList[i],newBitmapList[i],tweenContainer.changeDuration/2);
				itemCon.addChild(item);
				item.x = tweenContainer.newDis.x + i%row * (Math.round(tweenContainer.newDis.width/row));
				item.y = tweenContainer.newDis.y + int(i/row) * (Math.round(tweenContainer.newDis.height/column));
			}
			var randomList:Array = [];
			for(i = 0; i < oldBitmapList.length;i++)
			{
				randomList.push(i);
			}
			randomList = ArrayUtil.normalRandomArray(randomList);
			for(i = 0;i < randomList.length;i++)
			{
				
				TweenLite.delayedCall(tweenContainer.changeDuration/2/oldBitmapList.length*i,ReversalItem(itemCon.getChildAt(randomList[i])).reversal);
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