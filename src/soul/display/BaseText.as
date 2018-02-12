package soul.display
{
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class BaseText extends TextField
	{
		
		private var _format:TextFormat;
		private var _color:Object = 0x000000;
		private var _bold:Object;
		private var _font:String;
		private var _italic:Object;
		private var _size:Object = 12;
		private var _leading:Object = 2;
		private var _htmlText:String="";
		private var _align:String;
		private var _blockIndent:Object;
		private var _leftMargin:Object;
		private var _rightMargin:Object; 
		private var _underline:Object;
		private var _textAliasType:int;
		/**
		 * 是否已经被销毁
		 */
		public var destoryed:Boolean = false;
		public function BaseText()
		{
			super();
			_format = new TextFormat();
			//_format.align = TextFormatAlign.CENTER;
			//_format.color = _color;
			//			this.font = "Microsoft Yahei";
			//			_format.leading = _leading;
			this.autoSize = TextFieldAutoSize.LEFT;
			this.addEventListener(Event.ADDED_TO_STAGE,setformatHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE,remove);
		}
		
		public function get color():Object
		{
			return _format.color;
		}
		/**
		 *表示文本的颜色 
		 * @param value
		 * 
		 */		
		public function set color(value:Object):void
		{
			_format.color = value;
			_color = value;
			setformatHandler();
		}
		
		public function get bold():Object
		{
			return _format.bold;
		}
		/**
		 *指定文本是否为粗体字 
		 * @param value
		 * 
		 */		
		public function set bold(value:Object):void
		{
			_format.bold = value;
			_bold = value;
		}
		
		public function get font():String
		{
			return _format.font;
		}
		/**
		 *使用此文本格式的文本的字体名称，以字符串形式表示 
		 * @param value
		 * 
		 */		
		public function set font(value:String):void
		{
			_format.font = value;
			_font = value;
			setformatHandler();
		}
		
		public function get italic():Object
		{
			return _format.italic;
		}
		/**
		 *表示使用此文本格式的文本是否为斜体 
		 * @param value
		 * 
		 */		
		public function set italic(value:Object):void
		{
			_format.italic = value;
			_italic = value;
		}
		
		public function get size():int
		{
			if(!_format.size) return 12;
			return int(_format.size);
		}
		/**
		 *用此文本格式的文本的大小（以像素为单位） 
		 * @param value
		 * 
		 */		
		public function set size(value:int):void
		{
			_format.size = value;
			_size = value;
			setformatHandler();
		}
		/**
		 * 得到字体格式 
		 * @return 
		 * 
		 */		
		public function getFormat():TextFormat
		{
			return _format;
		}
		/**
		 *强制更新格式 
		 * 
		 */		
		public function CompulsorySetformat():void
		{
			setformatHandler();
		}
		private function setformatHandler(e:Event=null):void
		{
			setformat(_format);
		}
		public function setformat(format:TextFormat):void
		{
			_format = format;
			this.setTextFormat(format);
			//if(_htmlText != "") super.htmlText = _htmlText;
			this.defaultTextFormat = format;
		}
		private function remove(e:Event):void
		{
			
		}
		public function destory():void
		{
			if (destoryed)
				return;
			
			this.removeEventListener(Event.ADDED_TO_STAGE,setformatHandler);
			this.removeEventListener(Event.REMOVED_FROM_STAGE,remove);
			_format = null;
			
			if (parent)
				parent.removeChild(this);
			
			destoryed = true;
		}
		public function get leading():Object
		{
			return _format.leading;
		}
		/**
		 *一个整数，表示行与行之间的垂直间距（称为前导）量 
		 * @param value
		 * 
		 */		
		public function set leading(value:Object):void
		{
			_format.leading = value;
			_leading = value;
		}
		//		override public function set htmlText(value:String):void
		//		{
		//			super.htmlText = value;
		//			_htmlText = value;
		//		}
		//		
		public function get align():String
		{
			return _align;
		}
		/**
		 *文本对齐方式  
		 * @param value  center(文本居中对齐) justify(文本两端对齐) left(文本左对齐) right(文本右对齐)
		 * 
		 */		
		public function set align(value:String):void
		{
			_align = value;
			_format.align = value;
		}
		
		public function get blockIndent():Object
		{
			return _blockIndent;
		}
		/**
		 *表示块缩进，以像素为单位 
		 * @param value
		 * 
		 */		
		public function set blockIndent(value:Object):void
		{
			_blockIndent = value;
			_format.blockIndent = value;
		}
		
		public function get leftMargin():Object
		{
			return _leftMargin;
		}
		/**
		 * 段落的左边距，以像素为单位 
		 * @param value
		 * 
		 */		
		public function set leftMargin(value:Object):void
		{
			_leftMargin = value;
			_format.leftMargin = value;
		}
		
		public function get rightMargin():Object
		{
			return _rightMargin;
		}
		/**
		 *段落的右边距，以像素为单位 
		 * @param value
		 * 
		 */		
		public function set rightMargin(value:Object):void
		{
			_rightMargin = value;
			_format.rightMargin = value;
		}
		/**
		 *一个数字，表示在所有字符之间均匀分配的空间量。 
		 * @param value
		 * 
		 */		
		public function set letterSpacing(value:Object):void
		{
			_format.letterSpacing = value;
		}
		
		public function get letterSpacing():Object
		{
			return _format.letterSpacing
		}
		
		public function get underline():Object
		{
			return _underline;
		}
		/**
		 *表示使用此文本格式的文本是带下划线 (true) 还是不带下划线 (false) 
		 * @param value
		 * 
		 */		
		public function set underline(value:Object):void
		{
			_underline = value;
			_format.underline = value;
		}
		
		public function get textAliasType():int
		{
			return _textAliasType;
		}
		/**
		 *消除锯齿 必须嵌入字体
		 * @param value 0：不消除  1：消除
		 * 
		 */
		public function set textAliasType(value:int):void
		{
			_textAliasType = value;
			if(value == 0)
			{
				this.antiAliasType = AntiAliasType.NORMAL;
				this.gridFitType = GridFitType.PIXEL;
			}
			else if(value == 1)
			{
				this.embedFonts = true;
				this.antiAliasType = AntiAliasType.ADVANCED;
				this.gridFitType = GridFitType.SUBPIXEL;
			}
			
		}
		
		
	}
}