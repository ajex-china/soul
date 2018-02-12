package com.view
{
	import com.event.ProgramEvent;
	
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import soul.display.BaseText;
	import soul.manager.PopManager;
	import soul.ui.Button;
	import soul.ui.CheckBox;
	import soul.ui.ComboBox;
	import soul.ui.Drawer;
	import soul.ui.HSilder;
	import soul.ui.List;
	import soul.ui.RadioButton;
	import soul.ui.ScrollContainer;
	import soul.ui.TextArea;
	import soul.ui.TextInput;
	
	
	
	public class MainView extends BaseView
	{
		protected var button:Button;
		protected var buttonText:BaseText;
		
		protected var checkBoxText:BaseText;
		protected var checkBox:CheckBox;
		
		protected var radioButton1:RadioButton;
		protected var radioButton2:RadioButton;
		protected var radioButtonText:BaseText;
		
		protected var textInput:TextInput;
		protected var textInputText:BaseText;
		
		protected var textArea:TextArea;
		protected var textAreaText:BaseText;
		
		protected var list:List;
		protected var listText:BaseText;
		
		protected var comboBox:ComboBox;
		protected var comboBoxText:BaseText;
		
		protected var hSilder:HSilder;
		protected var silderText:BaseText;
		
		protected var drawer:Drawer;
		protected var drawerText:BaseText;
		
		protected var scrollPanel:ScrollContainer
		//		private var scrollPanel:ScrollContainer
		//		private var _baseSprite:BaseSprite;
		//		private var _baseText:BaseText;
		protected var baseText:BaseText
		public function MainView()
		{
			model.addEventListener(ProgramEvent.INIT_COMPLETE,initDataComplete);
		}
		private function initDataComplete(e:ProgramEvent):void
		{
			model.removeEventListener(ProgramEvent.INIT_COMPLETE,initDataComplete);
			buttonText = new BaseText();
			buttonText.text = "Button:";
			this.addChild(buttonText);
			buttonText.x = 10;
			buttonText.y = 10;
			
			button = new Button();
			this.addChild(button);
			button.x = 70;
			button.y = 10;
//			var bitmap1:Bitmap = new Bitmap(Bitmap(resource.getResouce("assets/image/btn1.png")).bitmapData);
//			var bitmap2:Bitmap = new Bitmap(Bitmap(resource.getResouce("assets/image/btn2.png")).bitmapData);
//			var bitmapDis1:Scale9GridDisplayObject = new Scale9GridDisplayObject(bitmap1.bitmapData,new Rectangle(3,4,153,26));
//			var bitmapDis2:Scale9GridDisplayObject = new Scale9GridDisplayObject(bitmap2.bitmapData,new Rectangle(5,5,150,25));
//			button.changeSkin("normalUpSkin",bitmapDis1);
//			button.changeSkin("normalOverSkin",bitmapDis1);
//			button.changeSkin("normalDownSkin",bitmapDis2);
//			button.changeSkin("normalDisabledSkin",bitmapDis1);
			
			checkBoxText = new BaseText();
			checkBoxText.text = "CheckBox:";
			this.addChild(checkBoxText);
			checkBoxText.x = 200;
			checkBoxText.y = 10;
			
			checkBox = new CheckBox();
			this.addChild(checkBox);
			checkBox.x = 270;
			checkBox.y = 10;
			
			radioButtonText = new BaseText();
			radioButtonText.text = "RadioButton:";
			this.addChild(radioButtonText);
			radioButtonText.x = 400;
			radioButtonText.y = 10;
			
			radioButton1 = new RadioButton();
			radioButton1.selected = true;
			this.addChild(radioButton1)
			radioButton1.x = 470;
			radioButton1.y = 10;
			
			radioButton2 = new RadioButton();
			this.addChild(radioButton2)
			radioButton2.x = 470;
			radioButton2.y = 30;
			
			textInputText = new BaseText();
			textInputText.text = "TextInput:";
			this.addChild(textInputText);
			textInputText.x = 600;
			textInputText.y = 10;
			
			textInput = new TextInput();
			this.addChild(textInput);
			textInput.x = 670;
			textInput.y = 10;
			
			textAreaText = new BaseText();
			textAreaText.text="TextArea:";
			this.addChild(textAreaText);
			textAreaText.x = 10;
			textAreaText.y = 100;
			
			textArea = new TextArea();
			this.addChild(textArea);
			textArea.x = 70;
			textArea.y = 100;
			
			listText = new BaseText();
			listText.text="List:";
			this.addChild(listText);
			listText.x = 300;
			listText.y = 100;
			
			var data:Array = [
				{label:"1朵菊花"},
				{label:"1朵菊花"},
				{label:"1朵菊花"},
				{label:"1朵菊花"},
				{label:"1朵菊花"},
				{label:"1朵菊花"},
				{label:"1朵菊花"}
			];
			list = new List();
			list.dataProvider = data;
			this.addChild(list);
			list.x = 370;
			list.y = 100;
			list.itemAlign = "center";
			
			comboBoxText = new BaseText();
			comboBoxText.text="ComboBox:";
			this.addChild(comboBoxText);
			comboBoxText.x = 500;
			comboBoxText.y = 100;
			
			comboBox = new ComboBox();
			comboBox.dataProvider = data;
			this.addChild(comboBox);
			comboBox.x = 570;
			comboBox.y = 100;
			
			silderText = new BaseText();
			silderText.text = "Silder:";
			this.addChild(silderText);
			silderText.x = 10;
			silderText.y = 290;
			
			hSilder = new HSilder();
			this.addChild(hSilder);
			hSilder.x = 60;
			hSilder.y = 300;
			
			drawerText = new BaseText();
			drawerText.text = "Drawer:";
			this.addChild(drawerText);
			drawerText.x = 700;
			drawerText.y = 100
			var treeData:Object = [
				{label:"第一章",children:[{label:"斯坦尼的崛起"},{label:"雅典娜的守护"}]},
				{label:"第二章",children:[{label:"斯坦尼的崛起"},{label:"雅典娜的守护"}]},
				{label:"第三章",children:[{label:"斯坦尼的崛起"},{label:"雅典娜的守护"}]},
				{label:"第一章",children:[{label:"斯坦尼的崛起"},{label:"雅典娜的守护"}]},
				{label:"第二章",children:[{label:"斯坦尼的崛起"},{label:"雅典娜的守护"}]},
				{label:"第三章",children:[{label:"斯坦尼的崛起"},{label:"雅典娜的守护"}]},
				{label:"第一章",children:[{label:"斯坦尼的崛起"},{label:"雅典娜的守护"}]},
				{label:"第二章",children:[{label:"斯坦尼的崛起"},{label:"雅典娜的守护"}]},
				{label:"第三章",children:[{label:"斯坦尼的崛起"},{label:"雅典娜的守护"}]}
			]
			drawer = new Drawer();
			drawer.dataProvider = treeData;
			this.addChild(drawer);
			drawer.x = 750;
			drawer.y = 100;
			
			
			PopManager.pop("卡萨丁话费卡是东方红卡萨丁话费卡是东方红卡萨丁话费卡是东方红卡萨丁话费卡是东方红卡萨丁话费卡是东方红卡萨丁话费卡是东方红卡萨丁话费卡是东方红卡萨丁话费卡是东方红卡萨丁话费卡是东方红卡萨丁话费卡是东方红卡萨丁话费卡是东方红",1,stage);
			
//			setTimeout(function (){
//				list.dataProvider = [
//					{label:"1朵菊花"},
//					{label:"1朵菊花"},
//					{label:"1朵菊花"},
//					{label:"1朵菊花"},
//					{label:"1朵菊花"},
//					{label:"1朵菊花"},
//					{label:"1朵菊花"},
//					{label:"1朵菊花"},
//					{label:"1朵菊花"},
//					{label:"1朵菊花"},
//					{label:"1朵菊花"},
//					{label:"1朵菊花"},
//					{label:"1朵菊花"},
//					{label:"1朵菊花"}
//				];
//				list.height = 300;
//			}
//				,1000)
			stage.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		private function clickHandler(e:MouseEvent):void
		{
//			drawer.vScrollBar.cacheAsBitmap = false;
		}
		override public function resize():void
		{
			super.resize();
		}
	}
}