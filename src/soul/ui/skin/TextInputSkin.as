package soul.ui.skin
{
	import soul.ui.TextInput;
	import soul.ui.UIComponent;
	
	import flash.display.DisplayObject;
	
	public class TextInputSkin extends Skin
	{
		private var _ui:TextInput;
		public function TextInputSkin(ui:UIComponent)
		{
			if(!(ui is TextInput)) return;
			_ui = ui as TextInput;
			_ui.normalSkin =  resource.getClassObject("TextInput_upSkin") as DisplayObject;
			_ui.disabledSkin = resource.getClassObject("TextInput_disabledSkin") as DisplayObject;
		}
	}
}