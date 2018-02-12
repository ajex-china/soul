package soul.ui
{
	import soul.display.BaseText;
	import soul.manager.PopManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;

	/**
	 *信息窗口 
	 * @author Ajex
	 * 
	 */	
	public class NoticePanel extends Panel
	{
		public static const VERIFY:String="verify";
		public static const CANCEL:String="cancel";
		
		public var verifyFunction:Function;
		public var verifyParams:Array;
		public var cancelFunction:Function;
		public var cancelParams:Array
		
		private var _content:String;
		private var _panelType:int;
		protected var baseText:BaseText;
		protected var verifyButton:Button;
		protected var cancelButton:Button;
		public function NoticePanel(contentText:String,type:int=0,topText:String="")
		{
			super();
			noticeText = contentText;
			panelType = type;
			topLabel.text = topText;
			
		}
		override protected function constructor():void
		{
			super.constructor();
			baseText = new BaseText();
			baseText.width = 500;
			baseText.wordWrap = true;
			baseText.size = 14;
			baseText.align = TextFormatAlign.CENTER;
			verifyButton = new Button();
			verifyButton.label = "确定";
			cancelButton = new Button();
			cancelButton.label = "取消";
			this.addItem(baseText);
			this.addItem(verifyButton);
			this.addItem(cancelButton);
		}
		override protected function setStyle():void
		{
			setSize(700,150,false);
		}
		override protected function addEvent():void
		{
			super.addEvent();
			verifyButton.addEventListener(MouseEvent.CLICK,verifyHandler);
			cancelButton.addEventListener(MouseEvent.CLICK,cancelHandler);
		}
		public function get noticeText():String
		{
			return _content;
		}
		
		public function set noticeText(value:String):void
		{
			_content = value;
			baseText.htmlText = value;
			invalidateSize();
		}

		public function get panelType():int
		{
			return _panelType;
		}

		public function set panelType(value:int):void
		{
			_panelType = value;
			invalidateSize();
		}
		override protected function updateSize():void
		{
			super.updateSize();
			baseText.x = BaseWidth/2 - baseText.width/2;
			baseText.y = 50;
			if(panelType == 0)
			{
				verifyButton.x = BaseWidth/2 - verifyButton.width/2;
				verifyButton.visible = true;
				cancelButton.visible = false;
				
			}
			else
			{
				verifyButton.x = BaseWidth/2 - 50 - verifyButton.width;
				cancelButton.x = BaseWidth/2 + 50;
				verifyButton.visible = true;
				cancelButton.visible = true;
			}
			verifyButton.y = baseText.y + baseText.height + 50;
			cancelButton.y = baseText.y + baseText.height + 50;
			
			if(verifyButton.y + verifyButton.height + 50 > backgroudSkin.height) 
			{
				this.height = verifyButton.y + verifyButton.height + 50;
				vaildSize();
			}
		}
		protected function verifyHandler(e:MouseEvent):void
		{
			if(verifyFunction!=null)
			{
				verifyFunction.apply(this,verifyParams);
			}
			this.dispatchEvent(new Event(VERIFY));
			PopManager.rePop(this,this.parent);
		}
		protected function cancelHandler(e:MouseEvent):void
		{
			if(cancelFunction!=null)
			{
				cancelFunction.apply(this,cancelParams);
			}
			this.dispatchEvent(new Event(CANCEL));
			PopManager.rePop(this,this.parent);
		}
		override public function destory():void
		{
			super.destory();
			
			if(baseText.parent) baseText.parent.removeChild(baseText);
			if(verifyButton.parent) verifyButton.parent.removeChild(verifyButton);
			if(cancelButton.parent) cancelButton.parent.removeChild(cancelButton);
			baseText = null;
			verifyButton = null;
			cancelButton = null;
		}
	}
}