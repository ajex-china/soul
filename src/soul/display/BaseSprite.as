package soul.display
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import soul.events.UIEvent;
	import soul.tween.TweenLite;
	
	public class BaseSprite extends Sprite
	{
		/**
		 * 是否初始化
		 */
		public var initialized:Boolean;
		
		/**
		 * 是否已经被销毁
		 */
		public var destoryed:Boolean = false;
		/**
		 * 是否在移出显示列表的时候删除自身
		 */		
		public var destoryWhenRemove:Boolean = false;
		
		private var _eventNameList:Array;
		private var _eventFunctionList:Array;
		
		/**
		 *缓动时间 
		 */		
		public var tweenTime:Number = 1;
		
		public static const SHOW_COMPLETE:String="showComplete";
		public static const HIDE_COMPLETE:String="hideComplete";
		protected var showCompleteFunction:Function;
		protected var hideCompleteFunction:Function;
		protected var showParameterList:Array;
		protected var hideParameterList:Array;
		public function BaseSprite()
		{
			super();
			_eventNameList = [];
			_eventFunctionList = [];
			addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
		}
		/**
		 *只生效一次 
		 * @param event
		 * 
		 */		
		protected function addedToStageHandler(event:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,addedToStageHandler)
			init();
			
			this.initialized = true;
			
			dispatchEvent(new UIEvent(UIEvent.CREATE_COMPLETE));
		}
		/**
		 *只生效一次 
		 * @param event
		 * 
		 */		
		protected function removedFromStageHandler(event:Event=null):void
		{
			if (destoryWhenRemove)
			{
				this.removeEventListener(Event.REMOVED_FROM_STAGE,removedFromStageHandler);
				
				destory();
			}
		}
		/**
		 *
		 * 初始化方法，在第一次被加入显示列表时调用 
		 * 
		 */		
		protected function init():void
		{
		}
		/**
		 * 删除全部子对象 
		 * 
		 */		
		public function removeAllChildren():void
		{
			while (this.numChildren > 0)
			{
				this.removeChildAt(0);
			}
		}
		//改写父类方法 增加管理功能 销毁时自动取消侦听
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
		{
			_eventNameList.push(type);
			_eventFunctionList.push(listener);
			super.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
		{
			for(var i:int = 0;i < _eventNameList.length;i++)
			{
				if(_eventNameList[i]==type&&_eventFunctionList[i]==listener)
				{
					_eventNameList.splice(i,1);
					_eventFunctionList.splice(i,1);
					break;
				}
			}
			super.removeEventListener(type,listener,useCapture);
		}
		/**
		 * 销毁方法
		 * 
		 */
		public function destory():void
		{
			if (destoryed)
				return;
			
			while (_eventNameList.length > 0)
			{
				this.removeEventListener(_eventNameList[0],_eventFunctionList[0]);
			}
			for(var i:int = 0;i<this.numChildren;i++)
			{
				if(this.getChildAt(i) is BaseSprite)
				{
					(this.getChildAt(i) as BaseSprite).destory();
				}
			}
			this.removeAllChildren();
			if (parent)
				parent.removeChild(this);
			
			destoryed = true;
		}
		/**
		 * 
		 * @return 全部侦听事件属性名数组 
		 * 
		 */		
		public function getEventTypeList():Array
		{
			return _eventNameList;
		}
		/**
		 * 
		 * @return 全部侦听事件方法数组
		 * 
		 */		
		public function getEventFunctionList():Array
		{
			return _eventFunctionList
		}
		
		
		public function show(completeFunction:Function = null,parameterList:Array = null):void
		{
			TweenLite.killTweensOf(this)
			if(!this.visible) 
			{
				this.visible = true;
				this.alpha = 0;
			}
			showCompleteFunction = completeFunction;
			showParameterList = parameterList;
			TweenLite.to(this,tweenTime,{alpha:1,onComplete:completeFunction,onCompleteParams:parameterList})
		}
		public function hide(completeFunction:Function = null,parameterList:Array = null):void
		{
			TweenLite.killTweensOf(this)
			hideCompleteFunction = completeFunction;
			hideParameterList = parameterList;
			var data:Object = {onComplete:completeFunction,onCompleteParams:parameterList};
			TweenLite.to(this,tweenTime,{alpha:0,onComplete:_hideComplete,onCompleteParams:[data]});
		}
		protected function _hideComplete(data:Object):void
		{
			this.visible = false;
			var fun:Function = data.onComplete;
			var param:Object = data.parameterList;
			if(fun!=null) fun.call(this,param);
		}
	}
}