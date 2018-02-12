package soul.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 *  影片剪辑工具类
	 * @author 
	 * 
	 */	
	public class MovieClipUtil
	{
		/**
		 *是否循环 
		 */		
		public static var iscirculation:Boolean = false;
		/**
		 *开始倒着播放一片剪辑 
		 * @param mc
		 * 
		 */		
		public static function prevPlay(mc:MovieClip):void
		{
			mc.stop();
			mc.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		/**
		 * 停止倒着播放一片剪辑 
		 * @param mc
		 * 
		 */		
		public static function stopPrevPlay(mc:MovieClip):void
		{
			mc.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		private static function enterFrameHandler(e:Event):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			if(mc.currentFrame == 1)
			{
				if(iscirculation)
				{
					mc.gotoAndStop(mc.totalFrames);
				}
				else
				{
					mc.gotoAndStop(1);
					mc.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
				}
			}
			else
			{
				mc.prevFrame();
			}
		}
		/**
		 * 停止对象和对象全部子项的动画 
		 * @param target 停止对象
		 * @param frameNo 停止到X帧 0或小于0 直接停止
		 * 
		 */		
		public static function stopAllMovieClipAndChild(target:DisplayObjectContainer,frameNo:int = 0):void
		{
			if(target is MovieClip)
			{
				if(frameNo <= 0)
				{
					MovieClip(target).stop();
				}
				else
				{
					MovieClip(target).gotoAndStop(frameNo);
				}
			}
			for(var i:int = 0; i < target.numChildren;i++)
			{
				if(target.getChildAt(i) is MovieClip)
				{
					stopAllMovieClipAndChild(target.getChildAt(i) as MovieClip);
				}
					
			}
		}
		/**
		 * 播放对象和对象全部子项的动画 
		 * @param target 播放对象
		 * @param frameNo 播放到X帧 0或小于0 直接播放
		 * 
		 */		
		public static function playAllMovieClipAndChild(target:DisplayObjectContainer,frameNo:int = 0):void
		{
			if(target is MovieClip)
			{
				if(frameNo <= 0)
				{
					MovieClip(target).play();
				}
				else
				{
					MovieClip(target).gotoAndPlay(frameNo);
				}
			}
			for(var i:int = 0; i < target.numChildren;i++)
			{
				if(target.getChildAt(i) is MovieClip)
				{
					playAllMovieClipAndChild(target.getChildAt(i) as MovieClip);
				}
			}
		}
	}
}