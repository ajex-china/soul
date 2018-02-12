package soul.js
{
	import flash.external.ExternalInterface;
	
	import soul.debug.AS3Debugger;

	public class WindowsLocation
	{
		public function WindowsLocation()
		{
		}
		public static function getSearchParam(param:String):String
		{
			if(ExternalInterface.available)
			{
				var search:String = ExternalInterface.call("mysearch=function(){return window.location.search;}");
				//AS3Debugger.Trace("获取到网址参数：" + search);
				if(search)
				{
					var list:Array =  search.match(new RegExp("[\?\&]" + param + "=([^\&]*)(\&?)","i"));
					if(!list) return null;
					if(!list[1]) return null;
					var returParam:String =list[1];
					return returParam;
				}
				else
				{
					return null;
				}
			}
			else
			{
				return null;
			}
		}
		public static function getPathname():String
		{
			if(ExternalInterface.available)
			{
				var pathname:String = ExternalInterface.call("mypathname=function(){return window.location.pathname;}");
				if(pathname)
				{
					return pathname;
				}
				else
				{
					return null;
				}
			}
			else
			{
				return null;
			}
		}
	}
}