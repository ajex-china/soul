package soul.ui
{
	import soul.display.BaseSprite;
	import soul.events.ResizeEvent;
	import soul.events.UIEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import soul.interFace.IUIComponent;
	import soul.manager.ToolTipMananger;
	import soul.ui.skin.Skin;
	import soul.utils.Util;
	
	/**
	 *所有UI的基类 
	 * @author Ajex
	 * 
	 */	
	public class UIComponent extends BaseSprite implements IUIComponent
	{
		/**
		 * 是否激活延时更新事件(可以在多次改变需要更新显示的属性时，只更新显示一次)
		 */
		public var enabledDelayUpdate:Boolean = true;
		
		private var _enabled:Boolean = true;
		private var _toolTip:String;
		private var _skin:Skin;
		/**
		 * 是否重写size(使用updatasize控制) 
		 */		
		protected var isResize:Boolean = true;
		
		/**
		 *是否正在延时执行 更新大小
		 */		
		protected var isDelayUpdateSize:Boolean;
		
		/**
		 *是否正在延时执行 更新显示对象 
		 */		
		protected var isDelayUpdateDisplayList:Boolean;
		protected var delayTime:Number = 200;
		
		protected var _clipContent:Boolean = true;
		
		//设置后的长宽 主要用来防止scrollBar中scrollRect大小BUG
		protected var BaseWidth:Number = 0;
		protected var BaseHeight:Number = 0;
		
		protected var _data:Object;
		
		
		public function UIComponent(skin:Class=null)
		{
			super();
			if(skin) 
			{
				setSkin(skin);
			}
			else
			{
				setDefaultSkin();
			}
			constructor();
			setStyle();
			this.cacheAsBitmap = true;
		}
		/**
		 * 设置皮肤后执行 用于执行可重写的构造函数 
		 * 
		 */		
		protected function constructor():void
		{
			
		}
		/**
		 *constructor后执行 用于设置样式 
		 * 
		 */		
		protected function setStyle():void
		{
		
		}
		
		/**
		 *设置默认皮肤 
		 * 
		 */		
		public function setDefaultSkin():void
		{
			
		}
		/**
		 * 设置皮肤 
		 * @param skinClass 皮肤类
		 * 
		 */		
		public function setSkin(skinClass:Class):void
		{
			var skin:Skin = new skinClass(this);
			_skin = skin;
		}
		
		override protected function init():void
		{
			super.init();
			vaildNow();
		}
		
		/**
		 * 设置数据 
		 * @return 
		 * 
		 */		
		
		public function get data():*
		{
			return _data;
		}
		
		public function set data(value:*):void
		{
			_data = value;
			dispatchEvent(new UIEvent(UIEvent.DATA_CHANGE));
		}
		
		
		public override function set width(value:Number) : void
		{
			if(BaseWidth == value) return;
			BaseWidth = value;
			if(!BaseHeight) BaseHeight = super.height;
			if (isResize)
			{
				setSize(BaseWidth,BaseHeight,true,true)
			}
			else
			{
				super.width = value;
			}
		}
		
		public override function set height(value:Number) : void
		{
			if(BaseHeight == value) return;
			BaseHeight = value;
			if(!BaseWidth) BaseWidth = super.width;
			if (isResize)
			{
				setSize(BaseWidth,BaseHeight,true,true)
			}
			else
			{
				super.height = value;
			}
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		/**
		 *组件可用状态 
		 * @param v
		 * 
		 */		
		public function set enabled(v:Boolean):void
		{
			_enabled = v;
		}
		
		/**
		 * 立即更新显示 
		 * @param noEvent 是否发送事件
		 */
		public function vaildNow(noEvent:Boolean = false):void
		{
			vaildSize(false,noEvent);
			vaildDisplayList(false,noEvent);
		}
		
		private var delaySizeTimeID:uint;
		/**
		 * 设置ui大小
		 * @param width 宽
		 * @param height 高
		 * @param isDelay 是否延时
		 * @param noEvent 是否发送事件
		 * 
		 */		
		public function setSize(width:Number,height:Number,isDelay:Boolean = true,noEvent:Boolean = false):void
		{
			BaseWidth = width;
			BaseHeight = height;
			if(_clipContent)
			{
				this.scrollRect = new Rectangle(0,0,width,height);
				Util.breakScrollRect(this);
			}
			vaildSize(isDelay,noEvent);
		}
		/**
		 *  更新大小
		 * @param isDelay 是否延时
		 * @param noEvent 是否发送事件
		 * 
		 */		
		public function vaildSize(isDelay:Boolean = false,noEvent:Boolean = false):void
		{
			if(!isDelay||!enabledDelayUpdate)
			{
				changeSizeHandler(noEvent);
			}
			else
			{
				invalidateSize();
			}
		}
		
		/**
		 *稍后更新大小 
		 * 
		 */		
		protected function invalidateSize():void
		{
			if(isDelayUpdateSize)
			{
				return;
			}
			isDelayUpdateSize = true;
			delaySizeTimeID = setTimeout(changeSizeHandler,delayTime)
		}
		protected function changeSizeHandler(noEvent:Boolean = false):void
		{
			clearTimeout(delaySizeTimeID);
			isDelayUpdateSize = false;
			
			if(noEvent)
			{
				var event:ResizeEvent = new ResizeEvent(ResizeEvent.RESIZE);
				event.oldWidth = super.width;
				event.oldHeight = super.height;
				event.width = BaseWidth;
				event.height = BaseHeight;
				this.dispatchEvent(event);
			}
			
			updateSize();
		}
		
		/**
		 *更改大小后执行 
		 * 
		 */		
		protected function updateSize():void
		{
			
		}
		/**
		 * 更新显示对象列表 
		 * @param isDelay 是否延时
		 * @param noEvent 是否发送事件
		 * 
		 */		
		public function vaildDisplayList(isDelay:Boolean = false,noEvent:Boolean = false):void
		{
			if(!isDelay||!enabledDelayUpdate)
			{
				changeDisplayListHandler(noEvent);
			}
			else
			{
				invalidateDisplayList();
			}
		}
		
		private var delayDisplayListTimeID:uint;
		
		/**
		 *稍后更新显示列表 
		 * 
		 */		
		protected function invalidateDisplayList():void
		{
			if(isDelayUpdateDisplayList)
			{
				return;
			}
			isDelayUpdateDisplayList = true;
			delayDisplayListTimeID =  setTimeout(changeDisplayListHandler,delayTime)
		}
		
		protected function changeDisplayListHandler(noEvent:Boolean = false):void
		{
			clearTimeout(delayDisplayListTimeID);
			isDelayUpdateDisplayList = false;
			if (!noEvent)
				dispatchEvent(new UIEvent(UIEvent.UPDATE_COMPLETE));
			
			updateDisplayList();
		}
		
		/**
		 * 更新显示的操作
		 * 
		 */
		protected function updateDisplayList(): void
		{
		}
		/**
		 *
		 * 当前容纳的皮肤
		 * @return 
		 * 
		 */		
		
		
		public function get toolTip():String
		{
			return _toolTip;
		}
		
		public function set toolTip(value:String):void
		{
			_toolTip = value;
			if(_toolTip)
			{
				ToolTipMananger.addToolTip(this,_toolTip);
			}
			else
			{
				ToolTipMananger.removeToolTip(this);
			}
		}
		override public function destory():void
		{
			super.destory();
			
			clearTimeout(delaySizeTimeID);
			clearTimeout(delayDisplayListTimeID);
			ToolTipMananger.removeToolTip(this);
			_data = null;
			_skin = null;
		}
		/**
		 *修改单一皮肤 请用这个方法 
		 * @param skinName 皮肤名字
		 * @param skin 皮肤对象
		 * 
		 */		
		public function changeSkin(skinName:String,skin:DisplayObject):void
		{
			var skinDis:DisplayObject = this[skinName];
			if(!skinDis)
			{
				throw new Error("替换的皮肤不存在！");
				return;
			}
			var skinX:Number = skinDis.x;
			var skinY:Number = skinDis.y;
			var skinWidth:Number = skinDis.width;
			var skinHeight:Number = skinDis.height;
			var skinParent:DisplayObjectContainer = skinDis.parent;
			var index:int = skinParent?skinParent.getChildIndex(skinDis):0;
			
			if(skinDis is InteractiveObject)
			{
				InteractiveObject(skin).mouseEnabled = InteractiveObject(skinDis).mouseEnabled;
			}
			if(skinDis is DisplayObjectContainer)
			{
				DisplayObjectContainer(skin).mouseChildren = DisplayObjectContainer(skinDis).mouseChildren;
			}
			if(skinDis is Sprite)
			{
				Sprite(skin).buttonMode = Sprite(skinDis).buttonMode;
			}
			if(skinDis is BaseSprite)
			{
				var typeList:Array = BaseSprite(skinDis).getEventTypeList();
				var functionList:Array = BaseSprite(skinDis).getEventFunctionList();
			}
			if(typeList)
			{
				for(var i:int = 0;i < typeList.length;i++)
				{
					skin.addEventListener(typeList[i],functionList[i]);
				}
			}
			if(skinDis is UIComponent)
			{
				UIComponent(skinDis).destory();
			}
			else
			{
				if(skinParent)
				{
					skinParent.removeChild(skinDis);
				}
			}
			skin.x = skinX;
			skin.y = skinY;
			skin.width = skinWidth;
			skin.height = skinHeight;
			this[skinName] = skin;
			if(skinParent)
			{
				skinParent.addChildAt(skin,index);
			}
		}

		/**
		 * 是否设置矩形限制(设置为true超过长宽部分将不再显示 如果设置为false 设置的长宽和实际的长宽某些组件会不一样) 
		 * 默认设置为true 设置为true将有可能造成mask不正常 如果要设置mask 请把此属性设置为false
		 */
		public function get clipContent():Boolean
		{
			return _clipContent;
		}

		/**
		 * @private
		 */
		public function set clipContent(value:Boolean):void
		{
			if(_clipContent == value) return;
			_clipContent = value;
			if(_clipContent == true)
			{
				this.scrollRect = new Rectangle(0,0,BaseWidth,BaseHeight);
			}
			else
			{
				this.scrollRect = null;
				
			}
			Util.breakScrollRect(this);
		}

	}
}