package soul.ui
{
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.setTimeout;
	
	import soul.debug.AS3Debugger;
	import soul.display.BaseSprite;
	import soul.utils.TimerUtil;
	import soul.utils.Util;
	
	[Event(name="progress",type="flash.events.ProgressEvent")]
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="netStatus", type="flash.events.NetStatusEvent")]
	[Event(name="security_error", type="flash.events.SecurityErrorEvent")]
	/**
	 *视频组件 
	 * @author Ajex
	 * 
	 */	
	public class VideoItem extends BaseSprite
	{
		private var _connection:NetConnection;
		private var _soundTrans:SoundTransform;
		private var _stream:NetStream;
		private var _video:Video;
		private var _client:Object;
		private var _volume:Number = 0;
		private var _duration:Number = 0.0;
		private var _url:String;
		/**
		 *normal repeat; 
		 */		
		public var playType:String="normal";
		public var seekType:String="immediately";//immediately  delay loading  seek时操作的属性
		public var delaySeekTime:Number;
		private var _timerUtil:TimerUtil;
		public static const VIDEO_INIT_COMPLETE:String="video_init_complete";
		private var _width:Number;
		private var _height:Number;
		public var videoStatus:String="stop";
		public var details:Number;
		public var videoData:Object;
		public function VideoItem()
		{
			super();
			_connection = new NetConnection();
			_connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
			_connection.connect(null);
			
			_soundTrans = new SoundTransform();
			volume = 0.7;
			
		}
		private function netStatusHandler(e:NetStatusEvent):void
		{
			AS3Debugger.Trace(JSON.stringify(e.info));
			switch (e.info.code) 
			{
				case "NetConnection.Connect.Success":
					connectStream();
					break;
				case "NetStream.Buffer.Full": 
					trace("影片缓冲结束"); 
					break; 
				case "NetStream.Play.Start":
					if(_isPause)
					{
						pause();
						this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS,false,false,{code:"NetStream.Play.ready"}));
						return;
					}
					break;
				case "NetStream.Unpause.Notify":
					if(_isPause)
					{
						_isPause = false;
						this.dispatchEvent(new NetStatusEvent(NetStatusEvent.NET_STATUS,false,false,{code:"NetStream.Play.Start"}));
						return;
					}
					trace("已恢复");
					break;
				
				case "NetStream.Pause.Notify":
					trace("已暂停");
					break;
				case "NetStream.SeekStart.Notify":
					_isPause = false;

					break;
//				case "NetStream.Seek.Notify":
//					if(playType == "repeat")
//					{
//						this.addEventListener(Event.ENTER_FRAME,checkStopHandler);
//					}
//					break;
				case "NetStream.Seek.InvalidTime":
					details = e.info.details;
					if(seekType == "immediately")
					{
						trace("details: " + e.info.details);
						_stream.seek(e.info.details);
					}
					break;
				case "NetStream.Play.Stop":
					if(totalTime - currentTime > 1)
					{
						AS3Debugger.Trace("末尾bug,跳转"  + currentTime + " 缺少" + (totalTime - currentTime).toString());
						_stream.seek(currentTime - 1);
					}
					else
					{
						if(playType == "repeat")
						{
//							play(_url);
//							_stream.seek(0)
							setTimeout(function ():void{
								seek(0)
							},0)
						}
						else
						{
							stop();
						}
						break;
					}
					
			}
			this.dispatchEvent(e);
		}
		private function securityErrorHandler(e:SecurityErrorEvent):void
		{
			trace("未知错误！");
		}
		private function connectStream():void 
		{
			_stream= new NetStream(_connection);
			_stream.bufferTime = 1;
			_stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
			_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
			_client = new Object();
			_client.onMetaData = MetaDataHandler;
			_stream.client = _client;
			_video = new Video();
			_video.attachNetStream(_stream);
			//_video.smoothing = true;
			this.addChild(_video);
		}
		private function progressHandler():void
		{
			if(!_stream) return;
			if( _stream.bytesTotal == 0) return;
			//AS3Debugger.Trace(_stream.bytesLoaded + "/" + _stream.bytesTotal);
			var event:ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
			event.bytesLoaded = _stream.bytesLoaded;
			event.bytesTotal = _stream.bytesTotal;
			//AS3Debugger.Trace("bufferLength:" + _stream.bufferLength+"  bufferTime:" + _stream.bufferTime+"  bufferTimeMax:"+_stream.bufferTimeMax);
			this.dispatchEvent(event);
			if(seekType == "loading")
			{
				var bytes:Number;
				var length:int = videoData.keyframes.times.length;
				var bi:Number = _stream.bytesTotal/videoData.keyframes.filepositions[length-1];
				for(var i:int = 0;i < length;i++)
				{
					if(delaySeekTime<videoData.keyframes.times[i])
					{
//						var a:int = (i==0?0:i - 1);
						bytes = videoData.keyframes.filepositions[i];
						break;
					}
				}
				if(delaySeekTime > videoData.keyframes.times[length-1])
				{
					if(_stream.bytesLoaded == _stream.bytesTotal)
					{
						_stream.seek(delaySeekTime);
						seekType = "delay";
					}
				}
				else if(_stream.bytesLoaded > bytes*bi)
				{
					_stream.seek(delaySeekTime);
					seekType = "delay";
				}
			}
			if(_stream.bytesLoaded == _stream.bytesTotal)
			{
				this.dispatchEvent(new Event(Event.COMPLETE));
				_timerUtil.destory();
			}
		}
		private function MetaDataHandler(data:Object):void
		{ 
			videoData = data;
			_duration = data.duration;
			if(isNaN(_width))
			{
				_video.width = data.width;
			}
			else
			{
				_video.width = _width;
			}
			if(isNaN(_height))
			{
				_video.height = data.height;
			}
			else
			{
				_video.height = _height;
			}
			
			this.dispatchEvent(new Event(VIDEO_INIT_COMPLETE));
		}
		private function asyncErrorHandler(e:AsyncErrorEvent):void
		{
			trace("未知错误！");	
			this.dispatchEvent(e);
		}
		public function get volume():Number
		{
			return _volume;
		}
		/**
		 * 音量 
		 * @param value
		 * 
		 */		
		public function set volume(value:Number):void
		{
			_volume = value;
			_soundTrans.volume = value;
			_stream.soundTransform = _soundTrans;
		}
		/**
		 * 跳转时间轴 
		 * @param offset
		 * 
		 */		
		public function seek(offset:Number):void
		{
			if(offset > totalTime) offset = totalTime;
			_stream.seek(offset);
			if(seekType == "delay")
			{
				delaySeekTime = offset;
				seekType = "loading";
				pause();
			}
		}
		private var _isPause:Boolean = false;
		/**
		 *播放 
		 * @param url
		 * @param isPause 是否播放后立即暂停（播放后立即停止，用户不会敢感到这一操作，但是停止的时候会加载数据流）
		 */		
		public function play(url:String,isPause:Boolean = false):void
		{
			_url = Util.sourceTransition(url);
			_isPause = isPause;
			_stream.play(_url);
			AS3Debugger.Trace("开始播放："+_url);
			videoStatus  = "play";
			_timerUtil = TimerUtil.run(progressHandler,[],500,0);
//			if(playType == "repeat")
//			{
//				this.addEventListener(Event.ENTER_FRAME,checkStopHandler);
//			}
		}
