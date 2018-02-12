package soul.events
{
	import flash.events.Event;
	
	public class UIEvent extends Event
	{
		public var data:*;
		
		public static const DATA_CHANGE:String="data_change";
		public static const CREATE_COMPLETE:String="create_complete";
		public static const SCROLLBAR_ENABLED_CHANGE:String="scrollBar_enabled_change";
		public static const LIST_ITEM_CLICK:String="list_item_click";
		public static const TREE_ITEM_CLICK:String="tree_item_click";
		public static const UPDATE_COMPLETE:String="update_complete";
		public function UIEvent(type:String,_data:* =null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = _data;
			super(type, bubbles, cancelable);
		}
	}
}