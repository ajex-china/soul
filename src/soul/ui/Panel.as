package soul.ui
{
	
	import soul.display.BaseText;
	import soul.manager.PopManager;
	import soul.tween.TweenLite;
	import soul.ui.skin.PanelSkin;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	/**
	 *窗口
	 * @author Ajex
	 * 
	 */
	public class Panel extends UIComponent
	{
		public static const EXITBUTTON_CLICK:String="exitButton_click";
		
		
		public var topSkin:DisplayObject;
		public var backgroudSkin:DisplayObject;
		public var exitButton:BaseButton;
		public var topLabel:Label;
		public var container:ScrollContainer;
		
		public var defaultFontColor:uint = 0x000000;
		
		private var _isDrag:Boolean = true;
		
		
		private var _showCompleteFunction:Function;
		private var _hideCompleteFunction:Function;
		private var _showParameterList:Array;
		private var _hideParameterList:Array;
		public function Panel()
		{
			super();
		}
		override protected function constructor():void
		{
			super.constructor();
			if(backgroudSkin) this.addChild(backgroudSkin);
			if(topSkin) this.addChild(topSkin);
			if(exitButton) this.addChild(exitButton);
			
			topLabel = new Label();
			topLabel.text="标题";
			topLabel.size = 16;
			topLabel.x = 10;
			topLabel.y = 5;
			topLabel.mouseEnabled = false;
			topLabel.mouseChildren = false;
			this.addChild(topLabel);
			container = new ScrollContainer();
			this.addChild(container);
			
			tweenTime = 0.5;
		}
		override protected function setStyle():void
		{
			setSize(450,300,false);
		}
		override public function setDefaultSkin():void
		{
			setSkin(PanelSkin);
		}
		override protected function init():void
		{
			super.init();
			addEvent();
		}
		protected function addEvent():void
		{
			topSkin.addEventListener(MouseEvent.MOUSE_DOWN,topDownHandler);
			topSkin.addEventListener(MouseEvent.MOUSE_UP,upDownHandler);
			exitButton.addEventListener(MouseEvent.CLICK,exitButtonClickHandler);
		}
		protected function topDownHandler(e:MouseEvent):void
		{
			if(!isDrag) return;
			if(this.parent) this.parent.addChild(this);
			this.startDrag();
		}
		protected function upDownHandler(e:MouseEvent):void
		{
			if(!isDrag) return;
			this.stopDrag();
		}
		protected function exitButtonClickHandler(e:MouseEvent):void
		{
			this.dispatchEvent(new Event(EXITBUTTON_CLICK));
			PopManager.rePop(this,this.parent);
		}
		public function get isDrag():Boolean
		{
			return _isDrag;
		}
		/**
		 * 是否可以拖动
		 * @param value
		 * 
		 */		
		public function set isDrag(value:Boolean):void
		{
			_isDrag = value;
			if(!value) this.stopDrag();
		}
		
//		/**
//		 * 弹出 
//		 * @param completeFunction 结束回调函数
//		 * @param parameterList 回调函数参数
//		 * 
//		 */		
//		public function show(completeFunction:Function = null,parameterList:Array = null):void
//		{
//			_showCompleteFunction = completeFunction;
//			_showParameterList = parameterList;
//			this.alpha = 0;
//			TweenLite.to(this,0.5,{alpha:1,onComplete:completeFunction,onCompleteParams:parameterList})
//		}
//		
//		/**
//		 * 隐藏 
//		 * @param completeFunction 结束回调函数
//		 * @param parameterList 回调函数参数
//		 * 
//		 */		
//		public function hide(completeFunction:Function = null,parameterList:Array = null):void
//		{
//			_hideCompleteFunction = completeFunction;
//			_hideParameterList = parameterList;
//			this.alpha = 1;
//			TweenLite.to(this,0.5,{alpha:0,onComplete:completeFunction,onCompleteParams:parameterList});
//		}
		/**
		 * 增加滚动子集 
		 * @param item
		 * 
		 */		
		public function addItem(item:Object):void
		{
			container.addItem(item);
		}
		/**
		 * 增加滚动子集 到索引 
		 * @param item
		 * @param index
		 * 
		 */		
		public function addItemAt(item:Object,index:uint):void
		{
			container.addItemAt(item,index);
		}
		/**
		 * 删除滚动子集
		 * @param item
		 * 
		 */		
		public function removeItem(item:Object):void
		{
			container.removeItem(item);
		}
		/**
		 * 删除索引处子集 
		 * @param index
		 * 
		 */		
		public function removeItemAt(index:uint):void
		{
			container.removeItemAt(index);
		}
		/**
		 *删除全部滚动子集 
		 * 
		 */		
		public function removeAllItem():void
		{
			container.removeAllItem();
		}
		/**
		 * 获取索引处子集 
		 * @param index
		 * @return 
		 * 
		 */		
		public function getItemAt(index:uint):Object
		{
			return container.getItemAt(index);
		}
		override protected function updateSize():void
		{
			topSkin.width = BaseWidth;
			backgroudSkin.width = BaseWidth;
			exitButton.x = BaseWidth - exitButton.width -10;
			topLabel.width = BaseWidth<100?50:BaseWidth - 50;
			container.width = BaseWidth;
			
			backgroudSkin.height = BaseHeight;
			container.y = topSkin.y + topSkin.height;
			container.height = BaseHeight<topSkin.y + topSkin.height?0:BaseHeight -topSkin.y - topSkin.height;
		}
		override public function destory():void
		{
			super.destory();
			if(topSkin.parent) topSkin.parent.removeChild(topSkin);
			if(backgroudSkin.parent) backgroudSkin.parent.removeChild(backgroudSkin);
			if(exitButton.parent) exitButton.parent.removeChild(exitButton);
			if(topLabel.parent) topLabel.parent.removeChild(topLabel);
			if(container.parent) container.parent.removeChild(container);
			topSkin = null;
			backgroudSkin = null;
			exitButton = null;
			topLabel = null;
			container = null;
		}


		/**
		 * 窗口内部数据 
		 * @private
		 */
		override public function set data(value:*):void
		{
			_data = value;
			setDataHandler();
		}
		protected function setDataHandler():void
		{
			
		}
	}
}