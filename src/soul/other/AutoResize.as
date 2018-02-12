package soul.other
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import soul.utils.Util;
	
	/**
	 *  舞台自适应类
	 * @author 
	 * 
	 */
	public class AutoResize
	{
		private static var _stage:Stage;
		private static var _autoList:Array = new Array();
		public var type:int;
		public var target:DisplayObject;
		public var rect:Rectangle;
		public var isClip:Boolean;
		public var top:Number;
		public var left:Number;
		public var right:Number;
		public var bottom:Number;
		public function AutoResize(target:DisplayObject,rect:Rectangle,type:int,isClip:Boolean = true,left:Number = NaN,top:Number = NaN,right:Number = NaN,bottom:Number = NaN)
		{
			this.target = target;
			this.rect = rect;
			this.type = type;
			this.isClip = isClip;
			if(isClip == true)
			{
				this.target.scrollRect = rect;
				Util.breakScrollRect(this.target);
			}
			this.left = left;
			this.top = top;
			this.right = right;
			this.bottom = bottom;
			_autoList.push(this);
			//如果自己已经运行 则自动再执行一次resize（防止已经开始和后再添加不能立刻刷新resize效果）
			if(_stage)
			{
				if(_stage.hasEventListener(Event.RESIZE))
				{
					this.resize();
				}
			}
		}
		/**
		 *增加自适应对象 
		 * @param target 自适应对象
		 * @param rect 对象自适应长宽标准(用作某些对象因为遮罩等特效超过表现的长宽时限制大小使用)
		 * @param type 自适应属性 0:缩小自适应 1:全自适应 2:顶部自适应 3:居中自适应 4:底部自适应 5:根据left top right bottom自适应
		 * @param isClip 是否强制剪裁到rect的大小(剪裁时可能会引发跨域问题)
		 * @param left 距离舞台左边的距离
		 * @param top 距离舞台顶部的距离
		 * @param right 距离舞台右边的距离
		 * @param bottom 距离舞台底部的距离
		 * 
		 */		
		public static function addAuto(target:DisplayObject,rect:Rectangle,type:int,isClip:Boolean = true,left:Number = NaN,top:Number = NaN,right:Number = NaN,bottom:Number = NaN):void
		{
			new AutoResize(target,rect,type,isClip,left,top,right,bottom);
		}
		/**
		 *出去自适应对象 
		 * @param target 自适应对象
		 * 
		 */		
		public static function removeAuto(target:DisplayObject):void
		{
			for(var i:int = 0;i < _autoList.length;i++)
			{
				if(_autoList[i].target == target)
				{
					_autoList.splice(i,1);
					break;
				}
			}
		}
		/**
		 *开始自适应 
		 * @param stage 舞台实例
		 * 
		 */		
		public static function start(stage:Stage):void
		{
			_stage = stage;
			if(!_stage) return;
			_stage.addEventListener(Event.RESIZE,resizeHandler);
			resizeHandler()
		}
		/**
		 * 停止自适应 
		 * 
		 */		
		public static function stop():void
		{
			if(!_stage) return;
			_stage.removeEventListener(Event.RESIZE,resizeHandler);
		}
		
		/**
		 *全部自适应一次 
		 * 
		 */		
		public static function allResize():void
		{
			resizeHandler();
		}
		
		protected static function resizeHandler(e:Event = null):void
		{
			for(var i:int = 0;i < _autoList.length;i++)
			{
				var auto:AutoResize = _autoList[i];
				auto.resize();
			}
		}
		public function resize():void
		{
			ResizeClass.resize(this.target,_stage,rect,isClip,type,left,top,right,bottom);
		}
	}
}