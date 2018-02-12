package soul.ui
{
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import soul.events.UIEvent;
	import soul.interFace.IRender;
	import soul.ui.skin.ListSkin;
	import soul.utils.Util;
	/**
	 * 组件List:
	 * 设定大小的时候一定注意增加或减去上下边框大小 
	 * @author Ajex
	 * 
	 */	
	public class List extends ScrollContainer
	{
		protected var _dataProvider:Object = [];
		private var _itemRender:Class;
		private var _enabled:Boolean = true;
		private var _selectedIndex:int = -1;
		private var _rowHeight:Number=22;
		private var _itemAlign:String;
		private var _rowCount:int = 5;
		
		
		public function List(skin:Class = null)
		{
			super(skin);
		}
		override public function setDefaultSkin():void
		{
			setSkin(ListSkin);
		}
		override protected function setStyle():void
		{
			setSize(100,112,false);
			rowHeight = 22;
			left = 1;
			right = 1;
			top = 1;
			bottom = 1;
			rowCount = 5;
		}
		/**
		 * 数据源 
		 * 1.2.5以后List取消对非数组格式的数据支持
		 * @param value 数组格式的数据源
		 * 
		 */		
		public function set dataProvider(value:Object):void
		{
//			_dataProvider = value; dataProvider已由addItemAt处理 这里不做赋值
//			removeAllItem();
			var cellRenderer:IRender;
			var i:int;
			if(value is Array)
			{
				var arr:Array = value as Array;
				while(arr.length < this.itemCount)
				{
					this.removeItemAt(this.itemCount - 1);
				}
				for(i = 0;i < arr.length;i++)
				{
					if(this.itemCount > i)
					{
						cellRenderer = this.getItemAt(i) as IRender;
					}
					else
					{
						cellRenderer =  new _itemRender();
						addItem(cellRenderer as DisplayObject);
					}
					cellRenderer.data = Util.cloneObject(arr[i]);
					cellRenderer.enabled = this.enabled;
					InteractiveObject(cellRenderer).width = itemWidth;
					InteractiveObject(cellRenderer).height = rowHeight;
				}
			}
			else
			{
				new Error("1.2.5以后List取消对非数组格式的数据支持")
			}
//			else if(value is Object)
//			{
//				removeAllItem();
//				var obj:Object = value;
//				for (var prop:* in obj) 
//				{ 
//					cellRenderer =  new _itemRender();
//					cellRenderer.data = obj[prop];
//					cellRenderer.enabled = this.enabled;
//					InteractiveObject(cellRenderer).width = itemWidth;
//					InteractiveObject(cellRenderer).height = rowHeight;
//					addItem(cellRenderer as DisplayObject);
//				} 
//
//			}
			_dataProvider = value;
			invalidateDisplayList();
		}
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		override public function set enabled(value:Boolean):void 
		{
			super.enabled = value;
			for(var i:int=0;i<childContainer.numChildren;i++)
			{
				if(childContainer.getChildAt(i) is IRender) (childContainer.getChildAt(i) as IRender).enabled = value;
			}
		}
		public function get itemRender():Class
		{
			return _itemRender;
		}
		/**
		 *项呈示器 
		 * @param value
		 * 
		 */		
		public function set itemRender(value:Class):void
		{
			_itemRender = value;
		}
		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		/**
		 * 选中项 索引位置
		 * @param value
		 * 
		 */		
		public function set selectedIndex(value:int):void
		{
			if(_selectedIndex == value) return;
			if(value >= childContainer.numChildren) return;//长度不够时 设置选中项无效
			_selectedIndex = value;
			if(value < childContainer.numChildren)
			{
				changeIndexHandler(value);
			}
		}
		private function changeIndexHandler(index:int):void
		{
			for(var i:int = 0;i<childContainer.numChildren;i++)
			{
				(childContainer.getChildAt(i) as IRender).selected = false;
			}
			this.dispatchEvent(new Event(Event.CHANGE));
			if(index >= 0)
				(childContainer.getChildAt(index) as IRender).selected = true;
			
		}
		/**
		 *选中项数据 
		 * @return 
		 * 
		 */		
		public function get selectItemData():Object
		{
			return (childContainer.getChildAt(_selectedIndex) as IRender).data;
		}
		/**
		 *项呈示器个数 
		 * @return 
		 * 
		 */		
		public function get length():uint
		{
			return uint(childContainer.numChildren);
		}
		public function get rowCount():uint
		{
//			return Math.ceil((BaseHeight - top - bottom)/rowHeight);//因为内部修改高度的时候 项目数实际上不应该变 所以修改
			return _rowCount;
		}
		/**
		 * 显示项数 
		 * @param value
		 * 
		 */		
		public function set rowCount(value:uint):void
		{
			_rowCount = value;
			this.height = value * rowHeight + top + bottom;
		}
		public function get rowHeight():Number
		{
			return _rowHeight;
		}
		/**
		 *项高（不会更改总大小） 
		 * @param value
		 * 
		 */		
		public function set rowHeight(value:Number):void
		{
			//this.height = rowCount * value + top + bottom;//必须写在前面 因为如果 _rowHeight改变了 rowCount就会改变
			_rowHeight = value;
			vScrollBar.detra = value;
			for(var i:int = 0; i < childContainer.numChildren;i++)
			{
				childContainer.getChildAt(i).height = value;
			}
			this.height = rowCount * rowHeight + top + bottom;
		}
		protected function get itemWidth():Number
		{
			var isBar:Boolean;
			if(itemCount > rowCount) isBar = true;
			return  BaseWidth - (vScrollBar?(isBar?vScrollBar.width:0):0) - left - right;
		}
		/**
		 *跟新项呈示器 
		 * 
		 */		
		public function updateRender():void
		{
			
			for(var i:int = 0; i < childContainer.numChildren;i++)
			{
				childContainer.getChildAt(i).y = rowHeight*i;
				if(childContainer.getChildAt(i) is IRender) childContainer.getChildAt(i).width = itemWidth;
			}
		}
		override public function addItemAt(item:*, index:uint):void
		{
			
			var data:*;
			if(item is IRender) 
			{
				data = (item as IRender).data;
				(item as InteractiveObject).addEventListener(MouseEvent.CLICK,itemClick);
				item.enabled = this.enabled;
				item.align=itemAlign;
				(item as InteractiveObject).width = itemWidth;
				(item as InteractiveObject).height = rowHeight;
				super.addItemAt(item,index);
			}
			else//change 1.2.4 from 3
			{
				data = item;
				var render:* = new itemRender();
				render.data = item;
				render.enabled = this.enabled;
				InteractiveObject(render).addEventListener(MouseEvent.CLICK,itemClick);
				render.align=itemAlign;
				render.width = itemWidth;
				render.height = rowHeight;
				super.addItemAt(render,index);
			}
			(dataProvider as Array).splice(index,0,data);
		}
		override public function removeItem(item:*):void
		{
			var i:int;
			var getItem:*;
			if(item is IRender) 
			{
				(item as InteractiveObject).removeEventListener(MouseEvent.CLICK,itemClick);
				data = (item as IRender).data;
				super.removeItem(item);
				for(i = 0; i < this.length;i++)
				{
					getItem = this.getItemAt(i);
					if(getItem.data == item) 
					{
						super.removeItem(getItem);
						if(item == _dataProvider[i])
						{
							(_dataProvider as Array).splice(i,1);
						}
					}
				}
			}
			else if(item.label)
			{
				for(i = 0; i < this.length;i++)
				{
					getItem = this.getItemAt(i);
					if(getItem.label == item.label) 
					{
						super.removeItem(getItem);
						if(item.label == _dataProvider[i].label)
						{
							(_dataProvider as Array).splice(i,1);
						}
					}
				}
			}
		}
		override public function removeItemAt(index:uint):void
		{
			if(this.getItemAt(index) is InteractiveObject) (this.getItemAt(index) as InteractiveObject).removeEventListener(MouseEvent.CLICK,itemClick);
			super.removeItemAt(index);
			(_dataProvider as Array).splice(index,1);
		}
		override public function removeAllItem():void
		{
			for(var i:int=0;i<this.length;i++)
			{
				if(this.getItemAt(i) is InteractiveObject) (this.getItemAt(i) as InteractiveObject).removeEventListener(MouseEvent.CLICK,itemClick);
			}
			super.removeAllItem();
			_dataProvider = [];
		}
		protected function itemClick(e:MouseEvent):void
		{
			selectedIndex = getItemIndex(e.currentTarget as DisplayObject);
			this.dispatchEvent(new UIEvent(UIEvent.LIST_ITEM_CLICK,selectedIndex));
		}
		
		public function get itemAlign():String
		{
			return _itemAlign;
		}
		/**
		 *  项呈示器对其方式
		 * @param value left: 左对齐 right: 右对齐 center:居中
		 * 
		 */
		public function set itemAlign(value:String):void
		{
			_itemAlign = value;
			for(var i:int = 0;i<childContainer.numChildren;i++)
			{
				if(childContainer.getChildAt(i) is IRender) (childContainer.getChildAt(i) as IRender).align = value;
			}
		}
		
		/**
		 *内部会减去 left right top botton 
		 * @param width
		 * @param height
		 * 
		 */		
		protected override function setRect():void
		{
			var rect:Rectangle = new Rectangle();
			rect.x = (container.scrollRect?container.scrollRect.x:0);
			rect.y = (container.scrollRect?container.scrollRect.y:0);
			rect.width = scrWidth - left - right;
			rect.height = scrHeight - top - bottom;
			this.scrollRect = new Rectangle(0,0,width,height);
			Util.breakScrollRect(this);
			//			rect.width = scrWidth;
			//			rect.height = scrHeight;
			container.scrollRect = rect;
			container.x = left;
			container.y = right;
			Util.breakScrollRect(container);
		}
		
		protected override function updateSize() : void
		{
			updateRender()
			super.updateSize();
		}
		
		protected override function updateDisplayList():void
		{
			updateRender();
			super.updateDisplayList();
		}
		override public function destory():void
		{
			_dataProvider = null;
			super.destory();
		}
	}
}