package soul.ui
{
	import flash.display.Sprite;
	
	import soul.display.BaseText;
	import soul.interFace.IToolTip;
	
	/**
	 *提示框 
	 * @author Ajex
	 * 
	 */	
	public class ToolTip extends Sprite implements IToolTip
	{
		public var borderColor:uint = 0x000000;
		public var beginColor:uint = 0xffffcc;
		public var borderAlpha:Number = 1;
		public var beginAlpha:Number = 1;
		private var _textColor:uint = 0x000000;
		private var _tipText:BaseText;
		public var leftSpace:Number = 2;
		public var topSpace:Number = 2;
		private var _width:Number=0;
		private var _height:Number=0;
		public function ToolTip()
		{
			super();
			_tipText = new BaseText();
			_tipText.color = _textColor;
			_tipText.x = leftSpace;
			_tipText.y = topSpace
			this.addChild(_tipText);
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		public function label(txt:String):void
		{
			_tipText.text = txt;
			this.width = super.width;
			this.height = super.height;
		}
		override public function set width(value:Number):void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1,borderColor,borderAlpha);
			this.graphics.beginFill(beginColor,beginAlpha);
			this.graphics.drawRect(0,0,value,this.height);
			this.graphics.endFill();
		}
		override public function set height(value:Number):void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1,borderColor,borderAlpha);
			this.graphics.beginFill(beginColor,beginAlpha);
			this.graphics.drawRect(0,0,this.width + 2,value);
			this.graphics.endFill();
		}
		
		public function get textColor():uint
		{
			return _textColor;
		}
		
		public function set textColor(value:uint):void
		{
			_textColor = value;
			_tipText.color = _textColor;
		}
		
	}
}