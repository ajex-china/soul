package soul.events
{
	import flash.events.Event;
	
	public class LoadingEvent extends Event
	{
		public static const LOAD_START:String="load_start";
		public static const LOAD_PROGRESS:String="load_progress";
		public static const LOAD_COMPLETE:String="load_complete";
		public static const LOAD_ALL_COMPLETE:String="load_all_complete";
		
		public static const MULTIPLE_START:String="multiple_start";//多资源加载器开始工作
		public static const MULTIPLE_LOAD_START:String="multiple_load_start";//资源序列开始加载
		public static const MULTIPLE_LOAD_PROGRESS:String="multiple_load_progress";//资源序列加载进度
		public static const MULTIPLE_LOAD_COMPLETE:String="multiple_load_complete";//资源序列加载完成
		public static const MULTIPLE_LOAD_ALL_COMPLETE:String="multiple_load_all_complete";//多资源加载器工作完成
		
		public static const SINGLE_START:String="single_start";//单资源加载器开始工作
		public static const SINGLE_LOAD_START:String="single_load_start";//资源开始加载
		public static const SINGLE_LOAD_PROGRESS:String="single_load_progress";//资源加载进度
		public static const SINGLE_LOAD_COMPLETE:String="single_load_complete";//资源加载完成
		public static const SINGLE_LOAD_ALL_COMPLETE:String="single_load_all_complete";//单资源加载器工作完成
		public static const SINGLE_LOAD_ALL_PROGRESS:String="single_load_all_progress";//全部资源加载进度
		
		public var data:*;
		public function LoadingEvent(type:String,_data:*=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = _data;
			super(type, bubbles, cancelable);
		}
	}
}