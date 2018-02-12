package soul.ui
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class RadioButtonGroup extends EventDispatcher
	{
		private static var groups:Object = new Object();
		private var radios:Array = new Array();
		private var _selecttion:RadioButton;
		public function RadioButtonGroup()
		{
			super();
		}
		public static function getGroup(name:String):RadioButtonGroup 
		{
			if (groups[name] == null) 
			{
				groups[name] = new RadioButtonGroup();
			}
			return groups[name];
		}
		/**
		 *radioButton个数 
		 * @return 
		 * 
		 */		
		public function get numRadioButtons():uint 
		{
			return radios.length;
		}
		/**
		 *选中的radioButton 
		 * @return 
		 * 
		 */		
		public function get selection():RadioButton 
		{
			return _selecttion;
		}
		/**
		 *选中项的数据 
		 * @return 
		 * 
		 */		
		public function get selectedData():Object 
		{
			return _selecttion.data;
		}
		/**
		 *增加radioButton 
		 * @param radioButton
		 * 
		 */		
		public function addRadioButton(radioButton:RadioButton):void
		{
			if (getRadioButtonIndex(radioButton) == -1) 
			{
				radios.push(radioButton);
				radioButton.addEventListener(Event.CHANGE, setOneSelect);
			}
		}
		/**
		 *获取 radioButton的索引
		 * @param radioButton
		 * @return 
		 * 
		 */		
		public function getRadioButtonIndex(radioButton:RadioButton):int 
		{
			var index:int = -1;
			for (var i:int = 0; i < radios.length; i++) 
			{
				if (radios[i] == radioButton) 
				{
					index = i;
				}
			}
			
			return index;
		}
		/**
		 *删除radioButton 
		 * @param radioButton
		 * 
		 */		
		public function removeRadioButton(radioButton:RadioButton):void 
		{
			radioButton.removeEventListener(Event.CHANGE, setOneSelect);
			for (var i:int = 0; i < radios.length; i++) 
			{
				if (radios[i] == radioButton) 
				{
					radios.splice(i, 1);
				}
			}
		}
		private function setOneSelect(event:Event):void
		{
			var tar:RadioButton = event.currentTarget as RadioButton;
			_selecttion = tar;
			if (tar.selected == false) 
			{
				return;
			}
			for (var i:int = 0; i < radios.length; i++) 
			{
				if (radios[i] != event.currentTarget) 
				{
					RadioButton(radios[i]).selected = false;
				}
			}
		}
	}
}