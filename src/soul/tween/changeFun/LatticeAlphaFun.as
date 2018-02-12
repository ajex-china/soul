package soul.tween.changeFun
{
	import soul.tween.TweenContainer;
	import soul.tween.TweenLite;
	import soul.tween.TweenMax;
	import soul.ui.ImageItem;
	import soul.utils.ArrayUtil;
	import soul.utils.Util;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class LatticeAlphaFun extends ChangeFun
	{
		protected var color:uint = 0xffffff;
		protected var row:int = 8;
		protected var column:int = 6;
		protected var bitmapList:Array;
		protected var bitmap:Bitmap = new Bitmap();
		protected var smoothing:Boolean = false;
		public function LatticeAlphaFun(container:TweenContainer)
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
			bitmapList = Util.copyPixel(bitmap.bitmapData,row,column);
			var i:int = 0
			for(i = 0; i < bitmapList.length;i++)
			{
				bitmapList[i].width+=0.1;
				bitmapList[i].height+= 0.1;//防止计算中出现小数而有缝隙
				bitmapList[i].smoothing = smoothing;
				TweenMax.to(bitmapList[i],0,{colorTransform:{tint:color, tintAmount:1},alpha:0});
				tweenContainer.addChild(bitmapList[i]);
				bitmapList[i].x = tweenContainer.newDis.x + i%row * (Math.round(tweenContainer.newDis.width/row));
				bitmapList[i].y = tweenContainer.newDis.y + int(i/row) * (Math.round(tweenContainer.newDis.height/column));
			}
			bitmapList = ArrayUtil.normalRandomArray(bitmapList);
			for(i = 0; i < bitmapList.length;i++)
			{
				TweenMax.to(bitmapList[i],tweenContainer.changeDuration/2,{colorTransform:{tint:color, tintAmount:0},alpha:1,delay:tweenContainer.changeDuration/2/bitmapList.length*i})
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