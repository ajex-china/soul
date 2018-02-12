package soul.ui
{
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	import soul.events.TweenEvent;
	import soul.interFace.IScrollContent;
	import soul.tween.TweenLite;
	import soul.utils.Util;
	
	
	[Event(name="start",type="com.base.events.TweenEvent")]
	[Event(name="complete",type="com.base.events.TweenEvent")]
	[Event(name="change",type="com.base.events.TweenEvent")]
	
	/**
	 * 滚动条 
	 * 
	 * 标签规则：和Silder相同
	 * 
	 * 
	 * 
	 */
	public class ScrollBar extends Silder
	{
		private var _scrollContent:IScrollContent;
		
		private var _isDisable:Boolean = true;
		
		private var _target:*;
		
		/**
		 * 缓动时间
		 */		
		public var duration:Number = 0.5;
		
		/**
		 *外部设置是否缓动 
		 */		
		public var isTween:Boolean = true;
		
		/**
		 * 当前是否在缓动中
		 */		
		protected var tweening:Boolean = false;
		
		public function ScrollBar(skin:*=null)
		{
			super(skin);
			detra = 40;
		}
		override protected function setStyle():void
		{
			//isThumbSize = true;
			direction = "V";
			setSize(14,320,false);
		}
		/**
		 * 设置要滚动的目标(用于UI内部设置，如须单独设置请用setTarget)
		 * @return 
		 * 
		 */
		public function get target():*
		{
			return _target;
		}
		
		public function set target(v:*):void
		{
			if (_target)
				_target.removeEventListener(Event.SCROLL,scrollHandler);
			
			_target = v;
			
			if (!v)
				return;
			
			if (v is IScrollContent)
				_scrollContent = v as IScrollContent;
				//			else if (_target is TextField)
				//				_scrollContent = new ScrollTextContent(_target as TextField);
			else
			{
				if (v.parent && v.parent is IScrollContent && (v.parent as IScrollContent).content == v)
				{
					_scrollContent = v.parent as IScrollContent;
				}
				//				else	
				//				{
				//					if(!_scrollContent) _scrollContent = new ScrollContainer();
				//				}
				
			}
			
			if (_scrollContent)
				_scrollContent.addEventListener(Event.SCROLL,scrollHandler);
			
			//			updateThumb();
			//			updataSize();
		}
		
		public function get scrollContent():IScrollContent
		{
			return _scrollContent;
		}
		
		/** @inheritDoc*/
		public override function get value():Number
		{
			if (!scrollContent)
				return NaN;
			
			return (direction == "H") ? _scrollContent.scrollH : _scrollContent.scrollV;
		}
		/**
		 *滚动值 
		 * @param v
		 * 
		 */		
		public override function set value(v:Number):void
		{
			if (direction == "H")
				_scrollContent.scrollH = v; 
			else
				_scrollContent.scrollV = v;
			
			super.value = v;
		}
		
		
		private var _pageLength:Number;
		
		
		public function get pageLength():Number
		{
			if (_pageLength)
			{
				return _pageLength;
			}
			else
			{
				var sr:Rectangle = (_scrollContent as DisplayObject).scrollRect;
				return direction == "H" ? sr.width : sr.height;
			}
		}
		
		/**
		 * 单页长度 
		 */
		public function set pageLength(v:Number):void
		{
			_pageLength = v;
		}
		
		/**
		 * 页数
		 * @return 
		 * 
		 */
		public function get page():int
		{
			return Math.ceil(value / pageLength) + 1;
		}
		
		/**
		 * 总页数
		 * @return 
		 * 
		 */
		public function get maxPage():int
		{
			return Math.ceil(maxValue / pageLength) + 1;
		}
		/**
		 *最大滚动值 
		 * @return 
		 * 
		 */		
		public override function get maxValue():Number
		{
			return (direction == "H") ? _scrollContent.maxScrollH : _scrollContent.maxScrollV;
		}
		/**
		 *最小滚动值 
		 * @return 
		 * 
		 */		
		public override function get minValue():Number
		{
			return 0;
		}
		
		/** @inheritDoc*/
		public override function get percent():Number
		{
			if (!_scrollContent)
				return NaN;
			
			return (direction == "H") ? _scrollContent.scrollH / _scrollContent.maxScrollH : _scrollContent.scrollV / _scrollContent.maxScrollV;
		}
		/**
		 *滚动百分比 
		 * @param v
		 * 
		 */		
		public override function set percent(v:Number):void
		{
			if (!_scrollContent)
				return;
			
			if (direction == "H")
				_scrollContent.scrollH = _scrollContent.maxScrollH * v; 
			else
				_scrollContent.scrollV = _scrollContent.maxScrollV * v;
		}
		
		/**
		 * 重置滚动 
		 * 
		 */
		public function resetContent(x:Boolean = true,y:Boolean = true):void
		{
			if (x)
			{
				_scrollContent.scrollH = 0.0;
			}
			if (y)
			{
				_scrollContent.scrollV = 0.0;
			}	
			updateThumb();
		}
		/**
		 * 单独设置滚动目标
		 * 
		 * @param target	对象 （不能直接使用需要滚动的目标作为对象，必须创建父容器作为对象 且父容器不可伸缩）
		 * @param width	对象的滚动大小
		 * @param height	对象的滚动大小
		 * @param overrideWheelDirect	重置目标的鼠标滚动方向
		 */
		public function setTarget(target:InteractiveObject,width:Number = NaN,height:Number = NaN, overrideWheelDirect:Boolean = true, wheelSpeed:Number = NaN):void
		{
			this.target = target;
			
			
			
			_scrollContent = new TargetScrollContent(this,target);
			
			if (overrideWheelDirect)
			{
				_scrollContent.wheelDirect = this.direction;
				if (!isNaN(wheelSpeed))
					_scrollContent.wheelSpeed = wheelSpeed;
			}
			
			setTargetScrollSize(width,height);
		}
		
		/**
		 * 设置目标的滚动大小
		 * @param rect
		 * 
		 */
		public function setTargetScrollSize(width:Number = NaN,height:Number = NaN):void
		{
			if (isNaN(width) && isNaN(height))
				return;
			
			if (isNaN(width))
				width = (target as DisplayObject).width;
			
			if (isNaN(height))
				height = (target as DisplayObject).height;
			
			target.scrollRect = new Rectangle(0,0,width,height);
			Util.breakScrollRect(target);
			vaildNow();
		}
		
		//暂时取消 防止单放置scrollBar时由于_scrollContent不存在Thumb的位置叠在其他按钮上
		//		public override function updateThumb():void
		//		{
		//			if (!_scrollContent)
		//				return;
		//			super.updateThumb();
		//		}
		protected function updateThumbPosition():void
		{
			percent = percent;
		}
		protected function updataThumbSize():void
		{
			if(!_target) 
			{
				updateThumbPosition();//单放置调节thumb位置
				return;
			}
			var length:Number;
			if(direction == "V")
			{
				length = BaseHeight-(upArrow?upArrow.height:0)-(downArrow?downArrow.height:0);
				thumb.height = (target.height > _scrollContent.realHeight?1:target.height/_scrollContent.realHeight)*length;
				//trace((target.height > _scrollContent.realHeight?1:target.height/_scrollContent.realHeight)*length);
				if(thumb.height < 5) 
				{
					thumb.height = 0;
				}
				//				else if(thumb.height > length/2)
				//				{
				//					thumb.height = length/2;
				//				}
				if(target.height >= _scrollContent.realHeight)
				{
					this.disable = false;
				}
				else
				{
					this.disable = true;
				}
			}
			else
			{
				length = BaseWidth-(upArrow?upArrow.width:0)-(downArrow?downArrow.width:0);
				thumb.width = (target.width > _scrollContent.realWidth?1:target.width/_scrollContent.realWidth)*length;
				if(thumb.width < 5) 
				{
					thumb.width = 0;
				}
				//				else if(thumb.width > length/2)
				//				{
				//					thumb.width = length/2;
				//				}
				if(target.width >= _scrollContent.realWidth)
				{
					this.disable = false;
				}
				else
				{
					this.disable = true;
				}
			}
			updateThumbPosition();
		}
		
		/**
		 * 向上按钮点击事件
		 * @param event
		 * 
		 */
		protected override function upArrowClickHandler(event:MouseEvent):void
		{
			var t:Number = direction == "H" ? scrollContent.scrollH : scrollContent.scrollV;
			
			toValue(t - detra)
		}
		
		/**
		 * 向下按钮点击事件
		 * @param event
		 * 
		 */
		protected override function downArrowClickHandler(event:MouseEvent):void
		{
			var t:Number = direction == "H" ? scrollContent.scrollH : scrollContent.scrollV;
			
			toValue(t + detra);
		}
		
		/**
		 * 缓动到值
		 * @param v 滚动值
		 * @param tween 是否缓动
		 * @param update 是否更新滑动块（如果由滑动块造成的滚动值变化就不需要更新滑动块）
		 * 
		 */
		public function toValue(v:Number,tween:Boolean = true):void
		{
			v = Math.max(Math.min(v,maxValue),minValue);
			if(int(v) == int(value)) return;
			if(isTween&&tween)
			{
				if (direction == "H")
				{
					TweenLite.killTweensOf(_scrollContent);
					TweenLite.to(_scrollContent,duration,{scrollH:v,onStart:tweenStartHandler,onUpdate:tweenUpdateHandler,onComplete:tweenCompleteHandler});
					
					
					dispatchEvent(new Event(Event.CHANGE));
					
				}
				else
				{
					TweenLite.killTweensOf(_scrollContent);
					TweenLite.to(_scrollContent,duration,{scrollV:v,onStart:tweenStartHandler,onUpdate:tweenUpdateHandler,onComplete:tweenCompleteHandler});
					
					
					dispatchEvent(new Event(Event.CHANGE));
					
				}
			}
			else
			{
				value = v;
			}
		}
		
//		override public function updateThumb():void//停止目标缓动时 因为scroll事件更新滚动条
//		{
//			if(tweening) return;
//			super.updateThumb();
//		}
		
		
		/**
		 *缓动开始方法 
		 * 
		 */		
		protected function tweenStartHandler():void
		{
			tweening = true;
			this.dispatchEvent(new TweenEvent(TweenEvent.START));
		}
		
		/**
		 * 缓动更新方法 
		 * 
		 */		
		protected function tweenUpdateHandler():void
		{
			this.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
			//			trace(update,_scrollContent.scrollV,thumbY);
			//			if(update) updateThumb();
		}
		
		
		/**
		 * 缓动结束方法
		 * 
		 */
		protected function tweenCompleteHandler():void
		{
			this.dispatchEvent(new TweenEvent(TweenEvent.COMPLETE));
			tweening = false;
		}
		
		/** @inheritDoc*/
		protected override function thumbMouseMoveHandler():void
		{
			
			if (!_scrollContent)
				return;
			var v:Number;
			if (direction == "H")
				v = _scrollContent.maxScrollH * (thumbX - thumbAreaStart) / thumbAreaLength;
			else
				v = _scrollContent.maxScrollV * (thumbY - thumbAreaStart) / thumbAreaLength;
			
			toValue(v,true);
			
		}
		
		protected function scrollHandler(event:Event):void
		{
			updateThumb();
		}
		
		private var _oldThumbX:Number;
		private var _oldThumbY:Number;
		override protected function set thumbX(tx:Number):void
		{
			_oldThumbX = super.thumbX
			super.thumbX = tx;
		}
		
		override protected function set thumbY(ty:Number):void
		{
			_oldThumbY = super.thumbY;
			super.thumbY = ty;
		}
		protected var upTweenObject:Object = new Object();
		override protected function stageUpHandler(e:MouseEvent):void
		{
			super.stageUpHandler(e);
			if(!isDrag) return;//change21 2015.9.21
			upTweenObject.thumbX = thumbX;
			upTweenObject.thumbY = thumbY;
			if (direction == "H")
			{
				TweenLite.to(upTweenObject,duration,{thumbX:thumbX - (_oldThumbX - thumbX),onUpdate:upTweenUpdate});
			}
			else
			{
				TweenLite.to(upTweenObject,duration,{thumbY:thumbY - (_oldThumbY - thumbY),onUpdate:upTweenUpdate});
			}
		}
		protected function upTweenUpdate():void
		{
			if (direction == "H")
			{
				thumbX = upTweenObject.thumbX;
			}
			else
			{
				thumbY = upTweenObject.thumbY;
			}
		}
		protected override function updateSize():void
		{
			updataThumbSize();
			super.updateSize();
			if(direction == "H")
			{
				if(upArrow) upArrow.height = BaseHeight;
				if(downArrow) downArrow.height = BaseHeight;
				if(background) background.height = BaseHeight;
				if(thumb) thumb.height = BaseHeight;
			}
			else
			{
				if(upArrow) upArrow.width = BaseWidth;
				if(downArrow) downArrow.width = BaseWidth;
				if(background) background.width = BaseWidth;
				if(thumb) thumb.width = BaseWidth;
			}
		}
		
		override protected function updateDisplayList():void
		{
			updataThumbSize();
			super.updateDisplayList();
		}
		/**
		 *是否可用 
		 * @return 
		 * 
		 */		
		public function get isDisable():Boolean
		{
			return _isDisable;
		}
		
		/**
		 *滚轴内部判断当前对象大小是否需要滚动 
		 */
		protected function get disable():Boolean
		{
			return _isDisable;
		}
		
		/**
		 * @private
		 */
		protected function set disable(value:Boolean):void
		{
			_isDisable = value;
			this.visible = value;
		}
		
		//		protected override function enabledHandler(v:Boolean):void
		//		{
		//			if(enabled&&disable)
		//			{
		//				super.enabledHandler(true);
		//			}
		//			else
		//			{
		//				super.enabledHandler(false);
		//			}
		//		}
		
		/** @inheritDoc*/
		public override function destory() : void
		{
			target.scrollRect = null;
			target = null;
			_scrollContent = null;
			
			super.destory();
		}
	}
}