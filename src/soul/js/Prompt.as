package soul.js
{
	import flash.external.ExternalInterface;

	public class Prompt
	{
		public function Prompt()
		{
		}
		public static function show(text:*,defaultValue:*):*
		{
			if(ExternalInterface.available)
			{
				return ExternalInterface.call("myprompt=function(){return prompt('" + text  + "','" + defaultValue + "');}");
			}
			else
			{
				return null;
			}
		}
	}
}