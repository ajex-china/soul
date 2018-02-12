package soul.ui
{
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class EaseList extends List
	{
		public var addCount:int = 4;//额外显示的项呈示器个数（用来优化滑动显示）
		public function EaseList(skin:Class=null)
		{
			super(skin);
		}
		override protected function constructor():void
		{
			super.constructor();
			vScrollBar.addEventListener(Event.CHANGE,scrollChangeHandler);
		}
		private var _oldValue:Number = 0;
		private var _scrollType:String = "down";
		protected function scrollChangeHandler(e:Event):void
		{
			if(this.scrollV > _oldValue)
			{
				_scrollType = "up";
			}
			else
			{
				_scrollType = "down";
			}
			if(_scrollType == "down")
			{
				
			}
			if(this.scrollV <= -rowHeight)
			{
				
			}
		}
		protected function changeRenderPoint():void
		{
			
		}
		override public function set dataProvider(value:Object):void
		{
			childContainer.scrollRect = new Rectangle(0,0,width,realCount*rowHeight);
			if(value is Array)
			{
				var list:Array = value as Array;
				list.splice(0,realCount);
				super.dataProvider(list);
			}
			else if(value is Array)
			{
				var index:int = 0;
				var obj:Object;
				for (var prop:* in value) 
				{ 
					obj[prop] = value[prop];
					index ++;
					if(index >= realCount)
					{
						super.dataProvider(obj);
						return;
					}
				}
			}
		}
		public function get realCount():int
		{
			return rowCount + addCount;
		}
	}
}