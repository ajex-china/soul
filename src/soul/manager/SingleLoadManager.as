package soul.manager
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import soul.FrameworkInfo;
	import soul.data.SWFClassName;
	import soul.debug.AS3Debugger;
	import soul.events.LoadingEvent;
	import soul.tween.TweenLite;
	import soul.utils.Util;
	import soul.vo.SingleLoadVo;
	
	/**
	 * 单资源加载器，虽然是单资源加载器，但是短时间内同时加载，也会排队一起加载，但是有可能提前发出结束事件
	 * (与一般的加载器不同，该加载器需要用户添加事件接收者，资源加载结束后事件接收者自己就可以知道，并且如果重复加载同一资源，会自动合并，很适合制作二次加载，比如页游的角色形象)
	 * (加载多个资源支持排队 但如果加载已加载的资源 可能会造成提前发出全部结束事件 所以多资源加载应采用多资源加载器)
	 */
	public class SingleLoadManager extends EventDispatcher
	{
		private static var _instance:SingleLoadManager;
		
		private var _urlLoader:URLLoader;
		private var _loader:Loader;
		private var _currentLoaderObject:Object = new Object();
		private var _loadLength:uint = 0;
		private var _isLoad:Boolean = false;
		private var _singleLoadArray:Vector.<SingleLoadVo> = new Vector.<SingleLoadVo>();
		public static function getInstance():SingleLoadManager{
			if(_instance == null){
				_instance = new SingleLoadManager;
			}
			return _instance
		}
		/**
		 * loadDispatcher:事件接收者，用来接收加载数据
		 * source:加载路径
		 * type：加载属性 （加载图片:type = 0,加载音乐:type = 1,加载SWF:type = 2,加载网页数据:type = 3）
		 * text：域文件
		 * isV:是否自动加版本号
		 * 务必先侦听后加载
		 */
		public function load(loadDispatcher:EventDispatcher,source:String,type:int = 0,text:LoaderContext = null,isV:Boolean = true):void
		{
			if(_isLoad == false)
			{
				this.dispatchEvent(new LoadingEvent(LoadingEvent.SINGLE_START));
			}
			if(ResourceManager.getInstance().checkUp(source))
			{
				AS3Debugger.Trace(Util.sourceTransition(source) + "资源已存在，不加载");
				TweenLite.killDelayedCallsTo(disSingleLoadComplete);//采用延迟发送 资源已存在加载完成时间 防止 过快发出加载完毕时间 导致后面素材无法加载
				TweenLite.delayedCall(0.5,disSingleLoadComplete,[loadDispatcher,source]);
				TweenLite.killDelayedCallsTo(checkLoadAllComplete);
				return;
			}
			var singleLoadVo:SingleLoadVo = new SingleLoadVo();
			singleLoadVo.eventDisObject = loadDispatcher;
			singleLoadVo.source = Util.sourceTransition(source);
			singleLoadVo.type = type;
			singleLoadVo.context = text;
			singleLoadVo.isV = isV;
			_singleLoadArray.push(singleLoadVo);
			_loadLength = _singleLoadArray.length;
			startLoad();
		}
		protected function checkLoadAllComplete():void
		{
			if(_singleLoadArray.length == 0){//change2 from1.2.4
				loadComplete();
			}
			return;
		}
		public function unload(source:String):void
		{
			for(var i:int = 0; i < _singleLoadArray.length;i++)
			{
				if(_singleLoadArray[i].source ==  Util.sourceTransition(source))
				{
					if(_singleLoadArray[i].loader) //去掉当前正在加载的对象继续加载（防止后面加载的资源与资源名对不上）
					{
						_singleLoadArray[i].loader.close();
						_isLoad = false;
					}
					if(_singleLoadArray[i].urlLoader)
					{
						_singleLoadArray[i].urlLoader.close();
						_isLoad = false;
					}
					if(_singleLoadArray[i].sound)
					{
						_singleLoadArray[i].sound.close();
						_isLoad = false;
					}
					if(ResourceManager.getInstance().checkUp(source))
					{
						ResourceManager.getInstance().removeResouce(source);
					}
					_singleLoadArray.splice(i,1);
					break;
				}
			}
		}
		private function disSingleLoadComplete(loadDispatcher:EventDispatcher,source:String):void
		{
			loadDispatcher.dispatchEvent(new LoadingEvent(LoadingEvent.SINGLE_LOAD_COMPLETE,source));
		}
		private function startLoad():void{
			if(_isLoad) return;
			if(_singleLoadArray.length == 0){
				loadComplete();
				return;
			}
			//			if(ResourceManager.getInstance().checkUp(_singleLoadArray[0].source)){
			//				AS3Debugger.Trace(_singleLoadArray[0].source + "资源已存在，不加载");
			//				nextLoadHandler();
			//				return;
			//			}
			_isLoad = true;
			var source:String = _singleLoadArray[0].source;
			if(_singleLoadArray[0].isV)
			{
				if(FrameworkInfo.catalogue.indexOf("file") == -1)
				{
					if(source.indexOf("?") == -1)
					{
						source = source + "?v=" + FrameworkInfo.v;
					}
					else
					{
						source = source + "&v=" + FrameworkInfo.v;
					}
				}
				
			}
			if(_singleLoadArray[0].type == 0 || _singleLoadArray[0].type == 2)
			{
//				_loader = new Loader();
				_singleLoadArray[0].loader = new Loader();
				_loader = _singleLoadArray[0].loader;
				_loader.load(new URLRequest(source),_singleLoadArray[0].context);
				if(!_loader.contentLoaderInfo.hasEventListener(Event.COMPLETE))
				{
					_loader.contentLoaderInfo.addEventListener(Event.OPEN,loadStartHandler);
					_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadAssetsComlHandler);
					_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressHandler);
					_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
				}
			}
			else if(_singleLoadArray[0].type == 1)
			{
				_singleLoadArray[0].sound = new Sound();
				var sound:Sound = _singleLoadArray[0].sound;
				sound.load(new URLRequest(source));
				if(!sound.hasEventListener(Event.COMPLETE))
				{
					sound.addEventListener(Event.OPEN,loadMusicStartHandler);
					sound.addEventListener(Event.COMPLETE,loadMusicComlHandler);
					sound.addEventListener(ProgressEvent.PROGRESS,progressHandler);
					sound.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
				}
			}
			else if(_singleLoadArray[0].type == 3)
			{
				_singleLoadArray[0].urlLoader = new URLLoader();
				_urlLoader = _singleLoadArray[0].urlLoader;
				_urlLoader.load(new URLRequest(source))
				if(!_urlLoader.hasEventListener(Event.COMPLETE))
				{
					_urlLoader.addEventListener(Event.OPEN,loadStartHandler);
					_urlLoader.addEventListener(Event.COMPLETE,loadDataComlHandler);
					_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
					_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
				}
			}
			else
			{
				AS3Debugger.Trace("加载类型错误")
			}
			
		}
		private function loadMusicStartHandler(e:Event):void
		{
			ResourceManager.getInstance().setResouce(_singleLoadArray[0].source,e.target);
			startReturn(_singleLoadArray[0].source);
		}
		private function loadStartHandler(e:Event):void
		{
			startReturn(_singleLoadArray[0].source);
		}
		private function loadAssetsComlHandler(e:Event):void{
			try
			{
				if(_singleLoadArray[0].type == 0)
				{
					var bitmap:Bitmap = e.target.content;
					//bitmap.smoothing = true;
					ResourceManager.getInstance().setResouce(_singleLoadArray[0].source,bitmap);
				}
				else if(_singleLoadArray[0].type == 2)
				{
					var dis:DisplayObject = e.target.content;
					ResourceManager.getInstance().setResouce(_singleLoadArray[0].source,dis);
					var classList:Array = SWFClassName.getClassName((e.target as LoaderInfo).bytes);
					for(var i:int=0;i<classList.length;i++)
					{
						ResourceManager.getInstance().setResouce(classList[i],(e.target as LoaderInfo).applicationDomain.getDefinition(classList[i]));
					}
					//用于非同域取类
				}
			} 
			catch(error:Error) 
			{
				AS3Debugger.Trace(error.toString());
			}
			nextLoadHandler();
		}
		private function loadMusicComlHandler(e:Event):void
		{
			nextLoadHandler();
		}
		private function loadDataComlHandler(e:Event):void
		{
			ResourceManager.getInstance().setResouce(_singleLoadArray[0].source,e.currentTarget.data);
			nextLoadHandler();
		}
		private function nextLoadHandler():void
		{
			completeReturn(_singleLoadArray[0].source);
			_isLoad = false;
			loadOver();
			startLoad();
		}
		private function errorHandler(e:IOErrorEvent):void{
			AS3Debugger.Trace(e);
			AS3Debugger.Trace(_singleLoadArray[0].source + "该资源不存在");
			nextLoadHandler();
		}
		private function securityErrorHandler(e:SecurityErrorEvent):void
		{
			AS3Debugger.Trace(e.text);
			nextLoadHandler();
		}
		private function loadComplete():void{
			AS3Debugger.Trace("SingleLoadManager工作完毕");
			this.dispatchEvent(new LoadingEvent(LoadingEvent.SINGLE_LOAD_ALL_PROGRESS,100))
			this.dispatchEvent(new LoadingEvent(LoadingEvent.SINGLE_LOAD_ALL_COMPLETE));
		}
		private function loadOver():void
		{
		}
		private function progressHandler(e:ProgressEvent):void
		{
			var progress:int = e.bytesLoaded/e.bytesTotal*100;
			var allProgress:int = ((_loadLength - _singleLoadArray.length)/_loadLength + e.bytesLoaded/e.bytesTotal/_loadLength)*100;
			//			AS3Debugger.Trace(progress);
			progressReturn(_singleLoadArray[0].source,progress);
			this.dispatchEvent(new LoadingEvent(LoadingEvent.SINGLE_LOAD_ALL_PROGRESS,allProgress))
		}
		private function startReturn(source:String):void
		{
			var i:int = 0
			while(i < _singleLoadArray.length)
			{
				if(_singleLoadArray[i].source == source)
				{
					_singleLoadArray[i].eventDisObject.dispatchEvent(new LoadingEvent(LoadingEvent.SINGLE_LOAD_START,_singleLoadArray[i].source));
				}
				i++;
			}
		}
		private function progressReturn(source:String,progress:Number):void
		{
			var i:int = 0
			while(i < _singleLoadArray.length)
			{
				if(_singleLoadArray[i].source == source)
				{
					_singleLoadArray[i].eventDisObject.dispatchEvent(new LoadingEvent(LoadingEvent.SINGLE_LOAD_PROGRESS,progress));
				}
				i++;
			}
		}
		private function completeReturn(source:String):void
		{
			var i:int = 0
			while(i < _singleLoadArray.length)
			{
				if(_singleLoadArray[i].source == source)
				{
					_singleLoadArray[i].eventDisObject.dispatchEvent(new LoadingEvent(LoadingEvent.SINGLE_LOAD_COMPLETE,_singleLoadArray[i].source));
					_singleLoadArray.splice(i,1);
				}
				else
				{
					i++;
				}
			}
			//_loadLength = _singleLoadArray.length;
		}
		public function get isLoad():Boolean
		{
			return _isLoad;
		}
	}
}