package soul.manager
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import soul.FrameworkInfo;
	import soul.tween.TweenLite;
	import soul.ui.NoticePanel;
	import soul.ui.Panel;
	
	public class PopManager
	{
		public static var defaultPanel:Class = NoticePanel;
		protected static var alphaBack:Sprite = new Sprite();
		public static var isSetAlphaBack:Boolean = false;
//		private static var _isClickHide:Boolean = false;
		public static var winCount:int = 0;
		public static var alphaBackColor:uint = 0x000000;
		public static var backAlpha:Number = 0.5;
		/**
		 * 弹出文字弹窗 
		 * @param content 文字内容
		 * @param type 0:确定单按钮 1:确定双按钮
		 * @param container 弹窗容器  null时为stage
		 * @param popTitle 弹窗头内容
		 * @param panelClass 弹窗类 默认为NoticePanel
		 * @param showPoint 弹出点
		 * @param verifyFunction 确定回调函数
		 * @param verifyParams 确定回调函数参数
		 * @param cancelFunction 取消回调函数
		 * @param cancelParams 取消回调函数参数
		 * 
		 */		
		public static function pop(content:String,type:int,container:DisplayObjectContainer=null,popTitle:String="",panelClass:Class = null,showPoint:Point=null,verifyFunction:Function=null,verifyParams:Array=null,cancelFunction:Function=null,cancelParams:Array=null):void
		{
			if(!container)
			{
				container = FrameworkInfo.stage;
			}
			var p:DisplayObject = PopManager.getPop(content,container);
			if(p)
			{
				rePop(content,container,false);
			}
			
			if(!panelClass) 
			{
				panelClass = defaultPanel;
			}
			showAlphaBack(container);
			var notice:NoticePanel = new panelClass(content,type,popTitle)
			notice.verifyFunction = verifyFunction;
			notice.verifyParams = verifyParams;
			notice.cancelFunction = cancelFunction;
			notice.cancelParams = cancelParams;
			container.addChild(notice);
			winCount++;
			if(!showPoint)
			{
				if(container is Stage)
				{
					notice.x = (container as Stage).stageWidth/2 - notice.width/2;
					notice.y = (container as Stage).stageHeight/2 - notice.height/2;
				}
				else
				{
					notice.x = container.width/2 - notice.width/2;
					notice.y = container.height/2 - notice.height/2;
				}
			}
			else
			{
				notice.x = showPoint.x - notice.width/2;
				notice.y = showPoint.y;
			}
			notice.show();
		}
		/**
		 * 弹出普通弹窗 
		 * @param popClass 弹窗累 必须继承 Panel
		 * @param data 弹窗数据
		 * @param container 弹窗容器  null时为stage
		 * @param showPoint 弹出点
		 * 
		 */		
		public static function popWin(popClass:Class,data:*,container:DisplayObjectContainer=null,showPoint:Point = null):void
		{
			if(!container)
			{
				container = FrameworkInfo.stage;
			}
			
			var p:DisplayObject = PopManager.getPop(popClass,container);
			if(p)
			{
				rePop(popClass,container,false);
			}
			
			showAlphaBack(container);
			var panel:Panel = new popClass();
			if(!panel) return;
			panel.data = data;
			container.addChild(panel);
			winCount++;
			if(!showPoint)
			{
				if(container is Stage)
				{
					panel.x = (container as Stage).stageWidth/2 - panel.width/2;
					panel.y = (container as Stage).stageHeight/2 - panel.height/2;
				}
				else
				{
					panel.x = container.width/2 - panel.width/2;
					panel.y = container.height/2 - panel.height/2;
				}
			}
			else
			{
				panel.x = showPoint.x - panel.width/2;
				panel.y = showPoint.y;
			}
			panel.show();
		}
		/**
		 *  显示对象弹出
		 * @param popObject 显示对象 可以是显示对象 也可以是继承显示对象的类
		 * @param container 弹窗容器  null时为stage
		 * @param showPoint 弹出点
		 * 
		 */		
		public static function popDis(popObject:Object,container:DisplayObjectContainer=null,showPoint:Point = null):void
		{
			if(!container)
			{
				container = FrameworkInfo.stage;
			}
			var p:DisplayObject = PopManager.getPop(popObject,container);
			if(p)
			{
				rePop(p,container,false);
			}
			
			showAlphaBack(container);
			var dis:DisplayObject ;
			if(popObject is Class)
			{
				if(p)
				{
					dis = p;
				}
				else
				{
					var popClass:Class = popObject as Class;
					dis = new popClass();
				}
			}
			else if(popObject is DisplayObject)
			{
				dis = popObject as DisplayObject;
			}
			if(!dis) return;
			container.addChild(dis);
			winCount++;
			if(!showPoint)
			{
				if(container is Stage)
				{
					dis.x = (container as Stage).stageWidth/2 - dis.width/2;
					dis.y = (container as Stage).stageHeight/2 - dis.height/2;
				}
				else
				{
					dis.x = container.width/2 - dis.width/2;
					dis.y = container.height/2 - dis.height/2;
				}
			}
			else
			{
				dis.x = showPoint.x - dis.width/2;
				dis.y = showPoint.y;
			}
			dis.alpha = 0;
			TweenLite.to(dis,0.5,{alpha:1});
		}
		/**
		 * 取消弹出 
		 * @param popObject 弹窗对象
		 * @param container 弹窗容器  null时为stage
		 * @param isTween 是否缓动
		 */		
		public static function rePop(popObject:Object,container:DisplayObjectContainer=null,isTween:Boolean = true):void
		{
			if(!container)
			{
				container = FrameworkInfo.stage;
			}
			var dis:DisplayObject;
			var i:int
			if(popObject is Class)
			{
				var popClass:Class = popObject as Class;
				for(i = 0;i< container.numChildren;i++)
				{
					if(container.getChildAt(i) is popClass)
					{
						dis = container.getChildAt(i);
						break;
					}
				}
			}
			else if(popObject is DisplayObject)
			{
				for(i = 0;i< container.numChildren;i++)
				{
					if(container.getChildAt(i) == popObject)
					{
						dis = container.getChildAt(i);
						break;
					}
				}
			}
			else if(popObject is String)
			{
				for(i = 0; i < container.numChildren;i++)
				{
					if(container.getChildAt(i) is NoticePanel)
					{
						if((container.getChildAt(i) as NoticePanel).noticeText == popObject)
						{
							dis = container.getChildAt(i);
							break;
						}
					}
				}
			}
			if(!dis) return;
			dis.alpha = 1;
			winCount--;
			if(isTween)
			{
				TweenLite.killTweensOf(dis);
				TweenLite.to(dis,0.5,{alpha:0,onComplete:container.removeChild,onCompleteParams:[dis]});
			}
			else
			{
				TweenLite.killTweensOf(dis);
				container.removeChild(dis);
			}
			hideAlphaBack();
		}
		/**
		 * 取消全部弹窗 
		 * @param container  弹窗容器  null时为stage
		 * 
		 */		
		public static function repopAll(container:DisplayObjectContainer=null):void
		{
			if(!container)
			{
				container = FrameworkInfo.stage;
			}
			for(var i:int = 0;i < container.numChildren;i++)
			{
				var notice:Panel = container.getChildAt(i) as Panel;
				if(notice)
				{
					notice.hide(notice.destory);
				}
			}
			winCount = 0;
			hideAlphaBack();
		}
		public static function checkPop(key:*,container:DisplayObjectContainer = null):Boolean
		{
			if(!container)
			{
				container = FrameworkInfo.stage;
			}
			var boo:Boolean = false;
			var i:int = 0;
			if(key is String)
			{
				for(i = 0; i < container.numChildren;i++)
				{
					if(container.getChildAt(i) is NoticePanel)
					{
						if((container.getChildAt(i) as NoticePanel).noticeText == key)
						{
							boo = true;
							break;
						}
					}
				}
			}
			else if(key is Class)
			{
				for(i = 0; i < container.numChildren;i++)
				{
					if(container.getChildAt(i) is key)
					{
						boo = true;
						break;
					}
				}
			}
			else if(key is DisplayObject)
			{
				for(i = 0; i < container.numChildren;i++)
				{
					if(container.getChildAt(i) == key)
					{
						boo = true;
						break;
					}
				}
			}
			return  boo;
		}
		public static function getPop(key:*,container:DisplayObjectContainer = null):DisplayObject
		{
			if(!container)
			{
				container = FrameworkInfo.stage;
			}
			var i:int = 0;
			if(key is String)
			{
				for(i = 0; i < container.numChildren;i++)
				{
					if(container.getChildAt(i) is NoticePanel)
					{
						if((container.getChildAt(i) as NoticePanel).noticeText == key)
						{
							return container.getChildAt(i);
							break;
						}
					}
				}
			}
			else if(key is Class)
			{
				for(i = 0; i < container.numChildren;i++)
				{
					if(container.getChildAt(i) is key)
					{
						return container.getChildAt(i);
						break;
					}
				}
			}
			else if(key is DisplayObject)
			{
				for(i = 0; i < container.numChildren;i++)
				{
					if(container.getChildAt(i) == key)
					{
						return container.getChildAt(i);
						break;
					}
				}
			}
			return  null;
		}
		protected static function showAlphaBack(container:DisplayObjectContainer):void
		{
			if(!isSetAlphaBack) return;
			var wid:Number;
			var hei:Number;
			if(container is Stage)
			{
				wid = Stage(container).stageWidth;
				hei = Stage(container).stageHeight;
			}
			else
			{
				wid = container.width;
				hei = container.height;
			}
			if(!alphaBack.parent) 
			{
				alphaBack.graphics.clear();
				alphaBack.graphics.beginFill(alphaBackColor,backAlpha);
				alphaBack.graphics.drawRect(0,0,wid,hei);
				alphaBack.graphics.endFill();
				container.addChild(alphaBack);
			}
			
		}
		protected static function hideAlphaBack():void
		{
			if(winCount <= 0)
			{
				if(alphaBack.parent) 
				{
					alphaBack.parent.removeChild(alphaBack);
				}
			}
		}

//		public static function get isClickHide():Boolean
//		{
//			return _isClickHide;
//		}
//
//		public static function set isClickHide(value:Boolean):void
//		{
//			_isClickHide = value;
//			alphaBack.addEventListener(MouseEvent.CLICK,clickHandler);
//		}
//		protected static function clickHandler(e:MouseEvent):void
//		{
//			
//		}

	}
}