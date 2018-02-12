package soul.manager
{
	import soul.debug.AS3Debugger;
	import soul.events.LoadingEvent;
	import soul.vo.LoadVo;
	import soul.vo.MutipleLoadVo;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	/**
	 * 多资源加载器(也可以加载单个不重复的资源)
	 * 主要用于可能发生的多个类分别同时需要加载多个资源
	 */
	public class MultipleLoadMananger extends EventDispatcher
	{
		private var _mutipleLoadVoList:Vector.<MutipleLoadVo> = new Vector.<MutipleLoadVo>();
		private var _isLoad:Boolean = false;
		private var _loadLength:int = 0;
		private var _loadItem:LoadItem = LoadItem.getInstance();
		private static var _instance:MultipleLoadMananger;
		public static function getInstance():MultipleLoadMananger{
			if(_instance == null){
				_instance = new MultipleLoadMananger;
			}
			return _instance
		}
		public function loadMultpleAssets(eventDisObject:EventDispatcher,loadVoList:Vector.<LoadVo>):void
		{
			if(_isLoad == false)
			{
				this.dispatchEvent(new LoadingEvent(LoadingEvent.MULTIPLE_START));
			}
			var mutipleLoadVo:MutipleLoadVo = new MutipleLoadVo();
			mutipleLoadVo.eventDisObject = eventDisObject;
			mutipleLoadVo.loadVoList = loadVoList;
			_mutipleLoadVoList.push(mutipleLoadVo);
			_loadLength = _mutipleLoadVoList.length;
			startLoad();
		}
		private function startLoad():void
		{
			if(_isLoad) return;
			if(_mutipleLoadVoList.length == 0){
				loadAllComplete();
				return;
			}
			_isLoad = true;
			var i:int = 0;
			if(!_loadItem.hasEventListener(LoadingEvent.LOAD_ALL_COMPLETE))
			{
				_loadItem.addEventListener(LoadingEvent.LOAD_ALL_COMPLETE,loadManagerComplete);
				_loadItem.addEventListener(LoadingEvent.LOAD_PROGRESS,loadManagerProgress);
				_loadItem.addEventListener(LoadingEvent.LOAD_START,loadManagerStart);
				
			}
			_loadItem.load(_mutipleLoadVoList[0].loadVoList);
		}
		private function loadManagerStart(e:LoadingEvent):void
		{
			_mutipleLoadVoList[0].eventDisObject.dispatchEvent(new LoadingEvent(LoadingEvent.MULTIPLE_LOAD_START));
		}
		private function loadManagerComplete(e:LoadingEvent):void
		{
			_mutipleLoadVoList[0].eventDisObject.dispatchEvent(new LoadingEvent(LoadingEvent.MULTIPLE_LOAD_COMPLETE));
			this.dispatchEvent(new LoadingEvent(LoadingEvent.MULTIPLE_LOAD_COMPLETE));
			nextLoadHandler();
		}
		private function loadManagerProgress(e:LoadingEvent):void
		{
			AS3Debugger.Trace(e.data);
			_mutipleLoadVoList[0].eventDisObject.dispatchEvent(new LoadingEvent(LoadingEvent.MULTIPLE_LOAD_PROGRESS,e.data));
			this.dispatchEvent(new LoadingEvent(LoadingEvent.MULTIPLE_LOAD_PROGRESS,e.data));
		}
		private function nextLoadHandler():void
		{
			_isLoad = false;
			_mutipleLoadVoList.shift();
			startLoad();
		}
		private function loadAllComplete():void
		{
			AS3Debugger.Trace("资源全部加载完成");
			AS3Debugger.Trace("MultipleLoadMananger工作完毕");
			this.dispatchEvent(new LoadingEvent(LoadingEvent.MULTIPLE_LOAD_ALL_COMPLETE));
		}
	}
}