package soul.utils
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	/**
	 *时间工具类 
	 * @author Administrator
	 * 
	 */	
	public class TimerUtil extends Shape 
	{
		public static var timerDictionary:Dictionary = new Dictionary();
		protected var _delay:Number;
		protected var _delayFunction:Function;
		protected var _delayCompleteParams:Array
		protected var _delayCount:int=0;
		protected var _delayIndex:int=0;
		protected var _isAutoDestory:Boolean;
		private var _currentTime:Number=0;
		private var _baseTime:Number = 0;
		private var _remain:Number = 0;//停止后多余的毫秒数 会在下次start时计算上去 防止每次停止后重新计算
		public function TimerUtil(delayFunctionValue:Function,delayCompleteParams:Array=null,delay:Number = 500,delayCount:int = 0,isAutoDestory:Boolean = true)
		{
			_delay = delay;
			_delayCount = delayCount;
			_delayFunction = delayFunctionValue;
			_delayCompleteParams = delayCompleteParams;
			_isAutoDestory = isAutoDestory;
			timerDictionary[_delayFunction] = this;
			start();
		}
		private function frameHandler(e:Event=null):void
		{
			_currentTime = getTimer() - _baseTime;
			if(_currentTime>(_delayIndex+1)*_delay)
			{
				_delayIndex++;
				if(_delayFunction!=null)
				{
					_delayFunction.apply(this,_delayCompleteParams);
				}
			}
			if(_delayCount>0&&_delayIndex==_delayCount)
			{
				if(_isAutoDestory)
				{
					destory();
				}
				else
				{
					stop();
				}
			}
		}
		public function start():void
		{
			if(isRun()) return
			if(!this.hasEventListener(Event.ENTER_FRAME))
			{
				this.addEventListener(Event.ENTER_FRAME,frameHandler);
			}
			_baseTime = getTimer() - _remain;
		}
		public function reset():void
		{
			this.removeEventListener(Event.ENTER_FRAME,frameHandler);
			_delayCount=0;
			_delayIndex=0;
			_currentTime=0;
			_baseTime = 0;
		}
		public function stop():void
		{
			_remain = _currentTime;
			this.removeEventListener(Event.ENTER_FRAME,frameHandler);
		}
		public function isRun():Boolean
		{
			if(this.hasEventListener(Event.ENTER_FRAME))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		/**
		 * 销毁方法
		 * 
		 */
		public function destory():void
		{
			reset();
			timerDictionary[_delayFunction] = null;
			_delayFunction = null;
			_delayCompleteParams = null;
			this.removeEventListener(Event.ENTER_FRAME,frameHandler);
		}
		/**
		 * 创建时间类
		 * @param delayFunctionValue 触发方法
		 * @param delayCompleteParams 触发方法参数
		 * @param delay 延时时间数
		 * @param delayCount 延时触发次数 小于等于0时为无限触发
		 * @param isAutoDestory 结束后是否自动销毁 
		 * @return 时间类引用
		 * 
		 */		
		public static function run(delayFunctionValue:Function,delayCompleteParams:Array=null,delay:Number = 500,delayCount:int = 0,isAutoDestory:Boolean = true):TimerUtil
		{
			if(timerDictionary[delayFunctionValue])
			{
				//(timerDictionary[delayFunctionValue] as TimerUtil).start();
				return timerDictionary[delayFunctionValue];
			}
			else
			{
				return new TimerUtil(delayFunctionValue,delayCompleteParams,delay,delayCount);
			}
			
		}
		
		public static function isRun(delayFunctionValue:Function):Boolean
		{
			if(!timerDictionary[delayFunctionValue]) return false;
			return (timerDictionary[delayFunctionValue] as TimerUtil).isRun()
		}
		
		public static function start(delayFunctionValue:Function):void
		{
			if(!timerDictionary[delayFunctionValue]) return;
			if(!isRun(delayFunctionValue))
			{
				(timerDictionary[delayFunctionValue] as TimerUtil).start();
			}
		}
		
		public static function reset(delayFunctionValue:Function):void
		{
			if(!timerDictionary[delayFunctionValue]) return;
			(timerDictionary[delayFunctionValue] as TimerUtil).reset();
		}
		
		public static function stop(delayFunctionValue:Function):void
		{
			if(!timerDictionary[delayFunctionValue]) return;
			(timerDictionary[delayFunctionValue] as TimerUtil).stop();
		}
		
		public static function destoryRun(delayFunctionValue:Function):void
		{
			if(!timerDictionary[delayFunctionValue]) return;
			(timerDictionary[delayFunctionValue] as TimerUtil).destory();
		}
		public static function getTimerObject(delayFunctionValue:Function):TimerUtil
		{
			return timerDictionary[delayFunctionValue];
		}
		public function get delayIndex():int
		{
			return _delayIndex;
		}
		
		public function get delayCount():int
		{
			return _delayCount;
		}
		
		public function set delayCount(value:int):void
		{
			_delayCount = value;
		}
		
		public function get delayFunction():Function
		{
			return _delayFunction;
		}
		
		public function set delayFunction(value:Function):void
		{
			_delayFunction = value;
		}
		
		public function get delayCompleteParams():Array
		{
			return _delayCompleteParams;
		}
		
		public function set delayCompleteParams(value:Array):void
		{
			_delayCompleteParams = value;
		}
		
		public function get delay():Number
		{
			return _delay;
		}
		
		public function set delay(value:Number):void
		{
			_delay = value;
		}
		
		
	}
}