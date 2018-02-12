package soul.js
{
	import flash.external.ExternalInterface;

	public class Confirm
	{
		public function Confirm()
		{
		}
		public static function show(value:*):Boolean
		{
			if(ExternalInterface.available)
			{
				return ExternalInterface.call("myconfirm=function(){return confirm('" + value  + "');}");
			}
			else
			{
				return false;
			}
		}
	}
}