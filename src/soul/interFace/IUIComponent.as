package soul.interFace
{
	public interface IUIComponent
	{
		function set data(value:*):void
		function get data():*;
		function set enabled(value:Boolean):void;
		function get enabled():Boolean;
	}
}