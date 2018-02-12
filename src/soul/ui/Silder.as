package soul.ui
{
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import soul.FrameworkInfo;
	import soul.ui.skin.HSilderSkin;
	
	[Event(name="change",type="flash.events.Event")]
	/**
	 *滑动组件 
	 * @author Ajex
	 * 
	 */	
	public class Silder extends UIComponent
	{
		public var upArrow:BaseButton;
		public var downArrow:BaseButton;
		public var thumb:BaseButton;
		public var background:UIEnabledDisplay;
		
		//		/**
		//		 *自适应时是否计算 Thumb的大小
		//		 */		
		//		public var isThumbSize:Boolean = false;
		
		
		/**
		 *是否正在拖动滑块 
		 */		
		public var isDrag:Boolean = false;
		
		/**
		 * 拖动起点
		 */
		protected var thumbAreaStart:Number;
		/**
		 * 拖动长度
		 */
		protected var thumbAreaLength:Number;
		
		
		private var _minValue:Number = 0;
		private var _maxValue:Number = 100;
		private var _value:Number = 0;
		
		/**
		 * 旧值 
		 */
		protected var oldValue:Number = 0;
		
		/**
		 * 方向
		 */
		private var _direction:String = "H";
		
		
		/**
		 * 滚动速度
		 */
		public var detra:int = 10;
		
		/**
		 * 快速滚动速度
		 */
		public var pageDetra:int = 25;
		
		public function Silder(skin:Class=null)
		{
			super(skin);
			background.cacheAsBitmap = false;//如果为true 改变长度时可能不会改变
		}
		override public function setDefaultSkin():void
		{
			setSkin(HSilderSkin);
		}
		override protected function constructor():void
		{
			super.constructor();
			if(background)
			{
				this.addChild(background);
				this.background.addEventListener(MouseEvent.MOUSE_DOWN,backgroundHandler);
			}
			if(upArrow) 
			{
				this.addChild(upArrow);
				this.upArrow.addEventListener(MouseEvent.CLICK,upArrowClickHandler);
			}
			if(downArrow)
			{
				this.addChild(downArrow);
				this.downArrow.addEventListener(MouseEvent.CLICK,downArrowClickHandler);
			}
			if(thumb)
			{
				this.addChild(thumb);
				this.thumb.addEventListener(MouseEvent.MOUSE_DOWN,thumbMouseDownHandler);
			}
		}
		
		override protected function setStyle():void
		{
			direction = "H";
			setSize(140,15,false);
		}
		
		//		protected var intervalID:uint;
		//		override protected function init():void
		//		{
		//			stage.addEventListener(MouseEvent.MOUSE_UP,stageUpHandler);
		//			intervalID = setInterval(interval,500);
		//		}
		//		protected function interval():void
		//		{
		//			enabledHandler();
		//		}
		override protected function init():void
		{
			super.init();
			stage.addEventListener(MouseEvent.MOUSE_UP,stageUpHandler);
		}
		override public function set enabled(v:Boolean):void
		{
			super.enabled = v;
			enabledHandler(v);
		}
		/**
		 * 增加上按钮 
		 * @param skin
		 * 
		 */		
		public function addUpArrow(skin:* = null):void
		{
			if(upArrow) return;
			upArrow = new BaseButton(skin);
			this.addChild(upArrow);
			this.upArrow.addEventListener(MouseEvent.CLICK,upArrowClickHandler);
			invalidateSize();
		}
		/**
		 *取消上按钮 
		 * 
		 */		
		public function removeUpArrow():void
		{
			if (upArrow)
			{
				upArrow.destory();
				upArrow = null;
			}
			invalidateSize();
		}
		/**
		 *增加下按钮 
		 * @param skin
		 * 
		 */		
		public function addDownArrow(skin:* = null):void
		{
			if(downArrow) return;
			downArrow = new BaseButton(skin);
			this.addChild(downArrow);
			this.downArrow.addEventListener(MouseEvent.CLICK,downArrowClickHandler);
			invalidateSize();
		}
		
		/**
		 *取消下按钮 
		 * 
		 */		
		public function removeDownArrow():void
		{
			if (downArrow)
			{
				downArrow.destory();
				downArrow = null;
			}
			invalidateSize();
		}
		
		/**
		 * 当前值 
		 * @return 
		 * 
		 */
		public function get value():Number
		{
			return _value;
		}
		
		public function set value(v:Number):void
		{
			oldValue = value;
			
			if (_value == v)
				return;
			_value = v;
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function get maxValue():Number
		{
			return _maxValue;
		}
		/**
		 *最大值 
		 * @param v
		 * 
		 */		
		public function set maxValue(v:Number):void
		{
			_maxValue = v;
		}
		
		public function get minValue():Number
		{
			return _minValue;
		}
		/**
		 *最小值 
		 * @param v
		 * 
		 */		
		public function set minValue(v:Number):void
		{
			_minValue = v;
		}
		
		public function get percent():Number
		{
			return (_value - _minValue) / (_maxValue - _minValue);
		}
		/**
		 *百分比 
		 * @param v
		 * 
		 */		
		public function set percent(v:Number):void
		{
			value = (_maxValue - _minValue) * v + _minValue;
		}
		
		public function get direction():String
		{
			return _direction;
		}
		/**
		 *方向  
		 * @param v
		 * 
		 */		
		public function set direction(v:String):void
		{
			_direction = v;
			invalidateSize();
		}
		
		protected function enabledHandler(v:Boolean):void
		{
			var p:Number = percent;
			if (upArrow)
				upArrow.enabled = !isNaN(p)  && v;				
			
			if (downArrow)
				downArrow.enabled = !isNaN(p)  && v;			
			
			if (thumb)
				thumb.enabled = v
			
			if(background)
				background.enabled = v;
			
			if (thumb)
				thumb.visible =  v;
		}
		
		override protected function updateSize():void
		{
			super.updateSize();
			
			if (direction == "H")
			{
				if (this.downArrow)
					this.downArrow.x = BaseWidth - this.downArrow.width;
				
				thumbAreaStart = upArrow?upArrow.x + upArrow.width:0;
				//thumbAreaLength = (downArrow ? downArrow.x : BaseWidth) - (isThumbSize ? thumb.width : 0) - thumbAreaStart;
				thumbAreaLength = (downArrow ? downArrow.x : BaseWidth)- thumb.width - thumbAreaStart;
				if (background)
					background.width = BaseWidth;
			}
			else
			{
				if (this.downArrow)
					this.downArrow.y = BaseHeight - this.downArrow.height;
				
				thumbAreaStart = upArrow?upArrow.y + upArrow.height:0;
				//thumbAreaLength = (downArrow ? downArrow.y : BaseHeight) - (isThumbSize ? thumb.height : 0) - thumbAreaStart;
				thumbAreaLength = (downArrow ? downArrow.y : BaseHeight) - thumb.height - thumbAreaStart;
				if (background)
					background.height = BaseHeight;
			}
			maxValue = thumbAreaLength;
			updateThumb();
		}
		
		protected override function updateDisplayList():void
		{
			if (direction == "H")
			{
				thumbAreaStart = upArrow?upArrow.x + upArrow.width:0;
				//thumbAreaLength = (downArrow ? downArrow.x : BaseWidth) - (isThumbSize ? thumb.width : 0) - thumbAreaStart;
				thumbAreaLength = (downArrow ? downArrow.x : BaseWidth) -  thumb.width - thumbAreaStart;
			}
			else
			{
				thumbAreaStart = upArrow?upArrow.y + upArrow.height:0;
				//thumbAreaLength = (downArrow ? downArrow.y : BaseHeight) - (isThumbSize ? thumb.height : 0) - thumbAreaStart;
				thumbAreaLength = (downArrow ? downArrow.y : BaseHeight) - thumb.height - thumbAreaStart;
			}
		}
		
		/**
		 * 更新滚动条的位置
		 * 
		 */
		public function updateThumb():void
		{
			if (!thumb)
				return;
			if(isDrag)   //防止拖动时 重复更新滑块
				return;
			
			var v:Number = thumbAreaStart + thumbAreaLength * (percent ? percent : 0);
			//trace(thumbAreaStart,thumbAreaLength,percent,v,this);
			if (direction == "H")
				thumbX = v;
			else
				thumbY = v;
		}
		
		
		/**
		 * 滚动块按下
		 * @param event
		 * 
		 */
		protected function thumbMouseDownHandler(event:MouseEvent):void
		{
			mousePoint.x = thumb.mouseX;
			mousePoint.y = thumb.mouseY;
			isDrag = true;
			this.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		protected function stageUpHandler(e:MouseEvent):void
		{
			if(!isDrag) return;
			this.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
			isDrag = false;
		}
		protected function upArrowClickHandler(event:MouseEvent):void
		{
			value -= detra;
			updateThumb();
		}
		
		protected function downArrowClickHandler(event:MouseEvent):void
		{
			value += detra;
			updateThumb();
		}
		private var mousePoint:Point = new Point();
		protected function enterFrameHandler(e:Event=null):void
		{
			if (direction == "H")
			{
				thumbX = mouseX - mousePoint.x;
				
			}
			else
			{
				thumbY = mouseY- mousePoint.y;
			}
			thumbMouseMoveHandler();
		}
		protected var thx:Number;
		protected var thy:Number;
		/**
		 *thumb的X轴值 
		 * @param tx
		 * 
		 */		
		protected function set thumbX(tx:Number):void//供子类改写缓动用 
		{
			if(tx < thumbAreaStart)
			{
				tx = thumbAreaStart;
			}
			else if(tx >(upArrow?upArrow.width:0) +  thumbAreaLength)
			{
				tx =(upArrow?upArrow.width:0) + thumbAreaLength;
			}
			thx = tx;
			thumb.x = tx;
		}
		protected function get thumbX():Number
		{
			if(isNaN(thx)) return thumb.x;
			return thx;
		}
		/**
		 * thumb的Y轴值 
		 * @param ty
		 * 
		 */		
		protected function set thumbY(ty:Number):void//供子类改写缓动用 
		{
			if(ty < thumbAreaStart)
			{
				ty = thumbAreaStart;
			}
			else if(ty >(upArrow?upArrow.height:0) +  thumbAreaLength)
			{
				ty = (upArrow?upArrow.height:0) + thumbAreaLength;
			}
			thy = ty
			thumb.y = ty;
		}
		protected function get thumbY():Number
		{
			if(isNaN(thy)) return thumb.y;
			return thy;
		}
		/**
		 * 滚动块移动
		 * @param event
		 * 
		 */
		protected function thumbMouseMoveHandler():void
		{
			
			var currentPos:Number = (direction == "H") ? thumbX : thumbY;
			percent = (currentPos - thumbAreaStart) / thumbAreaLength;
		}
		
		/**
		 * 点击背景的方法
		 * @param event
		 * 
		 */
		protected function backgroundHandler(event:MouseEvent):void
		{
			if (isNaN(percent) || !enabled)
				return;
			
			if (direction == "H")
			{
				if (thumb.mouseX > pageDetra + thumb.width)
				{
					thumbX += pageDetra;
				}
				else if (thumb.mouseX < -pageDetra)
				{
					thumbX -= pageDetra;
				}
				else
				{
					//					thumbX += thumb.mouseX;
					if(thumb.mouseX > thumbX)//change22 15.9.21
					{
						thumbX += thumb.mouseX - thumb.width;
					}
					else
					{
						thumbX += thumb.mouseX;
					}
				}
				
				thumbX = Math.max(Math.min(downArrow?downArrow.x - thumb.width:this.width,thumbX),upArrow?upArrow.x + upArrow.width:0)
			}
			else
			{
				if (thumb.mouseY > pageDetra + thumb.height)
				{
					thumbY += pageDetra;
				}
				else if (thumb.mouseY < -pageDetra)
				{
					thumbY -= pageDetra;
				}
				else
				{
					//					thumbY += thumb.mouseY;
					if(thumb.mouseY > thumbY)//change22 15.9.21
					{
						thumbY += thumb.mouseY - thumb.height;
					}
					else
					{
						thumbY += thumb.mouseY;
					}
				}
				
				thumbY = Math.max(Math.min(downArrow?downArrow.y - thumb.height:this.height,thumbY),upArrow?upArrow.y + upArrow.height:0)
			}
			thumbMouseMoveHandler();
		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			if (destoryed)
				return;
			
			if (upArrow) 
			{
				upArrow.removeEventListener(MouseEvent.CLICK,upArrowClickHandler);
				upArrow.destory();
				upArrow = null;
			}
			
			if (downArrow) 
			{
				downArrow.removeEventListener(MouseEvent.CLICK,downArrowClickHandler);
				downArrow.destory();
				downArrow = null;
			}
			
			if (thumb) 
			{
				thumb.destory();
				thumb.removeEventListener(MouseEvent.MOUSE_DOWN,thumbMouseDownHandler);
				thumb = null;
			}
			
			if (background)
			{
				background.destory()
				background.removeEventListener(MouseEvent.MOUSE_DOWN,backgroundHandler);
				background = null;
			}
			
			if(stage) 
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP,stageUpHandler);
			}
			else
			{
				FrameworkInfo.stage.removeEventListener(MouseEvent.MOUSE_UP,stageUpHandler);
			}
			
			//			clearInterval(intervalID);
			
			super.destory();
		}
		
		
	}
}