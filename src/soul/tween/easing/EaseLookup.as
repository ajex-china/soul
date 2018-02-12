package soul.tween.easing{
	public class EaseLookup {
		private static var _lookup:Object;
		
		public static function find(name:String):Ease {
			if (_lookup == null) {
				_lookup = {};
				
				_addInOut(Back, ["back"]);
				_addInOut(Bounce, ["bounce"]);
				_addInOut(Circ, ["circ", "circular"]);
				_addInOut(Cubic, ["cubic","power2"]);
				_addInOut(Elastic, ["elastic"]);
				_addInOut(Expo, ["expo", "exponential"]);
				_addInOut(Power0, ["linear","power0"]);
				_addInOut(Quad, ["quad", "quadratic","power1"]);
				_addInOut(Quart, ["quart","quartic","power3"]);
				_addInOut(Quint, ["quint", "quintic", "strong","power4"]);
				_addInOut(Sine, ["sine"]);
				
				_lookup["linear.easenone"] = _lookup["lineareasenone"] = Linear.easeNone;
				_lookup.slowmo = _lookup["slowmo.ease"] = SlowMo.ease;
			}
			return _lookup[name.toLowerCase()];
		}
		
		/** @private **/
		private static function _addInOut(easeClass:Class, names:Array):void {
			var name:String, i:int = names.length;
			while (--i > -1) {
				name = names[i].toLowerCase();
				_lookup[name + ".easein"] = _lookup[name + "easein"] = easeClass.easeIn;
				_lookup[name + ".easeout"] = _lookup[name + "easeout"] = easeClass.easeOut;
				_lookup[name + ".easeinout"] = _lookup[name + "easeinout"] = easeClass.easeInOut;
			}
		}
		
	}
}