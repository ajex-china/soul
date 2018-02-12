package soul.tween.easing{
	import soul.tween.easing.core.EasePoint;

	public class RoughEase extends Ease {
		public static var ease:RoughEase = new RoughEase();
		private static var _lookup:Object = {}; 
		private static var _count:int = 0;
		
		private var _name:String;
		private var _first:EasePoint;
		private var _prev:EasePoint;
		
		public function RoughEase(vars:*=null, ...args) {
			if (typeof(vars) !== "object" || vars == null) {
				vars = {strength:vars, points:args[0], clamp:args[1], template:args[2], taper:args[3], randomize:args[4], name:args[5]};
			}
			if (vars.name) {
				_name = vars.name;
				_lookup[vars.name] = this;
			} else {
				_name = "roughEase" + (_count++);
			}
			var taper:String = vars.taper || "none",
				a:Array = [],
				cnt:int = 0,
				points:int = int(vars.points) || 20,
				i:int = points,
				randomize:Boolean = (vars.randomize !== false),
				clamp:Boolean = (vars.clamp === true),
				template:Ease = (vars.template is Ease) ? vars.template : null,
				strength:Number = (typeof(vars.strength) === "number") ? vars.strength * 0.4 : 0.4,
				x:Number, y:Number, bump:Number, invX:Number, obj:Object;		
			while (--i > -1) {
				x = randomize ? Math.random() : (1 / points) * i;
				y = (template != null) ? template.getRatio(x) : x;
				if (taper === "none") {
					bump = strength;
				} else if (taper === "out") {
					invX = 1 - x;
					bump = invX * invX * strength;
				} else if (taper === "in") {
					bump = x * x * strength;
				} else if (x < 0.5) { 	//"both" (start)
					invX = x * 2;
					bump = invX * invX * 0.5 * strength;
				} else {				//"both" (end)
					invX = (1 - x) * 2;
					bump = invX * invX * 0.5 * strength;
				}
				if (randomize) {
					y += (Math.random() * bump) - (bump * 0.5);
				} else if (i % 2) {
					y += bump * 0.5;
				} else {
					y -= bump * 0.5;
				}
				if (clamp) {
					if (y > 1) {
						y = 1;
					} else if (y < 0) {
						y = 0;
					}
				}
				a[cnt++] = {x:x, y:y};
			}
			a.sortOn("x", Array.NUMERIC);
			
			_first = new EasePoint(1, 1, null);
			i = points;
			while (--i > -1) {
				obj = a[i];
				_first = new EasePoint(obj.x, obj.y, _first);
			}
			
			_first = _prev = new EasePoint(0, 0, (_first.time !== 0) ? _first : _first.next);
		}
		public static function create(strength:Number=1, points:uint=20, clamp:Boolean=false, templateEase:Ease=null, taper:String="none", randomize:Boolean=true, name:String=""):Ease {
			return new RoughEase(strength, points, clamp, templateEase, taper, randomize, name);
		}
		
		public static function byName(name:String):Ease {
			return _lookup[name];
		}
			
		override public function getRatio(p:Number):Number {
			var pnt:EasePoint = _prev;
			if (p > _prev.time) {
				while (pnt.next && p >= pnt.time) {
					pnt = pnt.next;
				}
				pnt = pnt.prev;
			} else {
				while (pnt.prev && p <= pnt.time) {
					pnt = pnt.prev;
				}
			}
			_prev = pnt;
			return (pnt.value + ((p - pnt.time) / pnt.gap) * pnt.change);
		}
		
		public function dispose():void {
			delete _lookup[_name];
		}
		
		public function get name():String {
			return _name;
		}
		
		public function set name(value:String):void {
			delete _lookup[_name];
			_name = value;
			_lookup[_name] = this;
		}
		
		public function config(vars:Object=null):RoughEase {
			return new RoughEase(vars);
		}

	}
}