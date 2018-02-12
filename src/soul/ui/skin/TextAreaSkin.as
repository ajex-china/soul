package soul.ui.skin
{
	import soul.ui.HScrollBar;
	import soul.ui.TextArea;
	import soul.ui.UIComponent;
	import soul.ui.VScrollBar;
	
	import flash.display.DisplayObject;
	
	public class TextAreaSkin extends Skin
	{
		private var _ui:TextArea;
		
		public function TextAreaSkin(ui:UIComponent)
		{
			super(ui)
			if(!(ui is TextArea)) return;
			_ui = ui as TextArea;
			_ui.normalSkin =  resource.getClassObject("TextArea_upSkin") as DisplayObject;
			_ui.disabledSkin = resource.getClassObject("TextArea_disabledSkin") as DisplayObject;
			_ui.vScrollBar = new VScrollBar();
			//_ui.hScrollBar = new HScrollBar();
		}
	}
}