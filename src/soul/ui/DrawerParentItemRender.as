package soul.ui
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import soul.interFace.IRender;
	import soul.ui.skin.DrawerParentItemRenderSkin;
	import soul.utils.Util;
	/**
	 *抽屉组件的父项呈示器 
	 * @author Ajex
	 * 
	 */
	public class DrawerParentItemRender extends ListItemRender
	{
		public var icon_open_skin:DisplayObject;
		public var icon_close_skin:DisplayObject;
		
		public var isOpen:Boolean = false;
		protected var closeRefs:Array =[] ;
		private var _drawer:Drawer;
		private var _childrenList:Array;
		public function DrawerParentItemRender()
		{
			super();
		}
		override protected function constructor():void
		{
			super.constructor();
			if(icon_open_skin)
			{
				icon_open_skin.x = 3;
				addChild(icon_open_skin);
			}
			if(icon_close_skin)
			{
				icon_close_skin.x = 3;
				addChild(icon_close_skin);
				icon_close_skin.visible = false;
			}
		}
		override public function setDefaultSkin():void
		{
			setSkin(DrawerParentItemRenderSkin);
		}
		/**
		 *数据源 
		 * @param value
		 * 
		 */		
		override public function set data(value:*):void
		{
			super.data = value;
			_childrenList = data.children;
		}
		/**
		 *打开抽屉 
		 * 
		 */		
		public function openDrawer():void{
			if(isOpen) return;
			isOpen = true;
			var item:IRender;
			var i:int;
			icon_open_skin.visible = false;
			icon_close_skin.visible = true;
			for(i=0;i<_childrenList.length;i++){
				item = new DrawerChildItemRender();
				item.data = _childrenList[i];
				var index:int = drawer.getItemIndex(this);
				drawer.addItemAt(item,index + i + 1)
				closeRefs.push(item);
			}
			drawer.vaildDisplayList();
		}
		/**
		 *关闭抽屉 
		 * 
		 */		
		public function closeDrawer():void
		{
			if(!isOpen) return;
			isOpen = false;
			icon_open_skin.visible = true;
			icon_close_skin.visible = false;
			for(var i:int=0;i<closeRefs.length;i++){
				drawer.removeItem(closeRefs[i]);
			}
			closeRefs=[];
		}
		public function get drawer():Drawer
		{
			return _drawer;
		}
		/**
		 *设置控件源 
		 * @param value
		 * 
		 */		
		public function set drawer(value:Drawer):void
		{
			_drawer = value;
		}
		/**
		 *更新对其方式 
		 * 
		 */		
		override public function updateAlign():void
		{
			super.updateAlign();
			switch(align)
			{
				case "left":
				{
					if(icon) icon.x += getIconWidth();
					labelUI.x += getIconWidth();
					break;
				}
				case "right":
				{
					
					break;
				}
				case "center":
				{
					
					break;
				}
			}
		}
		private function getIconWidth():Number
		{
			return icon_open_skin.width>icon_close_skin.width?icon_open_skin.width:icon_close_skin.width;
		}
		override protected function invalidateSize():void
		{
			super.updateSize();
			icon_open_skin.y = BaseHeight/2 - icon_open_skin.height/2;
			icon_close_skin.y = BaseHeight/2 - icon_close_skin.height/2;
		}
	}
}