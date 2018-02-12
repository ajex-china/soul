package soul
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import soul.events.LoadingEvent;
	import soul.manager.SingleLoadManager;
	import soul.utils.Util;
	/**
	 *框架初始化 
	 * @author Administrator
	 * 
	 */
	public class InitFramework extends EventDispatcher
	{
		private var _uiSource:String;
		public var completeFunction:Function;
		public var completeParams:Array;
		/**
		 *  初始化框架
		 * @param stage 舞台
		 * @param uiSource ui路径
		 * @param completeFun 结束回调函数
		 * @param completePar 回调函数参数
		 * 
		 */		
		public function InitFramework(stage:Stage,uiSource:String=null,completeFun:Function=null,completePar:Array=null)
		{
			FrameworkInfo.stage = stage;
			_uiSource = uiSource;
			completeFunction = completeFun;
			completeParams = completePar;
			FrameworkInfo.catalogue = Util.getCatalogue(stage.loaderInfo.url);
			FrameworkInfo.urlData = stage.loaderInfo.parameters;
			FrameworkInfo.v = stage.loaderInfo.parameters.v?String(stage.loaderInfo.parameters.v):FrameworkInfo.v;
			if(!uiSource)
			{
				if(completeFunction != null)
				{
					completeFunction.apply(this,completeParams);
				}
				return;
			}
			this.addEventListener(LoadingEvent.SINGLE_LOAD_COMPLETE,loadCompleteHandler);
			SingleLoadManager.getInstance().load(this,_uiSource,2,Util.getDomain(1));
		}
		private function loadCompleteHandler(e:LoadingEvent):void
		{
			this.removeEventListener(LoadingEvent.SINGLE_LOAD_COMPLETE,loadCompleteHandler);
			if(completeFunction!=null)
			{
				completeFunction.apply(this,completeParams);
			}
		}
	}
}