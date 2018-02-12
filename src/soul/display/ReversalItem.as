/**
 * 3D旋转对象 
 */
package soul.display
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	
	import soul.tween.TweenLite;
	import soul.tween.easing.Linear;
	import soul.utils.Util;
	
	public class ReversalItem extends BaseSprite
	{
		public var posItem:BaseSprite = new BaseSprite();
		public var negItem:BaseSprite = new BaseSprite();
		public var currentItem:BaseSprite;
		public var isR:Boolean = false;
		public var pos:DisplayObject;
		public var neg:DisplayObject;
		private var _time:int;
		private var _type:String;
		/**
		 * 
		 * @param pos 正面
		 * @param neg 反面
		 * 
		 */		
		public function ReversalItem(pos:DisplayObject,neg:DisplayObject,time:int = 1,type:String="y")
		{
			super();
			this.pos = pos;
			this.neg = neg;
			_time = time;
			_type = type;
			posItem.removeAllChildren();
			posItem.addChild(pos);
			pos.x = -pos.width/2;
			pos.y = -pos.height/2;
			posItem.x = pos.width/2;
			posItem.y = pos.height/2;
			negItem.removeAllChildren(); ;
			negItem.addChild(neg);
			neg.x = -neg.width/2;
			neg.y = -neg.height/2;
			negItem.x = neg.width/2;
			negItem.y = neg.height/2;
			this.addChild(posItem);
			currentItem = posItem;
			Util.set3DVidicon(this,new Point(negItem.x,negItem.y),20);
		}
		/**
		 *翻转
		 * 
		 */		
		public function reversal():void
		{
			if(isR) return;
			isR = true;
			var ro:Number;
			if(_type == "x" || _type == "X")
			{
				ro = currentItem.rotationX;
				ro +=90;
				TweenLite.to(currentItem,_time/2,{rotationX:ro,ease:Linear.easeNone,onComplete:reversalHandler});
			}
			else if(_type == "y" || _type == "Y")
			{
				ro = currentItem.rotationY;
				ro +=90;
				TweenLite.to(currentItem,_time/2,{rotationY:ro,ease:Linear.easeNone,onComplete:reversalHandler});
			}
			else if(_type == "z" || _type == "Z")
			{
				ro = currentItem.rotationZ;
				ro +=90;
				TweenLite.to(currentItem,_time/2,{rotationZ:ro,ease:Linear.easeNone,onComplete:reversalHandler});
			}
			else
			{
				ro = currentItem.rotationY;
				ro +=90;
				TweenLite.to(currentItem,_time/2,{rotationY:ro,ease:Linear.easeNone,onComplete:reversalHandler});
			}
		}
		private function reversalHandler():void
		{
			var ro:Number = 270;
			if(negItem.parent)
			{
				negItem.parent.removeChild(negItem);
				this.addChild(posItem);
				currentItem = posItem;
			}
			else if(posItem.parent)
			{
				posItem.parent.removeChild(posItem);
				this.addChild(negItem);
				currentItem = negItem;
			}
			else
			{
				return;
			}
			
			if(_type == "x" || _type == "X")
			{
				currentItem.rotationX = ro;
				
				ro +=90;
				TweenLite.to(currentItem,_time/2,{rotationX:ro,ease:Linear.easeNone,onComplete:reversalComplete});
			}
			else if(_type == "y" || _type == "Y")
			{
				currentItem.rotationY = ro;
				
				ro +=90;
				TweenLite.to(currentItem,_time/2,{rotationY:ro,ease:Linear.easeNone,onComplete:reversalComplete});
			}
			else if(_type == "z" || _type == "Z")
			{
				currentItem.rotationZ = ro;
				
				ro +=90;
				TweenLite.to(currentItem,_time/2,{rotationZ:ro,ease:Linear.easeNone,onComplete:reversalComplete});
			}
			else
			{
				currentItem.rotationY = ro;
				
				ro +=90;
				TweenLite.to(currentItem,_time/2,{rotationY:ro,ease:Linear.easeNone,onComplete:reversalComplete});
			}
			
		}
		private function reversalComplete():void
		{
			Util.removeMatrix3D(currentItem);
			
			isR = false;
		}
	}
}