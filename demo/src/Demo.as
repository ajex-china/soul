package
{
	import com.info.AssetsInfo;
	import com.view.MainView;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import soul.FrameworkInfo;
	import soul.InitFramework;
	import soul.js.PopupWin;
	import soul.other.RightItem;
	
	
	public class Demo extends Sprite
	{
		private var _mainView:MainView;
		private var _rightItem:RightItem;
		private var _initFrameWork:InitFramework;
		public function Demo()
		{
			
			this.addEventListener(Event.ADDED_TO_STAGE,addStage);
		}
		private function addStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,addStage);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			new InitFramework(stage,AssetsInfo.UISKIN,init);
		}
		private function init():void
		{
			_rightItem = new RightItem(this);
			_rightItem.addItem("电魂梦平台",false,true,true,connect);
			_rightItem.addItem("版本：" + FrameworkInfo.v);
			new InitData();
			_mainView = new MainView();
			this.addChild(_mainView);
		}
		private function connect():void
		{
			PopupWin.openWindow("http://www.17m3.com/");
		}
	}
}