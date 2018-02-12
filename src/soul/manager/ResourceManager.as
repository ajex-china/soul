package soul.manager
{
	import soul.debug.AS3Debugger;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import soul.utils.Util;
	import soul.data.SWFClassName;
	
	public class ResourceManager
	{
		private static var _instance:ResourceManager;
		private var _resouce:Dictionary = new Dictionary();
		public static function getInstance():ResourceManager{
			if(_instance == null){
				_instance = new ResourceManager();
			}
			return _instance;
		}
		public function setResouce(key:String,value:*):void{
			_resouce[key] = value;
		}
		public function checkUp(key:String):Boolean{
			if(!key) return false;
			key = Util.sourceTransition(key);
			if(_resouce[key] != null){
				return true;
			}
			return false;
		}
		public function getResouce(key:String):*{
			key = Util.sourceTransition(key);
			if(_resouce[key] == null)
			{
				AS3Debugger.Trace(key + "该资源不存在");
				return null;
			}
			return _resouce[key];
		}
		public function getClassObject(name:String):*
		{
			var cls:Class = _resouce[name] as Class;
			//var cls:Class = getClass(name);
			//trace(cls,name)
			var o:* = new cls();
			if(o is BitmapData) return new Bitmap(o);
			return o;
		}
		public function getClass(name:String):Class
		{
			//return ApplicationDomain.currentDomain.getDefinition(name) as Class;
			return  _resouce[name] as Class;
		}
		public function removeResouce(key:String):void
		{
			key = Util.sourceTransition(key);
			if(_resouce[key] is MovieClip)
			{
				var mc:MovieClip = _resouce[key] as MovieClip;
				var classList:Array = SWFClassName.getClassName((_resouce[key] as MovieClip).loaderInfo.bytes);
				for(var i:int=0;i<classList.length;i++)
				{
					_resouce[classList[i]] = null;
				}
				//(_resouce[key] as MovieClip).loaderInfo.loader.unloadAndStop();
			}
			_resouce[key] = null;
			delete _resouce[key];
		}
	}
}