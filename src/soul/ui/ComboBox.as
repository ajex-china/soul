package soul.ui
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import soul.events.UIEvent;
	import soul.ui.skin.ComboBoxSkin;
	
	
	[Event(name="change",type="flash.events.Event")]
	/**
	 *下拉栏组件 ComboBox:
	 * @author Ajex
	 * 
	 */	
	public class ComboBox extends UIComponent
	{
		public var titleButton:Button;
		public var list:List;
		public var textInput:TextInput;
		public var status:String="close";
		public var openArrow:String="down";//down or up
		private var _prompt:String;
		
		protected var _editable:Boolean = true;
		private var _dataProvider:Object;
		//private var _itemRender:Class;
		private var _enabled:Boolean = true;
		private var _rowCount:uint = 5;
		private var _rowHeight:Number=22;
		public function ComboBox(skin:Class=null)
		{
			super(skin);
		}
		override protected function constructor():void
		{
			super.constructor();
			if(titleButton)
			{
				this.addChild(titleButton);
			}
			if(textInput)
			{
				this.addChild(textInput);
			}
		}
		override protected function setStyle():void
		{
			titleButton.label = "";
			list.addEventListener(Event.CHANGE,selectedChange);
			list.addEventListener(UIEvent.LIST_ITEM_CLICK,itemClickHandler);
			titleButton.addEventListener(MouseEvent.CLICK,titleButtonClickHandler);
			if(textInput)
			{
				textInput.addEventListener(Event.CHANGE,checkItem);
				textInput.backgoundVisibled = false;
				textInput.x = 2;
			}
			this.editable = false;
			setSize(100,22,false);
		}
		override protected function init():void
		{
			super.init();
			if(selectedIndex == -1) selectedIndex = 0;
		}
		override public function setDefaultSkin():void
		{
			setSkin(ComboBoxSkin);
		}
		protected function selectedChange(e:Event):void
		{
			setSelectLabel();
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		protected function setSelectLabel(event:Event=null):void
		{
			if(list.length == 0 || list.selectedIndex < 0) 
			{
				textInput.text="";
			}
			else
			{
				textInput.text = list.getItemAt(list.selectedIndex).data.label;
			}
		}
		protected function titleButtonClickHandler(e:MouseEvent):void
		{
			if(status == "close")
			{
				openList();
			}
			else
			{
				closeList();
			}
			
		}
		protected function openList():void
		{
			status="open";
			if(stage.contains(list))
			{
				stage.removeChild(list);
				return;
			}
			if(list.length < rowCount)
			{
				list.height = list.length * list.rowHeight;
			}
			else
			{
				list.height = list.rowCount*list.rowHeight;
			}
			var po:Point;
			if(openArrow == "down")
			{
				po = this.localToGlobal(new Point(0,this.height));
			}
			else
			{
				po = this.localToGlobal(new Point(0,-list.height));
			}
			list.x = po.x;
			list.y = po.y;
			list.width = titleButton.width;
			
			stage.addChild(list);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,stageDownHandler);
		}
		//if(!list.container.contains(e.target as DisplayObject))
		protected function closeList():void
		{
			status="close";
			if(stage.contains(list)) stage.removeChild(list);
			stage.removeEventListener(MouseEvent.MOUSE_DOWN,stageDownHandler);
		}
		protected function itemClickHandler(e:UIEvent):void
		{
			this.dispatchEvent(new UIEvent(UIEvent.LIST_ITEM_CLICK,e.data));
			closeList();
		}
		protected function stageDownHandler(e:MouseEvent):void
		{
			if(!list.contains(e.target as DisplayObject)) 
			{
				closeList();
			}
		}
		protected function checkItem(e:Event):void
		{
			for(var i:int = 0;i < list.length;i++)
			{
				if(list.getItemAt(i).label == textInput.text) 
				{
					this.selectedIndex = i;
					return;
				}
			}
		}
		public function get editable():Boolean{
			return _editable;
		}
		public function set editable(value:Boolean):void{
			_editable = value;
			textInput.mouseEnabled = _editable;
			textInput.mouseChildren = _editable;
		}
		/**
		 * 数据源
		 * @param value
		 * 
		 */		
		public function set dataProvider(value:Object):void
		{
			_dataProvider = value;
			list.dataProvider = value;
		}
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		override public function set enabled(value:Boolean):void 
		{
			super.enabled = value;
			titleButton.enabled = value;
			list.enabled = value;
			textInput.enabled = value;
		}
		public function get itemRender():Class
		{
			//return _itemRender;
			return list.itemRender;
		}
		/**
		 *项呈示器  
		 * @param value
		 * 
		 */		
		public function set itemRender(value:Class):void
		{
			list.itemRender = value;
		}
		public function get selectedIndex():int
		{
			return list.selectedIndex;
		}
		/**
		 *选中项 索引位置 
		 * @param value
		 * 
		 */		
		public function set selectedIndex(value:int):void
		{
			list.selectedIndex = value;
		}
		/**
		 *选中项数据  
		 * @return 
		 * 
		 */		
		public function get selectItemData():Object
		{
			return list.selectItemData;
		}
		/**
		 *项呈示器个数 
		 * @return 
		 * 
		 */		
		public function get length():uint
		{
			return list.length;
		}
		public function get rowCount():uint
		{
			return _rowCount;
		}
		/**
		 *显示项数  
		 * @param value
		 * 
		 */		
		public function set rowCount(value:uint):void
		{
			_rowCount = value;
			list.rowCount = value;
		}
		public function get rowHeight():Number
		{
			return _rowHeight;
		}
		/**
		 *项高（不会更改总大小） 
		 * @param value
		 * 
		 */		
		public function set rowHeight(value:Number):void
		{
			_rowHeight = value;
			list.rowHeight = value;
		}
		
		public function get prompt():String
		{
			return _prompt;
		}
		/**
		 *按钮文字 
		 * @param value
		 * 
		 */		
		public function set prompt(value:String):void
		{
			_prompt = value;
			textInput.text = value;
		}
		public function get itemAlign():String
		{
			return list.itemAlign;
		}
		/**
		 *  
		 * @param value left: 左对齐 right: 右对齐 center:居中
		 * 
		 */
		public function set itemAlign(value:String):void
		{
			list.itemAlign = value;
			textInput.align = value;
		}
		/**
		 *增加滚动子集 
		 * @param item
		 * 
		 */		
		public function addItem(item:Object):void
		{
			list.addItem(item);
		}
		/**
		 * 增加滚动子集 
		 * @param item
		 * @param index
		 * 
		 */		
		public function addItemAt(item:Object,index:uint):void
		{
			list.addItemAt(item,index);
		}
		/**
		 *删除滚动子集 
		 * @param item
		 * 
		 */		
		public function removeItem(item:Object):void
		{
			list.removeItem(item);
		}
		/**
		 *删除滚动子集 
		 * @param index
		 * 
		 */		
		public function removeItemAt(index:uint):void
		{
			list.removeItemAt(index);
		}
		/**
		 * 删除全部滚动子集 
		 * 
		 */		
		public function removeAllItem():void
		{
			list.removeAllItem();
		}
		/**
		 *得到index的滚动子集 
		 * @param index
		 * @return 
		 * 
		 */		
		public function getItemAt(index:uint):Object
		{
			return list.getItemAt(index);
		}
		
		override protected function updateSize():void
		{
			super.updateSize();
			titleButton.width = BaseWidth;
			titleButton.height = BaseHeight;
			titleButton.vaildSize();
			if(textInput)
			{
				if(BaseWidth < 25)
				{
					textInput.width = BaseWidth;
				}
				else
				{
					textInput.width = BaseWidth-25;
				}
				
				textInput.height = BaseHeight;
			}
			
		}
		
	}
}