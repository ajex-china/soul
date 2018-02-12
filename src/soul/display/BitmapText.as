package soul.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	public class BitmapText extends BaseSprite
	{
		public var baseText:BaseText = new BaseText();
		public var bitmap:Bitmap;
		public function BitmapText()
		{
			super();
			bitmap = new Bitmap();
			this.addChild(bitmap);
		}
		public function changeBitmap():void
		{
			var myBitmapData:BitmapData = new BitmapData(baseText.width,baseText.height,true,0); 
			myBitmapData.draw(baseText); 
			bitmap.bitmapData = myBitmapData;
		}
	}
}