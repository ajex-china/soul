package  soul.tween.plugins  {
	import soul.tween.TweenLite;
	import soul.tween.core.PropTween;

	public class TweenPlugin {
		public static const version:String = "12.0.0";
		
		public static const API:Number = 2; 
		
		public var _propName:String;
		
		public var _overwriteProps:Array;
		
		public var _priority:int = 0;
		
		protected var _firstPT:PropTween;		
		
		public function TweenPlugin(props:String="", priority:int=0) {
			_overwriteProps = props.split(",");
			_propName = _overwriteProps[0];
			_priority = priority || 0;
		}
		
		public function _onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			return false;
		}
		
		protected function _addTween(target:Object, propName:String, start:Number, end:*, overwriteProp:String=null, round:Boolean=false):void {
			var c:Number;
			if (end != null && (c = (typeof(end) === "number" || end.charAt(1) !== "=") ? Number(end) - start : int(end.charAt(0)+"1") * Number(end.substr(2)))) {
				_firstPT = new PropTween(target, propName, start, c, overwriteProp || propName, false, _firstPT);
				_firstPT.r = round;
			}
		}
		
		public function setRatio(v:Number):void {
			var pt:PropTween = _firstPT, val:Number;
			while (pt) {
				val = pt.c * v + pt.s;
				if (pt.r) {
					val = (val > 0) ? (val + 0.5) >> 0 : (val - 0.5) >> 0; //about 4x faster than Math.round()
				}
				if (pt.f) {
					pt.t[pt.p](val);
				} else {
					pt.t[pt.p] = val;
				}
				pt = pt._next;
			}
		}
		
		public function _roundProps(lookup:Object, value:Boolean=true):void {
			var pt:PropTween = _firstPT;
			while (pt) {
				if ((_propName in lookup) || (pt.n != null && pt.n.split(_propName + "_").join("") in lookup)) { //some properties that are very plugin-specific add a prefix named after the _propName plus an underscore, so we need to ignore that extra stuff here.
					pt.r = value;
				}
				pt = pt._next;
			}
		}
		
		public function _kill(lookup:Object):Boolean {
			if (_propName in lookup) {
				_overwriteProps = [];
			} else {
				var i:int = _overwriteProps.length;
				while (--i > -1) {
					if (_overwriteProps[i] in lookup) {
						_overwriteProps.splice(i, 1);
					}
				}
			}
			var pt:PropTween = _firstPT;
			while (pt) {
				if (pt.n in lookup) {
					if (pt._next) {
						pt._next._prev = pt._prev;
					}
					if (pt._prev) {
						pt._prev._next = pt._next;
						pt._prev = null;
					} else if (_firstPT == pt) {
						_firstPT = pt._next;
					}
				}
				pt = pt._next;
			}
			return false;
		}
		
		private static function _onTweenEvent(type:String, tween:TweenLite):Boolean {
			var pt:PropTween = tween._firstPT, changed:Boolean;
			if (type == "_onInitAllProps") {
				//sorts the PropTween linked list in order of priority because some plugins need to render earlier/later than others, like MotionBlurPlugin applies its effects after all x/y/alpha tweens have rendered on each frame.
				var pt2:PropTween, first:PropTween, last:PropTween, next:PropTween;
				while (pt) {
					next = pt._next;
					pt2 = first;
					while (pt2 && pt2.pr > pt.pr) {
						pt2 = pt2._next;
					}
					if ((pt._prev = pt2 ? pt2._prev : last)) {
						pt._prev._next = pt;
					} else {
						first = pt;
					}
					if ((pt._next = pt2)) {
						pt2._prev = pt;
					} else {
						last = pt;
					}
					pt = next;
				}
				pt = tween._firstPT = first;
			}
			while (pt) {
				if (pt.pg) if (type in pt.t) if (pt.t[type]()) {
					changed = true;
				}
				pt = pt._next;
			}
			return changed;
		}
		
		public static function activate(plugins:Array):Boolean {
			TweenLite._onPluginEvent = TweenPlugin._onTweenEvent;
			var i:int = plugins.length;
			while (--i > -1) {
				if (plugins[i].API == TweenPlugin.API) {
					TweenLite._plugins[(new (plugins[i] as Class)())._propName] = plugins[i];
				}
			}
			return true
		}
		
	}
}