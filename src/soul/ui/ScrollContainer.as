package soul.ui
{
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.geom.Transform;
	import flash.utils.clearInterval;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setInterval;
	
	import soul.display.BaseSprite;
	import soul.interFace.IScrollContent;
	import soul.ui.skin.ScrollContainerSkin;
	import soul.utils.Util;
	/**
	 *滚动容器 
	 * @author Ajex
	 * 
	 */	
	public class ScrollContainer extends UIComponent implements IScrollContent
	{
		/**
		 * 横向滚动条
		 */
		public var hScrollBar:HScrollBar;
		
		/**
		 * 纵向滚动条
		 */
		public var vScrollBar:VScrollBar;
		
		private var _oldScrollH:int;
		private var _oldScrollV:int;
		
		public var container:BaseSprite;//大容器 用来包装子容器 和 显示滚动
		public var childContainer:BaseSprite;//子容器 同来包装所有自对象 和 获得真实大小
		//		private var _verticalScrollPolicy:String="AUTO";
		//		
		//		private var _horizontalScrollPolicy:String="AUTO";
		
		
		//		public var isSetCliped:Boolean = false;
		
		
		public var background:DisplayObject;
		private var _autoUpdateScroll:Boolean;
		
		/**
		 * 是否在设置滚动区域时绘制透明背景
		 */
		public var createScrollArea:Boolean = true;
		
		private var _intervalID:uint;
		public var intervalTime:Number = 500;
		
		
		private var _left:Number = 0;
		private var _right:Number = 0;
		private var _top:Number = 0;
		private var _bottom:Number = 0;
		
		private var _isTween:Boolean = true;
		
		public function ScrollContainer(skin:Class=null)
		{
			super(skin)
		}
		override protected function constructor():void
		{
			super.constructor();
			container = new BaseSprite();
			this.addChildAt(container,0);
			childContainer = new BaseSprite();
			container.addChild(childContainer);
			if(hScrollBar) 
			{
				hScrollBar.target = container;
				this.addChild(hScrollBar);
			}
			if(vScrollBar)
			{
				vScrollBar.target = container;
				this.addChild(vScrollBar);
			}
			if(background) this.addChildAt(background,0);
			
			addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelHandler);
		}
		override protected function setStyle():void
		{
			setSize(300,400,false);
		}
		override public function setDefaultSkin():void
		{
			setSkin(ScrollContainerSkin);
		}
		override protected function init():void
		{
			super.init();
			autoUpdateScroll = true;
		}
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			if(hScrollBar) 
			{
				hScrollBar.enabled = value;
			}
			if(vScrollBar)
			{
				vScrollBar.enabled = value;
			}
		}
		/**
		 * 生成横向滚动条
		 * @param skin
		 * 
		 */
		public function addHScrollBar(skin:* = null):void
		{
			if(hScrollBar) return;
			
			hScrollBar = new HScrollBar(skin)
			hScrollBar.target = container;
			hScrollBar.isTween = _isTween;
			this.addChild(hScrollBar);
			
			invalidateSize();
		}
		
		/**
		 * 生成纵向滚动条
		 * @param skin
		 * 
		 */
		public function addVScrollBar(skin:* = null):void
		{
			if(vScrollBar) return;
			
			vScrollBar = new VScrollBar(skin)
			vScrollBar.target = container;
			vScrollBar.isTween = _isTween;
			this.addChild(vScrollBar);
			
			invalidateSize();
		}
		
		/**
		 * 删除横向滚动条
		 * 
		 */
		public function removeHScrollBar():void
		{
			if (hScrollBar)
			{
				hScrollBar.destory();
				hScrollBar = null;
			}
			invalidateSize();
		}
		
		/**
		 * 删除纵向滚动条 
		 * 
		 */
		public function removeVScrollBar():void
		{
			if (vScrollBar)
			{
				vScrollBar.destory();
				vScrollBar = null;
			}
			invalidateSize();
		}
		
		private var _wheelDirect:String = "V";
		
		
		public function get wheelDirect():String
		{
			return _wheelDirect;
		}
		
		/**
		 * 鼠标滚动方向
		 */
		public function set wheelDirect(value:String):void
		{
			_wheelDirect = value;
		}
		
		
		private var _wheelSpeed:Number = 15;
		
		
		public function get wheelSpeed():Number
		{
			return _wheelSpeed;
		}
		
		/**
		 * 鼠标滚动速度（像素）
		 */
		public function set wheelSpeed(value:Number):void
		{
			_wheelSpeed = value;
		}
		
		
		protected var oldRealWidth:Number;
		protected var oldRealHeight:Number;
		protected function intervalHandler():void
		{
			if(vScrollBar)
			{
				if(vScrollBar.isDrag)
				{
					return;
				}
			}
			if(hScrollBar)
			{
				if(hScrollBar.isDrag)
				{
					return;
				}
			}
			if(oldRealWidth == realWidth && oldRealHeight == realHeight) return;
			oldRealWidth = realWidth;
			oldRealHeight = realHeight;
			updateSize();
		}
		public function get autoUpdateScroll():Boolean
		{
			return _autoUpdateScroll;
		}
		/**
		 * 是否自动更新scroll 
		 * @param value
		 * 
		 */		
		public function set autoUpdateScroll(value:Boolean):void
		{
			if(_autoUpdateScroll == value) return;
			_autoUpdateScroll = value;
			if(_autoUpdateScroll)
			{
				_intervalID = setInterval(intervalHandler,intervalTime);
			}
			else
			{
				clearInterval(_intervalID);
			}
		}
		protected function mouseWheelHandler(event:MouseEvent):void
		{
			if (wheelDirect)
			{
				//				if (wheelDirect == "H")
				//					scrollH = Math.min(maxScrollH,Math.max(0,scrollH - event.delta * wheelSpeed));	
				//				
				//				if (wheelDirect == "V")
				//					scrollV = Math.min(maxScrollV,Math.max(0,scrollV - event.delta * wheelSpeed));
				
				if (wheelDirect == "H")
					hScrollBar.toValue(Math.min(maxScrollH,Math.max(0,scrollH - event.delta * wheelSpeed)));
				if(wheelDirect == "V")
					vScrollBar.toValue(Math.min(maxScrollV,Math.max(0,scrollV - event.delta * wheelSpeed)));
			}
		}
		/**
		 *内部会减去 left right top botton 
		 * @param width
		 * @param height
		 * 
		 */		
		protected function setRect():void
		{
			var rect:Rectangle = new Rectangle();
			rect.x = (container.scrollRect?container.scrollRect.x:0);
			rect.y = (container.scrollRect?container.scrollRect.y:0);
			rect.width = scrWidth - _left - _right;
			rect.height = scrHeight - _top - _bottom;
//			rect.width = scrWidth;
//			rect.height = scrHeight;
			container.scrollRect = rect;
			container.x = _left;
			container.y = _top;
			Util.breakScrollRect(container);
		}
		/**
		 * 返回去掉滚轴的width 
		 * @return 
		 * 
		 */		
		protected function get scrWidth():Number
		{
			return BaseWidth - (vScrollBar?(BaseHeight<realHeight?vScrollBar.width:0):0);
		}
		/**
		 *  返回去掉滚轴的height 
		 * @return 
		 * 
		 */		
		protected function get scrHeight():Number
		{
			return BaseHeight - (hScrollBar?(BaseWidth<realWidth?hScrollBar.height:0):0);
		}
		
		protected override function updateSize() : void
		{
			//			var scrWidth:Number = BaseWidth - (vScrollBar?(vScrollBar.visible?vScrollBar.width:0):0);
			//			var scrHeight:Number = BaseHeight - (hScrollBar?(hScrollBar.visible?hScrollBar.height:0):0);
			
			//因为visible非立即更新 所以采用这种方法
			
			setRect();
			if(background)
			{
				background.width = BaseWidth;
				background.height = BaseHeight;
			}
			if (hScrollBar)
			{
				hScrollBar.x = 0;
				hScrollBar.y = BaseHeight - hScrollBar.height;
				hScrollBar.width = scrWidth;
				hScrollBar.vaildSize();
			}
			
			if (vScrollBar)
			{
				vScrollBar.y = 0;
				vScrollBar.x = BaseWidth - vScrollBar.width - right;
				vScrollBar.height = scrHeight;
				vScrollBar.vaildSize();
			}
			
			
			
		}
		
		protected override function updateDisplayList():void
		{
			if (hScrollBar)
			{
				hScrollBar.vaildDisplayList();
			}
			if (vScrollBar)
			{
				vScrollBar.vaildDisplayList();
			}
			setRect();
		}
		
		public override function set scrollRect(value:Rectangle) : void
		{
			super.scrollRect = value;
			if (createScrollArea)
			{
				this.graphics.clear();
				this.graphics.beginFill(0,0);
				this.graphics.drawRect(value.x,value.y,value.width,value.height);
				this.graphics.endFill();
			}
		}
		protected function setRectPos(value:Number,dir:String):void
		{
			var newPos:Number = value;
			
			if(dir == "V")
			{
				container.scrollRect = new Rectangle(container.scrollRect.x,newPos,container.scrollRect.width,container.scrollRect.height);
			}
			else
			{
				container.scrollRect = new Rectangle(newPos,container.scrollRect.y,container.scrollRect.width,container.scrollRect.height);
			}
			dispatchEvent(new Event(Event.SCROLL));
		}
		/** @inheritDoc*/
		public function get maxScrollH():int
		{
			return Math.max(0,realWidth - ((container.scrollRect?container.scrollRect.width:0) - (vScrollBar?(BaseHeight<container.height?vScrollBar.width:0):0)));
		}
		/** @inheritDoc*/
		public function get maxScrollV():int
		{
			return Math.max(0,realHeight - ((container.scrollRect?container.scrollRect.height:0) - (hScrollBar?(BaseWidth<container.width?hScrollBar.height:0):0)));
		}
		/** @inheritDoc*/
		public function get oldScrollH():int
		{
			return _oldScrollH;
		}
		/** @inheritDoc*/
		public function get scrollH():int
		{
			return	container.scrollRect.x;
		}
		/** @inheritDoc*/
		public function set scrollH(v:int):void
		{
			v = Math.max(0,Math.min(v,maxScrollH))
			
			_oldScrollH = container.scrollRect.x;
			setRectPos(v,"H");
			//content.x = -v;
		}
		/** @inheritDoc*/
		public function get oldScrollV():int
		{
			return _oldScrollV;
		}
		/** @inheritDoc*/
		public function get scrollV():int
		{
			return container.scrollRect.y;
		}
		/** @inheritDoc*/
		public function set scrollV(v:int):void
		{
			v = Math.max(0,Math.min(v,maxScrollV))
			
			_oldScrollV = container.scrollRect.y;
			setRectPos(v,"V");
			//content.y = -v;
		}
		public function get content():DisplayObject
		{
			return container;
		}
		
		override public function get clipContent():Boolean
		{
			return super.clipContent;
		}
		override public function set clipContent(value:Boolean):void
		{
			if(clipContent == value) return;
			super.clipContent = value;
			if(clipContent == true)
			{
				updateSize();
			}
			else
			{
				container.scrollRect = null;
				Util.breakScrollRect(container);
				hScrollBar.visible = false;
				vScrollBar.visible = false;
			}
		}
		
		public function get realWidth():Number
		{
			return childContainer.width;
		}
		
		public function get realHeight():Number
		{
			return	childContainer.height;
		}
		/**
		 *是否缓动 
		 * @param boo
		 * 
		 */		
		public function set isTween(boo:Boolean):void
		{
			_isTween = boo;
			if(hScrollBar) hScrollBar.isTween = boo;
			if(vScrollBar) vScrollBar.isTween = boo;
			
		}
		public function get isTween():Boolean
		{
			return _isTween;
		}
		
		/**
		 * 增加滚动子集 
		 * @param item
		 * 
		 */		
		public function addItem(item:*):void
		{
			addItemAt(item,childContainer.numChildren);
		}
		/**
		 * 增加滚动子集 到索引
		 * @param item
		 * @param index
		 * 
		 */		
		public function addItemAt(item:*,index:uint):void
		{
			if(item is DisplayObject)
			{
				var dis:DisplayObject = item as DisplayObject;
				childContainer.addChildAt(dis,index);
			}
			invalidateDisplayList();
		}
		/**
		 *删除滚动子集 
		 * @param item
		 * 
		 */		
		public function removeItem(item:*):void
		{
			if(item is DisplayObject)
			{
				var dis:DisplayObject = item as DisplayObject;
				if(childContainer.contains(dis)) childContainer.removeChild(dis);
			}
			invalidateDisplayList();
		}
		/**
		 * 删除滚动子集 
		 * @param index
		 * 
		 */		
		public function removeItemAt(index:uint):void
		{
			childContainer.removeChildAt(index);
			invalidateDisplayList();
		}
		/**
		 *删除全部滚动子集 
		 * 
		 */		
		public function removeAllItem():void
		{
			childContainer.removeAllChildren();
			invalidateDisplayList();
		}
		/**
		 *得到index的滚动子集 
		 * @param index
		 * @return 
		 * 
		 */		
		public function getItemAt(index:uint):Object
		{
			return childContainer.getChildAt(index);
		}
		/**
		 *得到 item的index
		 * @param item
		 * @return 
		 * 
		 */		
		public function getItemIndex(item:DisplayObject):int
		{
			return childContainer.getChildIndex(item);
		}
		/**
		 *获得滚动子集的个数 
		 * @return 
		 * 
		 */		
		public function get itemCount():int
		{
			return childContainer.numChildren;
		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (destoryed)
				return;
			this.removeAllItem();
			autoUpdateScroll = false;
			
			if (hScrollBar)
				hScrollBar.destory();
			
			if (vScrollBar)
				vScrollBar.destory();
			
			container.removeAllChildren();
			background = null;
			container = null;
			childContainer = null;
			removeEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelHandler);
			
			super.destory();
		}
		
		public function get left():Number
		{
			return _left;
		}
		/**
		 *左边距 
		 * @param value
		 * 
		 */
		public function set left(value:Number):void
		{
			_left = value;
			invalidateDisplayList();
		}
		
		public function get right():Number
		{
			return _right;
		}
		/**
		 *右边距 
		 * @param value
		 * 
		 */
		public function set right(value:Number):void
		{
			_right = value;
			invalidateDisplayList();
		}
		
		public function get top():Number
		{
			return _top;
		}
		/**
		 *上边距 
		 * @param value
		 * 
		 */
		public function set top(value:Number):void
		{
			_top = value;
			invalidateDisplayList();
		}
		
		public function get bottom():Number
		{
			return _bottom;
		}
		/**
		 *下边距 
		 * @param value
		 * 
		 */
		public function set bottom(value:Number):void
		{
			_bottom = value;
			invalidateDisplayList();
		}
		
		
	}
}