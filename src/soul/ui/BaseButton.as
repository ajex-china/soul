package soul.ui
{
	import soul.display.BaseSprite;
	import soul.display.BaseText;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	import soul.interFace.IButton;
	import soul.ui.skin.ButtonSkin;
	
	/**
	 *按钮基类组件BaseButton:
	 * Button的基类，与Button相比少了文本功能。 
	 * @author Ajex
	 * 
	 */	
	public class BaseButton extends UIComponent implements IButton
	{
		private var _selected:Boolean = false;
		
		public var selectDownSkin:DisplayObject;
		public var selectOverSkin:DisplayObject;
		public var selectUpSkin:DisplayObject;
		public var selectDisabledSkin:DisplayObject;
		
		public var normalDownSkin:DisplayObject;
		public var normalOverSkin:DisplayObject;
		public var normalUpSkin:DisplayObject;
		public var normalDisabledSkin:DisplayObject;
		
		public var buttonSkinCon:BaseSprite;
				
		public function BaseButton(skin:Class = null)
		{
			super(skin);
		}
		override protected function constructor():void
		{
			super.constructor();
			buttonSkinCon = new BaseSprite();
			this.addChild(buttonSkinCon);
			setButtonState(normalUpSkin);
			this.mouseChildren = false;
		}
		override protected function setStyle():void
		{
			if(normalUpSkin)
			{
				setSize(normalUpSkin.width,normalUpSkin.height,false);
			}
			else
			{
				setSize(82,22,false);
			}
		}
		override public function setDefaultSkin():void
		{
			setSkin(ButtonSkin);
		}
		override protected function init():void
		{
			super.init();
			addEvent();
		}
		protected function addEvent():void
		{
			this.addEventListener(MouseEvent.ROLL_OVER,mouseOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT,mouseOutHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
			this.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			this.addEventListener(MouseEvent.CLICK,mouseClickHandler);
		}
		
		protected function mouseOverHandler(e:MouseEvent):void
		{
			setButtonState(_selected?selectOverSkin:normalOverSkin)
		}
		protected function mouseOutHandler(e:MouseEvent):void
		{
			setButtonState(_selected?selectUpSkin:normalUpSkin);
		}
		protected function mouseDownHandler(e:MouseEvent):void
		{
			setButtonState(_selected?selectDownSkin:normalDownSkin);
		}
		protected function mouseUpHandler(e:MouseEvent):void
		{
			setButtonState(_selected?selectOverSkin:normalOverSkin);
		}
		protected function mouseClickHandler(e:MouseEvent):void
		{
			
		}
		/**
		 * 设置按钮状态 
		 * @param dis 状态显示对象
		 * 
		 */		
		public function setButtonState(dis:DisplayObject):void
		{
			buttonSkinCon.removeAllChildren();
			buttonSkinCon.addChildAt(dis,0);
		}
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			if(value)
			{
				setButtonState(_selected?selectUpSkin:normalUpSkin);
				this.mouseEnabled = true;
			}
			else
			{
				setButtonState(_selected?selectDisabledSkin:normalDisabledSkin);
				this.mouseEnabled = false;
			}
		}
		public function get selected():Boolean
		{
			return _selected;
		}
		/**
		 *设置选中状态 
		 * @param value
		 * 
		 */		
		public function set selected(value:Boolean):void
		{
			if(enabled == false) return;
			_selected = value;
			setButtonState(_selected?selectUpSkin:normalUpSkin);
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		override protected function updateSize():void
		{
			if(normalOverSkin)
			{
				this.normalOverSkin.width = BaseWidth;
				this.normalOverSkin.height = BaseHeight;
			}
			
			
			if(normalDownSkin)
			{
				this.normalDownSkin.width = BaseWidth;
				this.normalDownSkin.height = BaseHeight;
			}
			
			
			if(normalUpSkin)
			{
				this.normalUpSkin.width = BaseWidth;
				this.normalUpSkin.height = BaseHeight;
			}
			
			
			if(normalDisabledSkin)
			{
				this.normalDisabledSkin.width = BaseWidth;
				this.normalDisabledSkin.height = BaseHeight;
			}
			
			
			if(selectOverSkin)
			{
				this.selectOverSkin.width = BaseWidth;
				this.selectOverSkin.height = BaseHeight;
			}
			
			
			if(selectDownSkin)
			{
				this.selectDownSkin.width = BaseWidth;
				this.selectDownSkin.height = BaseHeight;
			}
			
			
			if(selectUpSkin)
			{
				this.selectUpSkin.width = BaseWidth;
				this.selectUpSkin.height = BaseHeight;
			}
			
			
			if(selectDisabledSkin)
			{
				this.selectDisabledSkin.width = BaseWidth;
				this.selectDisabledSkin.height = BaseHeight;
			}
			
		}
		override public function destory():void
		{
			super.destory();
			selectDownSkin = null;
			selectOverSkin = null;
			selectUpSkin = null;
			selectDisabledSkin = null;
			
			normalDownSkin = null;
			normalOverSkin = null;
			normalUpSkin = null;
			normalDisabledSkin = null;
			
			buttonSkinCon.destory();
		}
	}
}