package soul.other
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import soul.tween.TweenLite;

	/**
	 * 目标鼠标移动类
	 * @author 
	 * 
	 */	
	public class DisplayMouseMove
	{
		private static var _displayList:Array = new Array();
		public static var eventDisPlay:Sprite = new Sprite();
		public var mouseTarget:DisplayObjectContainer;
		public var dis:DisplayObject;
		public var xd:Number;
		public var yd:Number;
		public var delay:Number;
		public var point:Point
		public function DisplayMouseMove(mouseTarget:DisplayObjectContainer,dis:DisplayObject,xd:Number,yd:Number,delay:Number = 1)
		{
			this.mouseTarget = mouseTarget;
			this.dis = dis;
			this.xd = xd;
			this.yd = yd;
			this.delay = delay;
			this.point = new Point(dis.x,dis.y);
			_displayList.push(this);
		
		}
		/**
		 * 增加鼠标移动对象 
		 * @param mouseTarget 鼠标计算对象
		 * @param dis 鼠标移动对象
		 * @param xd x轴移动除数
		 * @param yd y轴移动除数
		 * @param delay 延时移动时间
		 * 
		 */		
		public static function add(mouseTarget:DisplayObjectContainer ,dis:DisplayObject,xd:Number,yd:Number,delay:Number = 1):void
		{
			new DisplayMouseMove(mouseTarget,dis,xd,yd);
			if(!eventDisPlay.hasEventListener(Event.ENTER_FRAME))
			{
				if(_displayList.length > 0)
				{
					eventDisPlay.addEventListener(Event.ENTER_FRAME,frameHandler);
				}
			}
		}
		public static function remove(dis:DisplayObject):void
		{
			for(var i:int = 0;i < _displayList.length;i++)
			{
				if(_displayList[i].dis == dis)
				{
					_displayList.splice(i,1);
					break;
				}
			}
		}
		public function move():void
		{
			TweenLite.to(this.dis,this.delay,{x:point.x - (xd==0?0:this.mouseTarget.mouseX/xd),y:point.y - (yd==0?0:this.mouseTarget.mouseY/yd)});
		}
		protected static function frameHandler(e:Event):void
		{
			for(var i:int = 0;i < _displayList.length;i++)
			{
				_displayList[i].move();
			}
		}
	}
}