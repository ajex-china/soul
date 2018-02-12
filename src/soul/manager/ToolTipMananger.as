package soul.manager
{
	import flash.display.DisplayObject;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import soul.FrameworkInfo;
	import soul.interFace.IToolTip;
	import soul.ui.ToolTip;
	
	public class ToolTipMananger
	{
		public static var toolTip:ToolTip = new ToolTip();
		public static var cliprect:Rectangle;
		private var _toolTipTarget:DisplayObject;
		private var _toolTipLabel:String;
		private var _toolTipPoint:Point;
		private var _toolTipObject:ToolTip;
		private static var _manangerList:Vector.<ToolTipMananger> = new Vector.<ToolTipMananger>();
		public function ToolTipMananger(target:DisplayObject,label:String,point:Point=null,tipObject:ToolTip = null)
		{
			_toolTipTarget = target;
			_toolTipLabel = label;
			_toolTipPoint = point;
			if(!tipObject)
			{
				_toolTipObject = toolTip;
			}
			else
			{
				_toolTipObject = tipObject;
			}
			_toolTipTarget.addEventListener(MouseEvent.ROLL_OVER,overHandler);
			_toolTipTarget.addEventListener(MouseEvent.ROLL_OUT,outHandler);
//			FrameworkInfo.stage.addEventListener(FullScreenEvent.FULL_SCREEN,fullScreenHandler);
		}
//		protected function fullScreenHandler(e:FullScreenEvent):void
//		{ 
//			if(_toolTipObject) hideTip();
//		}
		public static function addToolTip(target:DisplayObject,label:String,point:Point=null,tipObject:ToolTip = null):ToolTipMananger
		{
			if(checkToolTip(target)) removeToolTip(target);
			for(var i:int = 0; i < _manangerList.length;i++)
			{
				if(_manangerList[i].toolTipTarget == target)
				{
					_manangerList[i].toolTipLabel = label;
					_manangerList[i].toolTipPoint = point;
					_manangerList[i].toolTipObject = tipObject;
					break;
				}
			}
			var toolTipMananger:ToolTipMananger = new ToolTipMananger(target,label,point,tipObject);
			_manangerList.push(toolTipMananger);
			return toolTipMananger;
		}
		public static function removeToolTip(target:DisplayObject):void
		{
			for(var i:int = 0; i < _manangerList.length;i++)
			{
				if(_manangerList[i].toolTipTarget == target)
				{
					_manangerList[i].remove();
					_manangerList[i] = null;
					_manangerList.splice(i,1);
					break;
				}
			}
		}
		public static function checkToolTip(target:DisplayObject):Boolean
		{
			for(var i:int = 0; i < _manangerList.length;i++)
			{
				if(_manangerList[i].toolTipTarget == target)
				{
					return true;
				}
			}
			return false;
		}
		public function remove():void
		{
			_toolTipObject = null;
			_toolTipTarget.removeEventListener(MouseEvent.ROLL_OVER,overHandler);
			_toolTipTarget.removeEventListener(MouseEvent.ROLL_OUT,outHandler);
		}
		private function overHandler(e:MouseEvent):void
		{
			showTip()
		}
		private function outHandler(e:MouseEvent):void
		{
			hideTip();
		}
		public function showTip():void
		{
			_toolTipObject.label(_toolTipLabel);
			if(!_toolTipTarget.stage.contains(_toolTipObject))
			{
				_toolTipTarget.stage.addChild(_toolTipObject);
			}
			if(_toolTipPoint)
			{
				_toolTipObject.x = _toolTipPoint.x;
				_toolTipObject.y = _toolTipPoint.y;
			}
			else
			{
				_toolTipObject.x = _toolTipTarget.stage.mouseX;
				_toolTipObject.y = _toolTipTarget.stage.mouseY;
			}
			var rect:Rectangle;
			if(cliprect)
			{
				rect = cliprect;
			}
			else
			{
				rect = new Rectangle(0,0,_toolTipTarget.stage.stageWidth,_toolTipTarget.stage.stageHeight);
			}
			
			if(_toolTipObject.x + _toolTipObject.width > rect.width)
			{
				_toolTipObject.x = rect.width - _toolTipObject.width;
			}
			else if(_toolTipObject.x < rect.x)
			{
				_toolTipObject.x = rect.x;
			}
			if(_toolTipObject.y + _toolTipObject.height > rect.height)
			{
				_toolTipObject.y = rect.height - _toolTipObject.height;
			}
			else if(_toolTipObject.y < rect.y)
			{
				_toolTipObject.y = rect.y;
			}
		}
		public function hideTip():void
		{
			if(_toolTipObject)
			{
				if(_toolTipObject.parent) _toolTipObject.parent.removeChild(_toolTipObject);
			}
		}
		public function get toolTipTarget():DisplayObject
		{
			return _toolTipTarget;
		}
		
		public function set toolTipTarget(value:DisplayObject):void
		{
			_toolTipTarget = value;
		}
		
		public function get toolTipLabel():String
		{
			return _toolTipLabel;
		}
		
		public function set toolTipLabel(value:String):void
		{
			_toolTipLabel = value;
			_toolTipObject.label(_toolTipLabel);
		}
		
		public function get toolTipPoint():Point
		{
			return _toolTipPoint;
		}
		
		public function set toolTipPoint(value:Point):void
		{
			_toolTipPoint = value;
		}

		public function get toolTipObject():ToolTip
		{
			return _toolTipObject;
		}

		public function set toolTipObject(value:ToolTip):void
		{
			_toolTipObject = value;
		}
		
		
		
	}
}