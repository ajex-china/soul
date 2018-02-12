package soul.manager
{
	import soul.vo.EnterFrameVo;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class EnterFrameManager
	{
		private var _enterFrameVoList:Vector.<EnterFrameVo>;
		private var _sprite:Sprite;
		private static var _instance:EnterFrameManager;
		public function EnterFrameManager()
		{
			_enterFrameVoList = new Vector.<EnterFrameVo>
			_sprite = new Sprite();
			_sprite.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		public static function getInstance():EnterFrameManager{
			if(_instance == null){
				_instance = new EnterFrameManager;
			}
			return _instance
		}
		private function enterFrameHandler(e:Event):void
		{
			var vo:EnterFrameVo
			for(var i:int = 0;i < _enterFrameVoList.length;i++)
			{
				vo = _enterFrameVoList[i];
				vo.enterFrameFunction.apply(this,vo.valueList);
			}
		}
		public function addEventListener(fun:Function,valueList:Array = null):void
		{
			var vo:EnterFrameVo = new EnterFrameVo();
			vo.enterFrameFunction = fun;
			vo.valueList = valueList
			_enterFrameVoList.push(vo);
		}
		public function removeEventListener(fun:Function):void
		{
			for(var i:int = 0;i < _enterFrameVoList.length;i++)
			{
				if(fun == _enterFrameVoList[i].enterFrameFunction)
				{
					_enterFrameVoList.splice(i,1);
					return;
				}
			}
		}
	}
}