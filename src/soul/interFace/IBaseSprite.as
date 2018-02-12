package soul.interFace
{
	import flash.events.Event;

	public interface IBaseSprite
	{
		function set x(value:Number):void;
		function get x():Number;
		function set y(value:Number):void;
		function get y():Number;
		function set z(value:Number):void;
		function get z():Number;
		function set width(value:Number):void;
		function get width():Number;
		function set height(value:Number):void;
		function get height():Number;
		function set scaleX(value:Number):void;
		function get scaleX():Number;
		function set scaleY(value:Number):void;
		function get scaleY():Number;
		function set scaleZ(value:Number):void;
		function get scaleZ():Number;
		function set visible(value:Boolean):void;
		function get visible():Boolean;
		function set rotation(value:Number):void;
		function get rotation():Number;
		function set rotationX(value:Number):void;
		function get rotationX():Number;
		function set rotationY(value:Number):void;
		function get rotationY():Number;
		function set rotationZ(value:Number):void;
		function get rotationZ():Number;
		
		function dispatchEvent(event:Event):Boolean
	}
}