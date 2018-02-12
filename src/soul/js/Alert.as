package soul.js
{
	import flash.external.ExternalInterface;

	public class Alert
	{
		public function Alert()
		{
		}
		public static function show(value:*):void
		{
			if(ExternalInterface.available)
			{
				ExternalInterface.call("myalert=function(){alert('" + value  + "');}");
				return;
			}
		}
	}
}