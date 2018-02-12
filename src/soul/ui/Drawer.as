package soul.ui
{
	import soul.events.UIEvent;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.MouseEvent;
	
	import soul.interFace.IRender;
	import soul.ui.skin.DrawerSkin;

	/**
	 *抽屉组件 Drawer:
	 * 修改皮肤后可代替Tree组件
	 * @author Ajex
	 * 
	 */	
	public class Drawer extends List
	{
		private var _childrenList:Array;
		private var _DrawType:String="more";
		private var _parentAlign:String = "left";
		private var _childrenAlign:String="left";
		public function Drawer(skin:Class=null)
		{
			super(skin);
			
		}
		override protected function setStyle():void
		{
			parentAlign = "center";
			childrenAlign = "left";
			setSize(250,352,false);
			left = 1;
			right = 1;
			top = 1;
			bottom = 1;
		}
		override public function setDefaultSkin():void
		{
			setSkin(DrawerSkin);
		}
		override public function set dataProvider(value:Object):void
		{
			_dataProvider = value;
			this.removeAllItem();
			var i:int;
			var item:IRender;
			if(value is Array)
			{
				_childrenList = value as Array;
			}
			for(i=0;i<_childrenList.length;i++){
				item = new DrawerParentItemRender();
				DrawerParentItemRender(item).drawer = this;
				item.data = _childrenList[i];
				this.addItem(item);
			}
		}

		public function get DrawType():String
		{
			return _DrawType;
		}
		/**
		 * 抽屉属性 
		 * @param value only:同时只能打开一个抽屉 more:可以同时打开多个抽屉
		 * 
		 */		
		public function set DrawType(value:String):void
		{
			_DrawType = value;
		}
		/**
		 *打开抽屉 
		 * 
		 */		
		public function openAllDrawer():void
		{
			for(var i:int = 0;i < itemCount;i++)
			{
				if(this.getItemAt(i) is DrawerParentItemRender)
				{
					(this.getItemAt(i) as DrawerParentItemRender).openDrawer();
				}
			}
		}
		/**
		 *关闭抽屉 
		 * 
		 */		
		public function closeAllDrawer():void
		{
			for(var i:int = 0;i < itemCount;i++)
			{
				if(this.getItemAt(i) is DrawerParentItemRender)
				{
					(this.getItemAt(i) as DrawerParentItemRender).closeDrawer();
				}
			}
		}
		override protected function itemClick(e:MouseEvent):void
		{
			
			
			if(e.currentTarget is DrawerParentItemRender)
			{
				var drawerParentItemRender:DrawerParentItemRender = e.currentTarget as DrawerParentItemRender
				if(drawerParentItemRender.isOpen) 
				{
					drawerParentItemRender.closeDrawer();
				}
				else
				{
					if(DrawType == "only") closeAllDrawer();
					drawerParentItemRender.openDrawer();
				}
			}
			else
			{
				selectedIndex = getItemIndex(e.currentTarget as DisplayObject);
				this.dispatchEvent(new UIEvent(UIEvent.TREE_ITEM_CLICK,(e.currentTarget as DrawerChildItemRender).data));
			}
			
		}
		
		override public function addItemAt(item:*, index:uint):void
		{
			var dis:DisplayObject;
			if(item is IRender) 
			{
				(item as InteractiveObject).addEventListener(MouseEvent.CLICK,itemClick);
				item.enabled = this.enabled;
				(item as InteractiveObject).width = itemWidth;
				(item as InteractiveObject).height = rowHeight;
				if(item is DrawerParentItemRender)
				{
					(item as DrawerParentItemRender).align = parentAlign;
				}
				else
				{
					(item as DrawerChildItemRender).align = childrenAlign;
				}
				if(item is DisplayObject)
				{
					dis = item as DisplayObject;
				}
			}
			else if(item.label)
			{
				var render:* = new itemRender();
				render.data = item;
				render.enabled = this.enabled;
				InteractiveObject(render).addEventListener(MouseEvent.CLICK,itemClick);
				render.width = itemWidth;
				render.height = rowHeight;
				if(render is DrawerParentItemRender)
				{
					(render as DrawerParentItemRender).align = parentAlign;
				}
				else
				{
					(render as DrawerChildItemRender).align = childrenAlign;
				}
				if(render is DisplayObject)
				{
					dis= render as DisplayObject;
				}
			}
			if(dis) childContainer.addChildAt(dis,index);
			invalidateDisplayList();
		}
		
		public function get parentAlign():String
		{
			return _parentAlign
		}
		/**
		 *父对其方式
		 * @param value left: 左对齐 right: 右对齐 center:居中
		 * 
		 */		
		public function set parentAlign(value:String):void
		{
			_parentAlign = value;
			for(var i:int = 0;i < itemCount;i++)
			{
				if(this.getItemAt(i) is DrawerParentItemRender)
				{
					(this.getItemAt(i) as DrawerParentItemRender).align = value;
				}
			}
		}
		public function get childrenAlign():String
		{
			return _childrenAlign;
		}
		/**
		 *子 对其方式 
		 * @param value left: 左对齐 right: 右对齐 center:居中
		 * 
		 */		
		public function set childrenAlign(value:String):void
		{
			_childrenAlign = value;
			for(var i:int = 0;i < itemCount;i++)
			{
				if(this.getItemAt(i) is DrawerChildItemRender)
				{
					(this.getItemAt(i) as DrawerChildItemRender).align = value;
				}
			}
		}
		override public function get itemAlign():String
		{
			throw new Error("itemAlign 已被Drawer的childrenAlign parentAlign代替");
			return;
		}
		override public function set itemAlign(value:String):void
		{
			throw new Error("itemAlign 已被Drawer的childrenAlign parentAlign代替");
		}
		
//		override protected function updateSize():void
//		{
//			super.updateSize();
//		}
	}
}