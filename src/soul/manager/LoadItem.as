package soul.manager
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import soul.FrameworkInfo;
	import soul.data.SWFClassName;
	import soul.debug.AS3Debugger;
	import soul.events.LoadingEvent;
	import soul.utils.Util;
	import soul.vo.LoadVo;
	import soul.vo.SingleLoadVo;
	
	public class LoadItem extends EventDispatcher
	{
		
		private static var _instance:LoadItem;
		private var _loadArray:Vector.<LoadVo> = new Vector.<LoadVo>();
		private var _loader:Loader;
		private var _urlLoader:URLLoader = new URLLoader();
		private var _loadLength:uint = 0;
		private var _isLoad:Boolean = false;
		public static function getInstance():LoadItem{
			if(_instance == null){
				_instance = new LoadItem;
			}
			return _instance
		}
		/**
		 * source:加载路径
		 * type：加载属性 （加载图片:type = 0,加载音乐:type = 1,加载SWF:type = 2,加载网页数据:type = 3）
		 * text：域文件
		 */
		public function load(loadvoList:Vector.<LoadVo>):void{
			if(loadvoList.length == 0) 
			{
				loadComplete();
			}
			if(_isLoad == false)
			{
				this.dispatchEvent(new LoadingEvent(LoadingEvent.LOAD_START));
			}
			for(var i:int = 0; i < loadvoList.length;i++)
			{
				_loadArray.push(loadvoList[i]);
			}
			_loadLength = _loadArray.length;
			startLoad();
		}
		public function unload(source:String):void
		{
			for(var i:int = 0; i < _loadArray.length;i++)
			{
				if(_loadArray[i].source ==  Util.sourceTransition(source))
				{
					if(_loadArray[i].loader) //去掉当前正在加载的对象继续加载（防止后面加载的资源与资源名对不上）
					{
						_loadArray[i].loader.close();
						_isLoad = false;
					}
					if(_loadArray[i].urlLoader)
					{
						_loadArray[i].urlLoader.close();
						_isLoad = false;
					}
					if(_loadArray[i].sound)
					{
						_loadArray[i].sound.close();
						_isLoad = false;
					}
					if(ResourceManager.getInstance().checkUp(source))
					{
						ResourceManager.getInstance().removeResouce(source);
					}
					_loadArray.splice(i,1);
					break;
				}
			}
		}
		private function startLoad():void{
			if(_isLoad) return;
			if(_loadArray.length == 0){
				loadComplete();
				return;
			}
			_loadArray[0].source = Util.sourceTransition(_loadArray[0].source);
			if(ResourceManager.getInstance().checkUp(_loadArray[0].source)){
				AS3Debugger.Trace(_loadArray[0].source + "资源已存在，不加载");
				nextLoadHandler();
				return;
			}
			_isLoad = true;
			var source:String = _loadArray[0].source;
			if(_loadArray[0].isV)
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
			if(_loadArray[0].type == 0 || _loadArray[0].type == 2)
			{
				_loadArray[0].loader = new Loader();
				_loader = _loadArray[0].loader;
				try
				{
					_loader.load(new URLRequest(source),_loadArray[0].context);
				}
				catch(e:Error)
				{
					AS3Debugger.Trace(e.toString());
				}
				if(!_loader.contentLoaderInfo.hasEventListener(Event.COMPLETE))
				{
					_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadAssetsComlHandler);
					_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progressHandler);
					_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
				}
			}
			else if(_loadArray[0].type == 1)
			{
				_loadArray[0].sound = new Sound();
				var sound:Sound = _loadArray[0].sound;
				sound.load(new URLRequest(source));
				if(!sound.hasEventListener(Event.COMPLETE))
				{
					sound.addEventListener(Event.COMPLETE,loadMusicComlHandler);
					sound.addEventListener(ProgressEvent.PROGRESS,progressHandler);
					sound.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
				}
			}
			else if(_loadArray[0].type == 3)
			{
				_loadArray[0].urlLoader = new URLLoader();
				_urlLoader = _loadArray[0].urlLoader;
				_urlLoader.load(new URLRequest(source))
				if(!_urlLoader.hasEventListener(Event.COMPLETE))
				{
					_urlLoader.addEventListener(Event.COMPLETE,loadDataComlHandler);
					_urlLoader.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
				}
			}
			else
			{
				AS3Debugger.Trace("加载类型错误")
			}
			
		}
		private function loadAssetsComlHandler(e:Event):void{
			if(_loadArray[0].type == 0)
			{
				var bitmap:Bitmap = e.target.content;
				//bitmap.smoothing = true;
				ResourceManager.getInstance().setResouce(_loadArray[0].source,bitmap);
			}
			else if(_loadArray[0].type == 2)
			{
				var mc:DisplayObject = (e.target as LoaderInfo).loader.content as DisplayObject;
				ResourceManager.getInstance().setResouce(_loadArray[0].source,mc);
				var classList:Array = SWFClassName.getClassName((e.target as LoaderInfo).bytes);
				for(var i:int=0;i<classList.length;i++)
				{
					ResourceManager.getInstance().setResouce(classList[i],(e.target as LoaderInfo).applicationDomain.getDefinition(classList[i]));
				}
			}
			nextLoadHandler();
		}
		private function loadMusicComlHandler(e:Event):void
		{
			ResourceManager.getInstance().setResouce(_loadArray[0].source,e.target);
			nextLoadHandler();
		}
		private function loadDataComlHandler(e:Event):void
		{
			var progress:int = (_loadLength - _loadArray.length + 1)/_loadLength*100;
			this.dispatchEvent(new LoadingEvent(LoadingEvent.LOAD_PROGRESS,progress));//补充网页数据加载时漏下的进度
			ResourceManager.getInstance().setResouce(_loadArray[0].source,e.currentTarget.data);
			nextLoadHandler();
		}
		private function nextLoadHandler():void
		{
			//			this.dispatchEvent(new LoadingEvent(LoadingEvent.LOAD_OVER,_loadArray[0].source));
			_loadArray.shift();
			_isLoad = false;
			loadOver();
			startLoad();
		}
		private function errorHandler(e:IOErrorEvent):void{
			AS3Debugger.Trace(_loadArray[0].source + "该资源不存在");
			nextLoadHandler();
		}
		private function loadComplete():void{
			this.dispatchEvent(new LoadingEvent(LoadingEvent.LOAD_ALL_COMPLETE));
		}
		private function loadOver():void
		{
			this.dispatchEvent(new LoadingEvent(LoadingEvent.LOAD_COMPLETE));
		}
		private function progressHandler(e:ProgressEvent):void
		{
			var progress:int = ((_loadLength - _loadArray.length)/_loadLength + e.bytesLoaded/e.bytesTotal/_loadLength)*100;
			this.dispatchEvent(new LoadingEvent(LoadingEvent.LOAD_PROGRESS,progress));
		}
		public function clear():void{
			
		} 
	}
}