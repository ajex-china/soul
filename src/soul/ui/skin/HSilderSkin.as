package soul.ui.skin
{
	import soul.ui.BaseButton;
	import soul.ui.Silder;
	import soul.ui.UIComponent;
	import soul.ui.UIEnabledDisplay;
	
	import flash.display.DisplayObject;
	
	public class HSilderSkin extends Skin
	{
		private var _ui:Silder;
		public function HSilderSkin(ui:UIComponent=null)
		{
			super(ui);
			if(!(ui is Silder)) return;
			_ui = ui as Silder;
			_ui.background = new UIEnabledDisplay(resource.getClassObject("HSliderTrack_skin"),resource.getClassObject("HSliderTrack_disabledSkin"));
			_ui.thumb = new BaseButton(HSilderButtonSkin);
		}
	}
}