package com.event
{
	import flash.events.Event;
	
	public class ProgramEvent extends Event
	{
		public var data:*;
		public static const INIT_COMPLETE:String="initComplete";
		public static const LOADINGBAR_INIT:String="loadingBar_init";
		
		public static const SERVICE_RETURN:String="service_return";
		public static const POP_VIEW:String="pop_view";
		public static const REMOVE_VIEW:String="remove_View";
		public static const CHANGE_VIEW:String="change_view";
		
		public static const FONT_LOAD_COMPLETE:String = "font_load_complete";
		public static const RECEIVE_MESSAGE:String = "receive_message";
		public static const FLOWER_MESSAGE:String="flower_message";
		public static const MORE_FLOWER_MESSAGE:String = "more_flower_message";
		public static const ME_SEND_MESSAGE:String="me_send_message";
		public static const CLOSE_OPEN_BARRAGE:String="close_open_barrage";
		public static const GET_PEOPLE_COUNT:String="get_people_count";
		public static const GET_DAYLIST_COUNT:String="get_daylist_count";
		public static const GET_MONTHLIST_COUNT:String="get_monthlist_count";
		public static const GET_HEADPIC:String="get_headpic";
		
		public function ProgramEvent(type:String, _data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = _data;
			super(type, bubbles, cancelable);
		}
	}
}