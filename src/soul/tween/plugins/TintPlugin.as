package  soul.tween.plugins  {
	
	import flash.display.*;
	import flash.geom.ColorTransform;
	import flash.geom.Transform;
	
	import soul.tween.TweenLite;
	import soul.tween.core.PropTween;

	public class TintPlugin extends TweenPlugin {
		public static const API:Number = 2; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		protected static var _props:Array = ["redMultiplier","greenMultiplier","blueMultiplier","alphaMultiplier","redOffset","greenOffset","blueOffset","alphaOffset"];
		
		protected var _transform:Transform;
		
		public function TintPlugin() {
			super("tint,colorTransform,removeTint");
		}
		
		override public function _onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			if (!(target is DisplayObject)) {
				return false;
			}
			var end:ColorTransform = new ColorTransform();
			if (value != null && tween.vars.removeTint != true) {
				end.color = uint(value);
			}
			_transform = DisplayObject(target).transform;
			var ct:ColorTransform = _transform.colorTransform;
			end.alphaMultiplier = ct.alphaMultiplier;
			end.alphaOffset = ct.alphaOffset;
			_init(ct, end);
			return true;
		}
		
		public function _init(start:ColorTransform, end:ColorTransform):void {
			var i:int = _props.length, 
				p:String;
			while (--i > -1) {
				p = _props[i];
				if (start[p] != end[p]) {
					_addTween(start, p, start[p], end[p], "tint");
				}
			}
		}
		
		override public function setRatio(v:Number):void {
			var ct:ColorTransform = _transform.colorTransform, //don't just use _ct because if alpha changes are made separately, they won't get applied properly.
				pt:PropTween = _firstPT;
			while (pt) {
				ct[pt.p] = pt.c * v + pt.s;
				pt = pt._next;
			}
			_transform.colorTransform = ct;
		}
		
	}
}