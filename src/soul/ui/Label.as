package soul.ui
{
	import soul.display.BaseText;
	
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.StyleSheet;
	import flash.text.TextFieldAutoSize;
	
	[Event(name="change",type="flash.events.Event")]
	[Event(name="link",type="flash.events.TextEvent")]
	/**
	 *文本组件 
	 * @author Ajex
	 * 
	 */	
	public class Label extends UIComponent
	{
		protected var baseText:BaseText;
		
		private var _autoSize:String;
		private var _background:Boolean;
		private var _backgroundColor:uint;
		private var _border:Boolean;
		private var _borderColor:uint;
		private var _displayAsPassword:Boolean;
		private var _embedFonts:Boolean;
		private var _text:String;
		private var _htmlText:String;
		private var _maxChars:int;
		private var _mouseWheelEnabled:Boolean;
		private var _multiline:Boolean;
		private var _restrict:String;
		private var _scrollH:int;
		private var _scrollV:int;
		private var _selectable:Boolean;
		private var _styleSheet:StyleSheet;
		private var _wordWrap:Boolean;
		public function Label(skin:Class=null)
		{
			super(skin);
		}
		override protected function constructor():void
		{
			super.constructor();
			baseText = new BaseText();
			baseText.autoSize = TextFieldAutoSize.NONE;
			baseText.text="字符";
			this.addChild(baseText);
			baseText.addEventListener(Event.CHANGE,changeHandler);
			baseText.addEventListener(TextEvent.LINK,linkHandler);
		}
		override protected function setStyle():void
		{
			setSize(100,22,false);
		}
		protected function changeHandler(e:Event):void
		{
			this.dispatchEvent(e);
		}
		protected function linkHandler(e:TextEvent):void
		{
			this.dispatchEvent(e);
		}
		/**
		 * 得到baseText实例 
		 * @return 
		 * 
		 */		
		public function getBaseText():BaseText
		{
			return baseText;
		}
		override protected function updateSize():void
		{
			baseText.width = BaseWidth;
			baseText.height = BaseHeight;
		}
		
		override public function destory():void
		{
			baseText.removeEventListener(Event.CHANGE,changeHandler);
			baseText.removeEventListener(TextEvent.LINK,linkHandler);
			super.destory();
			baseText = null;
		}
		
		/**
		 *强制更新格式 
		 * 
		 */		
		public function CompulsorySetformat():void
		{
			baseText.CompulsorySetformat();
		}
		public function get color():Object
		{
			return baseText.color;
		}
		/**
		 *表示文本的颜色 
		 * @param value
		 * 
		 */		
		public function set color(value:Object):void
		{
			baseText.color = value;
		}
		
		public function get bold():Object
		{
			return baseText.bold;
		}
		/**
		 *指定文本是否为粗体字 
		 * @param value
		 * 
		 */		
		public function set bold(value:Object):void
		{
			baseText.bold = value;
		}
		
		public function get font():String
		{
			return baseText.font;
		}
		/**
		 *使用此文本格式的文本的字体名称，以字符串形式表示 
		 * @param value
		 * 
		 */		
		public function set font(value:String):void
		{
			baseText.font = value;
		}
		
		public function get italic():Object
		{
			return baseText.italic;
		}
		/**
		 *表示使用此文本格式的文本是否为斜体 
		 * @param value
		 * 
		 */		
		public function set italic(value:Object):void
		{
			baseText.italic = value;
		}
		
		public function get size():int
		{
			if(!baseText.size) return 12;
			return int(baseText.size);
		}
		/**
		 *用此文本格式的文本的大小（以像素为单位） 
		 * @param value
		 * 
		 */		
		public function set size(value:int):void
		{
			baseText.size = value;
		}
		public function get leading():Object
		{
			return baseText.leading;
		}
		/**
		 *一个整数，表示行与行之间的垂直间距（称为前导）量 
		 * @param value
		 * 
		 */		
		public function set leading(value:Object):void
		{
			baseText.leading = value;
		}
		
		public function get align():String
		{
			return baseText.align;
		}
		/**
		 *文本对齐方式 
		 * @param value
		 * 
		 */		
		public function set align(value:String):void
		{
			baseText.align = value;
		}
		
		public function get blockIndent():Object
		{
			return baseText.blockIndent;
		}
		/**
		 *表示块缩进，以像素为单位 
		 * @param value
		 * 
		 */		
		public function set blockIndent(value:Object):void
		{
			baseText.blockIndent = value;
		}
		
		public function get leftMargin():Object
		{
			return baseText.leftMargin;
		}
		/**
		 *段落的左边距，以像素为单位 
		 * @param value
		 * 
		 */		
		public function set leftMargin(value:Object):void
		{
			baseText.leftMargin = value;
		}
		
		public function get rightMargin():Object
		{
			return baseText.rightMargin;
		}
		/**
		 *段落的右边距，以像素为单位 
		 * @param value
		 * 
		 */		
		public function set rightMargin(value:Object):void
		{
			baseText.rightMargin = value;
		}
		
		public function get underline():Object
		{
			return baseText.underline;
		}
		/**
		 *表示使用此文本格式的文本是带下划线 (true) 还是不带下划线 (false) 
		 * @param value
		 * 
		 */		
		public function set underline(value:Object):void
		{
			baseText.underline = value;
		}
		
		public function get autoSize():String
		{
			return _autoSize;
		}
		/**
		 *控制文本字段的自动大小调整和对齐 
		 * @param value center(居中对齐文本) left(左对齐文本) none(指定不调整大小) right(右对齐文本)
		 * 
		 */		
		public function set autoSize(value:String):void
		{
			_autoSize = value;
			baseText.autoSize = value;
		}
		
		public function get background():Boolean
		{
			return _background;
		}
		/**
		 *指定文本字段是否具有背景填充 
		 * @param value
		 * 
		 */		
		public function set background(value:Boolean):void
		{
			_background = value;
			baseText.background = value;
		}
		
		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}
		/**
		 *文本字段背景的颜色 
		 * @param value
		 * 
		 */		
		public function set backgroundColor(value:uint):void
		{
			_backgroundColor = value;
			baseText.backgroundColor = value;
		}
		
		public function get border():Boolean
		{
			return _border;
		}
		/**
		 * 指定文本字段是否具有边框
		 * @param value
		 * 
		 */		
		public function set border(value:Boolean):void
		{
			_border = value;
			baseText.border = value;
		}
		
		public function get borderColor():uint
		{
			return _borderColor;
		}
		/**
		 *文本字段边框的颜色 
		 * @param value
		 * 
		 */		
		public function set borderColor(value:uint):void
		{
			_borderColor = value;
			baseText.borderColor = value;
		}
		
		public function get displayAsPassword():Boolean
		{
			return _displayAsPassword;
		}
		/**
		 *指定文本字段是否是密码文本字段 
		 * @param value
		 * 
		 */		
		public function set displayAsPassword(value:Boolean):void
		{
			_displayAsPassword = value;
			baseText.displayAsPassword = value;
		}
		
		public function get embedFonts():Boolean
		{
			return _embedFonts;
		}
		/**
		 *指定是否使用嵌入字体轮廓进行呈现 
		 * @param value
		 * 
		 */		
		public function set embedFonts(value:Boolean):void
		{
			_embedFonts = value;
			baseText.embedFonts = value;
		}
		
		public function get text():String
		{
			return baseText.text;
		}
		/**
		 *作为文本字段中当前文本的字符串 
		 * @param value
		 * 
		 */		
		public function set text(value:String):void
		{
			_text = value;
			baseText.text = value;
		}
		
		public function get htmlText():String
		{
			return _htmlText;
		}
		/**
		 *包含文本字段内容的 HTML 表示形式 
		 * @param value
		 * 
		 */		
		public function set htmlText(value:String):void
		{
			_htmlText = value;
			baseText.htmlText = value;
		}
		
		public function get maxChars():int
		{
			return _maxChars;
		}
		/**
		 *文本字段中最多可包含的字符数（即用户输入的字符数） 
		 * @param value
		 * 
		 */		
		public function set maxChars(value:int):void
		{
			_maxChars = value;
			baseText.maxChars = value;
		}
		
		public function get mouseWheelEnabled():Boolean
		{
			return _mouseWheelEnabled;
		}
		/**
		 * 一个布尔值，表示当用户单击某个文本字段并滚动鼠标滚轮时，Flash Player 是否自动滚动多行文本字段
		 * @param value
		 * 
		 */		
		public function set mouseWheelEnabled(value:Boolean):void
		{
			_mouseWheelEnabled = value;
			baseText.mouseWheelEnabled = value;
		}
		
		public function get multiline():Boolean
		{
			return _multiline;
		}
		/**
		 *表示字段是否为多行文本字段 
		 * @param value
		 * 
		 */		
		public function set multiline(value:Boolean):void
		{
			_multiline = value;
			baseText.multiline = value;
		}
		
		public function get restrict():String
		{
			return _restrict;
		}
		/**
		 *表示用户可输入到文本字段中的字符集 
		 * @param value
		 * 
		 */		
		public function set restrict(value:String):void
		{
			_restrict = value;
			baseText.restrict = value;
		}
		
		public function get selectable():Boolean
		{
			return _selectable;
		}
		/**
		 *一个布尔值，表示文本字段是否可选 
		 * @param value
		 * 
		 */		
		public function set selectable(value:Boolean):void
		{
			_selectable = value;
			baseText.selectable = value;
		}
		
		public function get styleSheet():StyleSheet
		{
			return _styleSheet;
		}
		/**
		 *将样式表附加到文本字段 
		 * @param value
		 * 
		 */		
		public function set styleSheet(value:StyleSheet):void
		{
			_styleSheet = value;
			baseText.styleSheet = value;
		}
		
		public function get wordWrap():Boolean
		{
			return _wordWrap;
		}
		/**
		 *一个布尔值，表示文本字段是否自动换行 
		 * @param value
		 * 
		 */		
		public function set wordWrap(value:Boolean):void
		{
			_wordWrap = value;
			baseText.wordWrap = value;
		}
		
		/**
		 *一个整数（从 1 开始的索引），表示指定文本字段中当前可以看到的最后一行 
		 * @return 
		 * 
		 */		
		public function get bottomScrollV():int
		{
			return baseText.bottomScrollV;
		}
		/**
		 *插入点（尖号）位置的索引 
		 * @return 
		 * 
		 */		
		public function get caretIndex():int
		{
			return baseText.caretIndex;
		}
		/**
		 *  文本字段中的字符数
		 * @return 
		 * 
		 */		
		public function get length():int
		{
			return baseText.length;
		}
		/**
		 *定义多行文本字段中的文本行数 
		 * @return 
		 * 
		 */		
		public function get numLines():int
		{
			return baseText.numLines;
		}
		/**
		 *文本的宽度，以像素为单位。 
		 * @return 
		 * 
		 */		
		public function get textWidth():Number
		{
			return baseText.textWidth;
		}
		/**
		 *文本的高度，以像素为单位。 
		 * @return 
		 * 
		 */		
		public function get textHeight():Number
		{
			return baseText.textHeight;
		}
		public function get textAliasType():int
		{
			return baseText.textAliasType;
		}
		/**
		 * 消除锯齿
		 * @param value 0：不消除 1：消除
		 * 
		 */		
		public function set textAliasType(value:int):void
		{
			baseText.textAliasType = value;
		}
	}
}