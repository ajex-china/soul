package soul.ui.skin
{
	import soul.ui.BaseButton;
	import soul.ui.Button;
	import soul.ui.ComboBox;
	import soul.ui.List;
	import soul.ui.TextInput;
	import soul.ui.UIComponent;
	
	public class ComboBoxSkin extends Skin
	{
		private var _ui:ComboBox;
		public function ComboBoxSkin(ui:UIComponent)
		{
			super(ui)
			if(!(ui is ComboBox)) return;
			_ui = ui as ComboBox;
			_ui.list = new List();
			_ui.titleButton = new Button(ComboBoxButtonSkin);
			_ui.textInput = new TextInput();
		}
	}
}