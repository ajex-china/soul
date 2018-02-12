package soul.ui
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	import soul.interFace.IRender;
	import soul.manager.ResourceManager;
	import soul.ui.skin.ListItemRenderSkin;
	
	/**
	 *List的项呈示器 
	 * @author Ajex
	 * 
	 */	
	public class ListItemRender extends Button implements IRender
	{
		public var icon:DisplayObject;
		private var _width:Number;
		private var _height:Number;
		private var _align:String=TextFormatAlign.LEFT;
		public function ListItemRender()
		{
			super();
		}
		override public function setDefaultSkin():void
		{
			setSkin(ListItemRenderSkin);
		}
		override protected function setStyle():void
		{
			super.setStyle();
			this.labelUI.align = TextFormatAlign.LEFT;
			this.labelUI.autoSize = TextFieldAutoSize.LEFT;
			this.label="";
		}
		override public function set data(v:*):void
		{
			super.data = v;
			if(_data.label)
			{
				label = _data.label;
			}
			if(icon)
			{
				if(icon.parent)
				{
					icon.parent.removeChild(icon);
				}
				icon = null;
			}
			if(_data.icon)
			{
				if(_data.icon is String)
				{
					icon = ResourceManager.getInstance().getClassObject(_data.icon)
				}
				else if(_data.icon is Class)
				{
					var cls:Class = _data.icon
					icon = new cls();
				}
				else if(_data.icon is DisplayObject)
				{
					icon = _data.icon
				}
				if(icon)
				{
					this.addChild(icon);
				}
			}
			
		}

		public function get align():String
		{
			return _align;
		}
		/**
		 *  
		 * @param value left right center
		 * 
		 */		
		public function set align(value:String):void
		{
			_align = value;
			updateAlign();
		}
		public function updateAlign():void
		{
			switch(_align)
			{
				case "left":
				{
					if(icon)
					{
						icon.x = 3;
						labelUI.x = icon.x + icon.width + 5;
					}
					else
					{
						labelUI.x = 3;
					}
					break;
				}
				case "right":
				{
					if(icon)
					{
						icon.x = width - 3 - icon.width;
						labelUI.x = icon.x - labelUI.width - icon.width - 5;
					}
					else
					{
						labelUI.x =  width - 3;
					}
					break;
				}
				case "center":
				{
					if(icon)
					{
						icon.x = width/2 - (icon.width + labelUI.width + 5)/2;
						labelUI.x = icon.x + icon.width + 5
					}
					else
					{
						labelUI.x = width/2 - labelUI.width/2;
					}
					break;
				}
				default:
				{
					break;
				}
			}
			if(icon) icon.y = this.height/2-icon.height/2;
			labelUI.y = this.height/2 - labelUI.height/2;
		}
		override protected function updateSize():void
		{
			super.updateSize();
			updateAlign();
		}
	}
}