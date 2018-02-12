package  soul.tween.plugins  {
	import soul.tween.TweenLite;
	import soul.tween.core.PropTween;

	public class DirectionalRotationPlugin extends TweenPlugin {
		public static const API:Number = 2; //If the API/Framework for plugins changes in the future, this number helps determine compatibility
		protected var finals:Object;
		
		public function DirectionalRotationPlugin() {
			super("directionalRotation");
			_overwriteProps.pop();
		}
		
		override public function _onInitTween(target:Object, value:*, tween:TweenLite):Boolean {
			if (typeof(value) !== "object") {
				value = {rotation:value};
			}
			finals = {};
			var cap:Number = (value.useRadians === true) ? Math.PI * 2 : 360,
				p:String, v:Object, start:Number, end:Number, dif:Number, split:Array, type:String;
			for (p in value) {
				if (p !== "useRadians") {
					split = (value[p] + "").split("_");
					v = split[0];
					type = split[1];
					start = parseFloat( (typeof(target[p]) !== "function") ? target[p] : target[ ((p.indexOf("set") || typeof(target["get" + p.substr(3)]) !== "function") ? p : "get" + p.substr(3)) ]() );
					end = finals[p] = (typeof(v) === "string" && v.charAt(1) === "=") ? start + parseInt(v.charAt(0) + "1", 10) * Number(v.substr(2)) : Number(v) || 0;
					dif = end - start;
					if (type === "short") {
						dif = dif % cap;
						if (dif !== dif % (cap / 2)) {
							dif = (dif < 0) ? dif + cap : dif - cap;
						}
					} else if (type === "cw" && dif < 0) {
						dif = ((dif + cap * 9999999999) % cap) - ((dif / cap) | 0) * cap;
					} else if (type === "ccw" && dif > 0) {
						dif = ((dif - cap * 9999999999) % cap) - ((dif / cap) | 0) * cap;
					}
					_addTween(target, p, start, start + dif, p);
					_overwriteProps.push(p);
				}
			}
			return true;
		}
		
		override public function setRatio(v:Number):void {
			var pt:PropTween;
			if (v !== 1) {
				super.setRatio(v);
			} else {
				pt = _firstPT;
				while (pt) {
					if (pt.f) {
						pt.t[pt.p](finals[pt.p]);
					} else {
						pt.t[pt.p] = finals[pt.p];
					}
					pt = pt._next;
				}
			}
		}	

	}
}