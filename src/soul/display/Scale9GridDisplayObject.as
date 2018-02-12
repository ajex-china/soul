package soul.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Scale9GridDisplayObject extends Sprite
	{
		private var _sourceData:BitmapData;
		private var rect:Rectangle;
		
		private var grid00:DisplayObject;
		private var grid10:DisplayObject;
		private var grid20:DisplayObject;
		private var grid01:DisplayObject;
		private var grid11:DisplayObject;
		private var grid21:DisplayObject;
		private var grid02:DisplayObject;
		private var grid12:DisplayObject;
		private var grid22:DisplayObject;
		
		private var _width:Number;
		private var _height:Number;
		
		private var _minWidth:Number = 0;
		private var _minHeight:Number = 0;

		public function Scale9GridDisplayObject(source:Object,rectangle:Rectangle = null)
		{
			if(source is BitmapData){
				this._sourceData = BitmapData(source);
			}else{
				this._sourceData = new BitmapData(source.width+0.99999,source.height+0.99999,true,0);
				this._sourceData.draw(visualize(source));
			}
			
			if(rectangle != null){
				this.rect = rectangle;
			}else if(null != source.scale9Grid){
				this.rect = source.scale9Grid;
			}else{
				this.rect = new Rectangle(0,0,_sourceData.width,_sourceData.height);
			}
			
			this._width = _sourceData.width;
			this._height = _sourceData.height;
			
			grid00 = getBitmap(0,			0,rect.left,				rect.top);
			grid01 = getBitmap(rect.left,	0,rect.width,				rect.top);
			grid02 = getBitmap(rect.right,	0,this._width - rect.right,rect.top);
			
			grid10 = getBitmap(0,			rect.top,rect.left,					rect.height);
			grid11 = getBitmap(rect.left,	rect.top,rect.width,					rect.height);
			grid12 = getBitmap(rect.right,	rect.top,this._width - rect.right,	rect.height);
			
			grid20 = getBitmap(0,			rect.bottom,rect.left,					this._height - rect.bottom);
			grid21 = getBitmap(rect.left,	rect.bottom,rect.width,					this._height - rect.bottom);
			grid22 = getBitmap(rect.right,	rect.bottom,this._width - rect.right,	this._height - rect.bottom);
			
			this._minWidth = grid00.width+grid02.width;
			this._minHeight = grid00.height + grid20.height;

		}
		public function getBitmap(x:Number,y:Number,width:Number,height:Number):Bitmap{
			if(width<=0||height<=0){
				return null
			}
			var bitmapData:BitmapData = new BitmapData(width,height,true,1);
			bitmapData.copyPixels(this._sourceData,new Rectangle(x,y,width,height),new Point(0,0));
			var bitmap:Bitmap = new Bitmap(bitmapData,PixelSnapping.NEVER);
			bitmap.x = x;
			bitmap.y = y;
			this.addChild(bitmap);
			return bitmap;
		}
		
		override public function set width(newWidth:Number):void{
			if(newWidth < this._minWidth){
				newWidth = _minWidth;
			}
			update(newWidth - this._width,0);
			this._width = newWidth;
		} 
		
		override public function set height(newHeight:Number):void{
			if(newHeight< this._minHeight){
				newHeight = _minHeight;
			}
			update(0,newHeight - this._height);
			this._height = newHeight;
		} 
		
		public function update(diffW:Number,diffH:Number):void{
			if(diffW != 0){
				diff(grid01,"width",diffW);
				diff(grid11,"width",diffW);
				diff(grid21,"width",diffW);
				diff(grid02,"x",diffW);
				diff(grid12,"x",diffW);
				diff(grid22,"x",diffW);
			}
			if(diffH != 0){
				diff(grid10,"height",diffH);
				diff(grid11,"height",diffH);
				diff(grid12,"height",diffH);
				diff(grid20,"y",diffH);
				diff(grid21,"y",diffH);
				diff(grid22,"y",diffH);
			}
		}
		
		public function diff(obj:DisplayObject,property:String,diffNum:Number):void{
			obj[property] += diffNum;
		}
		
		public function visualize(src:Object):DisplayObject{
			if(src== null) return null;
			var target:DisplayObject;
			if(src is DisplayObject) target = DisplayObject(src);
			return target;
		}
	}
}