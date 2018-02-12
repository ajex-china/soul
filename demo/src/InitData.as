package
{
	import com.event.ProgramEvent;
	import com.info.AssetsInfo;
	import com.model.Model;
	
	import flash.events.EventDispatcher;
	
	import soul.events.LoadingEvent;
	import soul.manager.SingleLoadManager;
	import soul.utils.Util;
	
	public class InitData extends EventDispatcher
	{
		public function InitData()
		{
			
			
			SingleLoadManager.getInstance().load(this,AssetsInfo.ASSETS,2,Util.getDomain(0));
			
			SingleLoadManager.getInstance().addEventListener(LoadingEvent.SINGLE_LOAD_ALL_COMPLETE,loadCompleteHandler);
			
		}
		private function loadCompleteHandler(e:LoadingEvent):void
		{
			SingleLoadManager.getInstance().removeEventListener(LoadingEvent.SINGLE_LOAD_ALL_COMPLETE,loadCompleteHandler);
			Model.getInstance().dispatchEvent(new ProgramEvent(ProgramEvent.INIT_COMPLETE));
		}
	}
}