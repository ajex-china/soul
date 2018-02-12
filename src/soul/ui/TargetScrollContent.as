package soul.ui
{
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import soul.interFace.IScrollContent;
	import soul.utils.Util;

	/**
	 * 此类由scrollBar内部创建 用作脱离updatesize的滚动 不要单独实例 
	 * @author Ajex
	 * 
	 */	
	public class TargetScrollContent extends EventDispatcher implements IScrollContent
	{
		private var _target:*;
		private var _wheelSpeed:Number = 15;
		public var hScrollBar:HScrollBar;
		public var vScrollBar:VScrollBar;
		
		private var _oldScrollH:int;
		private var _oldScrollV:int;
		private var _wheelDirect:String = "V";
		
		public function TargetScrollContent(scrollbar:ScrollBar,target:*)
		{
			if(scrollbar is HScrollBar) 
			{
				hScrollBar = scrollbar as HScrollBar;
				_wheelDirect = "H";
			}
			else if(scrollbar is VScrollBar)
			{
				vScrollBar = scrollbar as VScrollBar;
				_wheelDirect = "V";
			}
			content = target;
		}
		public function set content(target:*):void
		{
			_target = target;
			if(!_target.hasEventListener(MouseEvent.MOUSE_WHEEL))
			{
				_target.addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelHandler);
			}
//			if(hScrollBar) hScrollBar.vaildNow();
//			if(vScrollBar) vScrollBar.vaildNow();
		}
		
		public function get content():DisplayObject
		{
			return _target;
		}
		
		public function get realWidth():Number
		{
			var rect:Rectangle = Util.getRealSize(_target);
			return rect.width;
		}
		
		public function get realHeight():Number
		{
			var rect:Rectangle = Util.getRealSize(_target);
			return	rect.height;
		}
		
		public function get maxScrollH():int
		{
			return Math.max(0,realWidth - ((_target.scrollRect?_target.scrollRect.width:0)));
		}
		
		public function get maxScrollV():int
		{
			return Math.max(0,realHeight - ((_target.scrollRect?_target.scrollRect.height:0)));
		}
		
		public function get scrollH():int
		{
			return	_target.scrollRect.x;
		}
		
		public function set scrollH(v:int):void
		{
			v = Math.max(0,Math.min(v,maxScrollH))
			
			_oldScrollH = _target.scrollRect.x;
			setRectPos(v,"H");
		}
		
		public function get scrollV():int
		{
			return _target.scrollRect.y;
		}
		
		public function set scrollV(v:int):void
		{
			v = Math.max(0,Math.min(v,maxScrollV))
			
			_oldScrollV = _target.scrollRect.y;
			setRectPos(v,"V");
		}
		
		public function get wheelDirect():String
		{
			return _wheelDirect;
		}
		
		public function set wheelDirect(value:String):void
		{
			_wheelDirect = value;
		}
		
		public function get wheelSpeed():Number
		{
			return _wheelSpeed;
		}
		
		public function set wheelSpeed(value:Number):void
		{
			_wheelSpeed = value;
		}
		
		protected function setRectPos(value:Number,dir:String):void
		{
			var newPos:Number = value;
			
			if(dir == "V")
			{
				_target.scrollRect = new Rectangle(_target.scrollRect.x,newPos,_target.scrollRect.width,_target.scrollRect.height);
			}
			else
			{
				_target.scrollRect = new Rectangle(newPos,_target.scrollRect.y,_target.scrollRect.width,_target.scrollRect.height);
			}
			dispatchEvent(new Event(Event.SCROLL));
		}
		protected function mouseWheelHandler(event:MouseEvent):void
		{
			if (wheelDirect)
			{
				
				if (wheelDirect == "H")
					hScrollBar.toValue(Math.min(maxScrollH,Math.max(0,scrollH - event.delta * wheelSpeed)));
				if(wheelDirect == "V")
					vScrollBar.toValue(Math.min(maxScrollV,Math.max(0,scrollV - event.delta * wheelSpeed)));
			}
		}
	}
}