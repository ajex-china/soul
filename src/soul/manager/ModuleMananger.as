/**
 *模块管理器，暂未写 
 */
package soul.manager
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class ModuleMananger extends EventDispatcher
	{
		private static var _instance:ModuleMananger;
		public static function getInstance():ModuleMananger{
			if(_instance == null)
			{
				_instance = new ModuleMananger;
			}
			return _instance
		}
	}
}