//		protected function checkStopHandler(e:Event):void
//		{
//			if (currentTime > 0 && _duration > 0) 
//			{ 
//				
//				if (totalTime-currentTime <=0.1) 
//				{ 
//					_stream.seek(0)
//					trace("huan");
//					this.removeEventListener(Event.ENTER_FRAME,checkStopHandler);
//				}
//			}
//		}
		/**
		 *恢复 
		 * 
		 */		
		public function resume():void
		{
			_stream.resume();
			videoStatus  = "play";
		}
		/**
		 *暂停 
		 * 
		 */		
		public function pause():void
		{
			_stream.pause();
			videoStatus  = "pause";
		}
		/**
		 * 
		 * @param isClear 费否清除画面
		 * 
		 */		
		public function stop(isClear:Boolean = true):void
		{
			if(_stream) _stream.close();
			if(isClear) _video.clear();
			videoStatus  = "stop";
			if(_timerUtil) _timerUtil.destory();
//			this.removeEventListener(Event.ENTER_FRAME,checkStopHandler);
		}
		/**
		 *当前播放时间 
		 * @return 
		 * 
		 */		
		public function get currentTime():Number
		{
			return _stream.time;
		}
		/**
		 *总时间 
		 * @return 
		 * 
		 */		
		public function get totalTime():Number
		{
			return _duration;
		}
		/**
		 * 现在的字节数 
		 * @return 
		 * 
		 */		
		public function get currentBytes():Number
		{
			return _stream.bytesLoaded;
		}
		/**
		 *总共的字节数 
		 * @return 
		 * 
		 */		
		public function get totalBytes():Number
		{
			return _stream.bytesTotal;
		}
		
		override public function get height():Number
		{
//			if(!_video) return 0;
//			return _video.height;//用这句会导致用scale修改大小时获取的宽高不会变
			return super.height;
		}
		
		override public function set height(value:Number):void
		{
//			super.height = value;
			_height = value;
			if(_video) _video.height = value;
		}
		
		override public function get width():Number
		{
//			if(!_video) return 0;
//			return _video.width;//用这句会导致用scale修改大小时获取的宽高不会变
			return super.width;
		}
		
		override public function set width(value:Number):void
		{
//			super.width = value;
			_width = value;
			if(_video) _video.width = value;
		}
		public function get smoothing():Boolean
		{
			return _video.smoothing
		}
		public function set smoothing(value:Boolean):void
		{
			_video.smoothing = value;
		}
		public function get source():String
		{
			return _url;
		}
		override public function destory():void
		{
			this.stop();
			super.destory();
			_connection = null;
			_soundTrans = null;
			_stream = null;
		}
	}
}