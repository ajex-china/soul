package soul.ui.skin
{
	import soul.ui.BaseButton;
	import soul.ui.Silder;
	import soul.ui.UIComponent;
	import soul.ui.UIEnabledDisplay;
	
	public class VSilderSkin extends Skin
	{
		private var _ui:Silder;
		public function VSilderSkin(ui:UIComponent=null)
		{
			super(ui);
			if(!(ui is Silder)) return;
			_ui = ui as Silder;
			_ui.background = new UIEnabledDisplay(resource.getClassObject("VSliderTrack_skin"),resource.getClassObject("VSliderTrack_disabledSkin"));
			_ui.thumb = new BaseButton(VSilderButtonSkin);
		}
	}
}