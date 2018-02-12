package soul.utils
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Dictionary;
	
	import soul.events.LoadingEvent;
	import soul.manager.ResourceManager;
	import soul.manager.SingleLoadManager;
	
	//还需要补seek
	public class SoundUtil extends EventDispatcher
	{
		public static const PLAY_COMPLETE:String="play_complete";
		public static const LOAD_START:String="load_start";
		public static const LOAD_PROGRESS:String="load_progress";
		public static const LOAD_COMPLETE:String="load_complete";
		private static var _allVolume:Number = 1;
		public static var soundDictionary:Dictionary = new Dictionary();
		public var progress:Number = 0;
		public var dalayTime:Number = 1000;
		private var _soundChannel:SoundChannel;
		private var _sound:Sound;
		private var _source:String;
		private var _startTime:Number = 0;
		private var _pan:Number = 0;
		private var _volume:Number = 0.7;
		private var _playCurrent:String="stop";
		private var _type:int = 0;
		public function SoundUtil(source:String,pan:Number = 0,volume:Number = 0.7,type:int = 0)
		{
			_source = source;
			_pan = pan;
			_volume = volume;
			_type = type;
			soundDictionary[source]	= this;	
		}
		private function getSoundHandler():void
		{
			_sound = ResourceManager.getInstance().getResouce(_source) as Sound;
			this.dispatchEvent(new Event(LOAD_START));
			this.dispatchEvent(new Event(LOAD_PROGRESS));
			this.dispatchEvent(new Event(LOAD_COMPLETE));
			playHandler();
		}
		private function loadStartHandler(e:LoadingEvent):void
		{
			_sound = ResourceManager.getInstance().getResouce(e.data);
			playHandler();
			this.dispatchEvent(new Event(LOAD_START));
		}
		private function playHandler():void
		{
			if(_soundChannel) _soundChannel.stop();
			_startTime = 0;
			if(!_sound) return;
			_soundChannel = _sound.play();
			_soundChannel.addEventListener(Event.SOUND_COMPLETE,soundPlayCompleteHandler);
			setPan(_pan);
			setVolume(_volume);
			_playCurrent = "play";
		}
		private function soundPlayCompleteHandler(e:Event):void
		{
			_playCurrent = "stop";
			_soundChannel.removeEventListener(Event.SOUND_COMPLETE,soundPlayCompleteHandler);
			_startTime = 0;
			if(_type == 0)
			{
				this.dispatchEvent(new Event(PLAY_COMPLETE));
			}
			else
			{
				TimerUtil.run(playHandler,[],dalayTime,1);
			}
		}
		private function loadProgressHandler(e:LoadingEvent):void
		{
			progress = e.data;
			this.dispatchEvent(new Event(LOAD_PROGRESS));
		}
		private function loadCompleteHandler(e:LoadingEvent):void
		{
			progress = 100;
			this.removeEventListener(LoadingEvent.SINGLE_LOAD_START,loadStartHandler);
			this.removeEventListener(LoadingEvent.SINGLE_LOAD_PROGRESS,loadProgressHandler);
			this.removeEventListener(LoadingEvent.SINGLE_LOAD_COMPLETE,loadCompleteHandler);
			this.dispatchEvent(new Event(LOAD_COMPLETE));
		}
		private function setPan(pan:Number):void {
			_pan = pan;
			if(!_soundChannel) return;
			var transform:SoundTransform = _soundChannel.soundTransform;
			transform.pan = pan;
			_soundChannel.soundTransform = transform;
		}
		
		private function setVolume(volume:Number):void {
			_volume = volume;
			if(!_soundChannel) return;
			var transform:SoundTransform = _soundChannel.soundTransform;
			transform.volume = volume * allVolume;
			_soundChannel.soundTransform = transform;
		}
		/**
		 *重置音量 用于改变全局音量时调用 
		 * 
		 */		
		private function resetVolume():void
		{
			if(!_soundChannel) return;
			var transform:SoundTransform = _soundChannel.soundTransform;
			transform.volume = volume * allVolume;
			_soundChannel.soundTransform = transform;
		}
		public function get pan():Number
		{
			return _pan;
		}
		
		public function set pan(value:Number):void
		{
			_pan = value;
			setPan(_pan);
		
		}
		public function get volume():Number
		{
			return _volume;
		}
		
		public function set volume(value:Number):void
		{
			_volume = value;
			setVolume(_volume);
		}
		
		
		public function get source():String
		{
			return _source;
		}
		
		public function set source(value:String):void
		{
			_source = value;
		}
		public function get playCurrent():String
		{
			return _playCurrent;
		}
		
		public function set playCurrent(value:String):void
		{
			_playCurrent = value;
		}
		
		public function get type():int
		{
			return _type;
		}
		
		public function set type(value:int):void
		{
			_type = value;
		}
		public function get sound():Sound
		{
			return _sound;
		}
		public function resume():void
		{
			if(!_soundChannel) return;
			if(_playCurrent == "play") return;
			_startTime = _soundChannel.position;
			_soundChannel.stop();
			_soundChannel = _sound.play(_startTime);
			_soundChannel.addEventListener(Event.SOUND_COMPLETE,soundPlayCompleteHandler);
			setPan(_pan);
			setVolume(_volume);
			_playCurrent = "play";
		}
		public function pause():void
		{
			if(!_soundChannel) return;
			_startTime = _soundChannel.position;
			_soundChannel.stop();
			_soundChannel.removeEventListener(Event.SOUND_COMPLETE,soundPlayCompleteHandler);
			_playCurrent = "pause";
		}
		public function reset(isPlay:Boolean = true):void
		{
			if(!_soundChannel) return;
			_soundChannel.stop();
			_startTime = 0;
			if(isPlay)
			{
				_soundChannel = _sound.play(_startTime);
				_soundChannel.addEventListener(Event.SOUND_COMPLETE,soundPlayCompleteHandler);
				setPan(_pan);
				setVolume(_volume);
				_playCurrent = "play";
			}
			else
			{
				_soundChannel.removeEventListener(Event.SOUND_COMPLETE,soundPlayCompleteHandler);
				_playCurrent = "pause";
			}
		}
		//		public function togglePause():void
		//		{
		//			if(!_soundChannel) return;
		//			_startTime = _soundChannel.position;
		//			if(_playCurrent == "play")
		//			{
		//				_soundChannel.stop()
		//				_soundChannel.removeEventListener(Event.SOUND_COMPLETE,soundPlayCompleteHandler);
		//				_playCurrent = "stop";
		//			}
		//			else
		//			{
		//				_soundChannel = _sound.play(_startTime);
		//				_soundChannel.addEventListener(Event.SOUND_COMPLETE,soundPlayCompleteHandler);
		//				setPan(_pan);
		//				setVolume(_volume);
		//				_playCurrent = "play";
		//			}
		//		}
		public function play(source:String = null,pan:Number = 0,volume:Number = 0.7,type:int = 0):void
		{
			if(ResourceManager.getInstance().checkUp(source))
			{
				getSoundHandler();
				return
			}
			if(!source && _sound&&_soundChannel)//如果source不存在说明用户是重新播放该音乐，配置不变
			{
				source = _source;
				pan = _pan;
				volume = _volume;
				type = _type;
			}
			if(_sound&&_soundChannel&&_source == source)
			{
				_pan = pan;
				_volume = volume;
				_type = type;
				reset();
				return;
			}
			if(source) _source = source;
			_pan = pan;
			_volume = volume;
			_type = type;
			this.addEventListener(LoadingEvent.SINGLE_LOAD_START,loadStartHandler);
			this.addEventListener(LoadingEvent.SINGLE_LOAD_PROGRESS,loadProgressHandler);
			this.addEventListener(LoadingEvent.SINGLE_LOAD_COMPLETE,loadCompleteHandler);
			SingleLoadManager.getInstance().load(this,_source,1);
		}
		public function stop():void
		{
			if(!_soundChannel) return;
			_playCurrent = "stop";
			_soundChannel.stop();
			_soundChannel.removeEventListener(Event.SOUND_COMPLETE,soundPlayCompleteHandler);
			this.dispatchEvent(new Event(PLAY_COMPLETE));
		}
		/**
		 * 销毁方法
		 * 
		 */
		public function destory():void
		{
			stop();
			TimerUtil.destoryRun(playHandler);
			this.removeEventListener(LoadingEvent.SINGLE_LOAD_START,loadStartHandler);
			this.removeEventListener(LoadingEvent.SINGLE_LOAD_PROGRESS,loadProgressHandler);
			this.removeEventListener(LoadingEvent.SINGLE_LOAD_COMPLETE,loadCompleteHandler);
			soundDictionary[_source] = null;
			if(_sound)
			{
				try
				{
					_sound.close();
				}
				catch(error:IOError)
				{
					
				}
			}
			
			_sound = null;
			_soundChannel = null;
			
		}
		/**
		 * 只生成音樂， 如果已经 有该音乐，直接返回。
		 * @param source  播放地址
		 * @param pan 音量平衡
		 * @param volume 音量
		 * @param type 属性  0代表只播一遍 1代表循環播放 
		 * @return  返回音乐对象本身
		 * 
		 */		
		public static function soundInit(source:String,pan:Number = 0,volume:Number = 0.7,type:int = 0):SoundUtil
		{
			if(soundDictionary[source])
			{
				return soundDictionary[source];
			}
			else
			{
				return new SoundUtil(source,pan,volume,type);
			}
		}
		/**
		 * 生成并播放音乐 ，如果已经 有该音乐，直接返回。
		 * @param source  播放地址
		 * @param pan 音量平衡
		 * @param volume  音量
		 * @param type 属性  0代表只播一遍 1代表循環播放 
		 * @return 返回音乐对象本身
		 * 
		 */		
		public static function soundPlay(source:String,pan:Number = 0,volume:Number = 0.7,type:int = 0):SoundUtil
		{
			if(soundDictionary[source])
			{
				(soundDictionary[source] as SoundUtil).play(source,pan,volume,type);
				return soundDictionary[source];
			}
			else
			{
				var sound:SoundUtil = new SoundUtil(source,pan,volume,type);
				sound.play(source,pan,volume,type);
				return sound;
			}
		}
		public static function soundResume(source:String):void
		{
			if(!soundDictionary[source]) return;
			(soundDictionary[source] as SoundUtil).resume();
		}
		public static function soundPause(source:String):void
		{
			if(!soundDictionary[source]) return;
			(soundDictionary[source] as SoundUtil).pause();
		}
		public static function soundStop(source:String):void
		{
			if(!soundDictionary[source]) return;
			(soundDictionary[source] as SoundUtil).stop();
		}
		public static function soundReset(source:String):void
		{
			if(!soundDictionary[source]) return;
			(soundDictionary[source] as SoundUtil).reset();
		}
		public static function destoryRun(source:String):void
		{
			if(!soundDictionary[source]) return;
			(soundDictionary[source] as SoundUtil).destory();
			delete soundDictionary[source];
		}
		public static function getSound(source:String):Sound
		{
			if(!soundDictionary[source]) return null;
			return (soundDictionary[source] as SoundUtil).sound
		}
		public static function allResume():void
		{
			for(var key:* in soundDictionary)
			{
				if((soundDictionary[key] as SoundUtil).playCurrent=="pause")
				{
					(soundDictionary[key] as SoundUtil).resume();
				}
			}
		}
		public static function allPause():void
		{
			for(var key:* in soundDictionary)
			{
				if((soundDictionary[key] as SoundUtil).playCurrent=="play")
				{
					(soundDictionary[key] as SoundUtil).pause();
				}
			}
		}
		public static function getSoundCurrent(source:String):String
		{
			if(!soundDictionary[source]) return "";
			return (soundDictionary[source] as SoundUtil).playCurrent;
		}
		public static function get allVolume():Number
		{
			return _allVolume;
		}
		
		public static function set allVolume(value:Number):void
		{
			_allVolume = value;
			for(var key:* in soundDictionary)
			{
				(soundDictionary[key] as SoundUtil).resetVolume();
			}
		}
	}
}