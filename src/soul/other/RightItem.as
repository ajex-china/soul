package soul.other
{
	import soul.FrameworkInfo;
	
	import flash.display.InteractiveObject;
	import flash.events.ContextMenuEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.utils.Dictionary;
	
	public class RightItem
	{
		private var target:InteractiveObject;
		
		private var _myContextMenu:ContextMenu;
		private var _functionDictionary:Dictionary;
		private var _paramsDictionary:Dictionary;
		public function RightItem(target:InteractiveObject)
		{
			this.target=target;
			_myContextMenu = new ContextMenu();
			_myContextMenu.hideBuiltInItems();
			this.target.contextMenu=_myContextMenu;
			_functionDictionary = new Dictionary();
			_paramsDictionary = new Dictionary();
		}
		public function addItem(caption:String,separatorBefore:Boolean = false,enabled:Boolean = true,visible:Boolean = true,itemSelectFunction:Function=null,itemSelectParams:Array=null):void
		{
			var nameMenuItem:ContextMenuItem=new ContextMenuItem(caption,separatorBefore,enabled,visible);
			_functionDictionary[nameMenuItem] = itemSelectFunction;
			_paramsDictionary[nameMenuItem] = itemSelectParams;
			if(itemSelectFunction!=null)
			{
				nameMenuItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,itemSelectHandler);
			}
			_myContextMenu.customItems.push(nameMenuItem);
		}
		public function removeItem(caption:String):void
		{
			for(var i:int = 0;i < _myContextMenu.customItems.length;i++)
			{
				if(_myContextMenu.customItems[i] is ContextMenuItem)
				{
					if((_myContextMenu.customItems[i] as ContextMenuItem).caption == caption)
					{
						_myContextMenu.customItems.splice(i,1);
						break;
					}
				}
			}
		}
		private function itemSelectHandler(e:ContextMenuEvent):void
		{
			var fun:Function = _functionDictionary[e.currentTarget];
			var params:Array = _paramsDictionary[e.currentTarget];
			fun.apply(this,params);
		}
	}
}