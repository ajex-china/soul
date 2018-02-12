package soul.other
{
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.geom.Rectangle;
	
	import soul.utils.Util;

	/**
	 *  
	 * 公共自适应类(跟autoResize不同的是，他不是根据舞台来自适应的，而且只执行一次)
	 * 
	 */	
	public class ResizeClass
	{
		public static var target:DisplayObject;
		public static var resizeDisplay:DisplayObject;
		public static var rect:Rectangle;
		public static var top:Number;
		public static var left:Number;
		public static var right:Number;
		public static var bottom:Number;
		private static var resizeDisplayClip:Rectangle;
		/**
		 * 
		 * @param target  自适应目标
		 * @param resizeDisplay 自适应对象的自适应参考对象（一般为父对象）
		 * @param rect 自适应的大小
		 * @param isClip 是否强制剪裁到rect的大小(剪裁时可能会引发跨域问题)
		 * @param type 自适应规则 0:全屏缩小自适应 1:全自适应 2:顶部自适应 3:居中自适应 4:底部自适应 5:根据left top right bottom自适应
		 * 
		 */		
		public static function resize(target:DisplayObject,resizeDisplay:DisplayObject,rect:Rectangle,isClip:Boolean=true,type:int = 0,left:Number = NaN,top:Number = NaN,right:Number = NaN,bottom:Number = NaN):void
		{
			ResizeClass.target = target;
			ResizeClass.resizeDisplay = resizeDisplay;
			ResizeClass.rect = rect;
			ResizeClass.top = top;
			ResizeClass.left = left;
			ResizeClass.right = right;
			ResizeClass.bottom = bottom;
			resizeDisplayClip = new Rectangle();
			if(ResizeClass.target.scrollRect)
			{
				if(ResizeClass.target.scrollRect.width!=rect.width||ResizeClass.target.scrollRect.height!=rect.height)
				{
					if(isClip)
					{
						ResizeClass.target.scrollRect = rect;
						Util.breakScrollRect(ResizeClass.target);
					}
				}
			}
			else
			{
				if(isClip)
				{
					ResizeClass.target.scrollRect = rect;
					Util.breakScrollRect(ResizeClass.target);
				}
			}
			if(resizeDisplay is Stage)
			{
				resizeDisplayClip.width = (resizeDisplay as Stage).stageWidth;
				resizeDisplayClip.height = (resizeDisplay as Stage).stageHeight;
			}
			else
			{
				resizeDisplayClip.width = resizeDisplay.width;
				resizeDisplayClip.height = resizeDisplay.height;
			}
			switch(type)
			{
				case -1:
				{
					centerScaleAuto();
					break;
				}
				case 0:
				{
					scaleAuto();
					break;
				}
				case 1:
				{
					autoStage();
					break;
				}
				case 2:
				{
					top_center();
					break;
				}
				case 3:
				{
					middle_center();
					break;
				}
				case 4:
				{
					bottom_center();
					break;
				}
				case 5:
				{
					corner();
					break;
				}
				default:
				{
					scaleAuto();
					break;
				}
			}
		}
		public static function centerScaleAuto():void
		{
			var scale:Number;
			if(resizeDisplayClip.width/resizeDisplayClip.height > rect.width/rect.height)
			{
				scale = resizeDisplayClip.height/rect.height;
				ResizeClass.target.scaleX = scale;
				ResizeClass.target.scaleY = scale;
			}
			else
			{
				scale = resizeDisplayClip.width/rect.width;
				ResizeClass.target.scaleX = scale;
				ResizeClass.target.scaleY = scale;
			}
			if(!isNaN(ResizeClass.left))
			{
				ResizeClass.target.x = ResizeClass.left
			}
			else if(!isNaN(ResizeClass.right))
			{
				ResizeClass.target.x = resizeDisplayClip.width - ResizeClass.target.width - ResizeClass.right;
			}
			else
			{
				ResizeClass.target.x = resizeDisplayClip.width/2 - ResizeClass.target.width/2;
			}
			if(!isNaN(ResizeClass.top))
			{
				ResizeClass.target.y = ResizeClass.top;
			}
			else if(!isNaN(ResizeClass.bottom))
			{
				ResizeClass.target.y = resizeDisplayClip.height - ResizeClass.target.height - ResizeClass.bottom;
			}
			else
			{
				ResizeClass.target.y = resizeDisplayClip.height/2 - ResizeClass.target.height/2;
			}
		}
		public static function scaleAuto():void
		{
			var scale:Number;
			if(resizeDisplayClip.width/resizeDisplayClip.height < rect.width/rect.height)
			{
				scale = resizeDisplayClip.height/rect.height;
				ResizeClass.target.scaleX = scale;
				ResizeClass.target.scaleY = scale;
			}
			else
			{
				scale = resizeDisplayClip.width/rect.width;
				ResizeClass.target.scaleX = scale;
				ResizeClass.target.scaleY = scale;
			}
			if(!isNaN(ResizeClass.left))
			{
				ResizeClass.target.x = ResizeClass.left
			}
			else if(!isNaN(ResizeClass.right))
			{
				ResizeClass.target.x = resizeDisplayClip.width - ResizeClass.target.width - ResizeClass.right;
			}
			else
			{
				ResizeClass.target.x = resizeDisplayClip.width/2 - ResizeClass.target.width/2;
			}
			if(!isNaN(ResizeClass.top))
			{
				ResizeClass.target.y = ResizeClass.top;
			}
			else if(!isNaN(ResizeClass.bottom))
			{
				ResizeClass.target.y = resizeDisplayClip.height - ResizeClass.target.height - ResizeClass.bottom;
			}
			else
			{
				ResizeClass.target.y = resizeDisplayClip.height/2 - ResizeClass.target.height/2;
			}
			
			
		}
		public static  function autoStage():void
		{
			ResizeClass.target.width = resizeDisplayClip.width;
			ResizeClass.target.height = resizeDisplayClip.height;
		}
		public static  function top_center():void
		{
			ResizeClass.target.x = resizeDisplayClip.width/2 - ResizeClass.target.width/2;
			ResizeClass.target.y = 0;
		}
		public static  function middle_center():void
		{
			ResizeClass.target.x = resizeDisplayClip.width/2 - ResizeClass.target.width/2;
			ResizeClass.target.y = resizeDisplayClip.height/2 - ResizeClass.target.height/2;
		}
		public static  function bottom_center():void
		{
			ResizeClass.target.x = resizeDisplayClip.width/2 - ResizeClass.target.width/2;
			ResizeClass.target.y = resizeDisplayClip.height - ResizeClass.target.height;
		}
		public static  function corner():void
		{
			if(!isNaN(ResizeClass.left))
			{
				ResizeClass.target.x = ResizeClass.left;
			}
			if(!isNaN(ResizeClass.top))
			{
				ResizeClass.target.y = ResizeClass.top;
			}
			if(!isNaN(ResizeClass.right))
			{
				ResizeClass.target.x = resizeDisplayClip.width - ResizeClass.target.width - ResizeClass.right;
			}
			if(!isNaN(ResizeClass.bottom))
			{
				ResizeClass.target.y = resizeDisplayClip.height - ResizeClass.target.height - ResizeClass.bottom;
			}
		}
	}
}