package soul.tween{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import soul.tween.core.Animation;
	import soul.tween.core.PropTween;
	import soul.tween.core.SimpleTimeline;
	import soul.tween.easing.Ease;

	public class TweenLite extends Animation {
		
		public static const version:String = "12.0.11";
		
		public static var defaultEase:Ease = new Ease(null, null, 1, 1);
		
		public static var defaultOverwrite:String = "auto";
		
		public static var ticker:Shape = Animation.ticker;
		
		public static var _plugins:Object = {}; 
		
		public static var _onPluginEvent:Function;
		
		protected static var _tweenLookup:Dictionary = new Dictionary(false); 
		
		protected static var _reservedProps:Object = {ease:1, delay:1, overwrite:1, onComplete:1, onCompleteParams:1, onCompleteScope:1, useFrames:1, runBackwards:1, startAt:1, onUpdate:1, onUpdateParams:1, onUpdateScope:1, onStart:1, onStartParams:1, onStartScope:1, onReverseComplete:1, onReverseCompleteParams:1, onReverseCompleteScope:1, onRepeat:1, onRepeatParams:1, onRepeatScope:1, easeParams:1, yoyo:1, onCompleteListener:1, onUpdateListener:1, onStartListener:1, onReverseCompleteListener:1, onRepeatListener:1, orientToBezier:1, immediateRender:1, repeat:1, repeatDelay:1, data:1, paused:1, reversed:1};
		
		protected static var _overwriteLookup:Object;
		
		
		public var target:Object; 
		
		public var ratio:Number;
		
		public var _propLookup:Object;
		
		public var _firstPT:PropTween;
		
		protected var _targets:Array;
		
		public var _ease:Ease;
		
		protected var _easeType:int;
		
		protected var _easePower:int;
		
		protected var _siblings:Array;
		
		protected var _overwrite:int;
		
		protected var _overwrittenProps:Object;
		
		protected var _notifyPluginsOfEnabled:Boolean;
		
		protected var _startAt:TweenLite;
		
		
		public function TweenLite(target:Object, duration:Number, vars:Object) {
			super(duration, vars);
			
			if (target == null) {
				throw new Error("Cannot tween a null object. Duration: "+duration+", data: "+this.data);
			}
			
			if (!_overwriteLookup) {
				_overwriteLookup = {none:0, all:1, auto:2, concurrent:3, allOnStart:4, preexisting:5, "true":1, "false":0};
				ticker.addEventListener("enterFrame", _dumpGarbage, false, -1, true);
			}
			
			ratio = 0;
			this.target = target;
			_ease = defaultEase; //temporary - we'll replace it in _init(). We need to set it here for speed purposes so that on the first render(), it doesn't throw an error. 
			
			_overwrite = (!("overwrite" in this.vars)) ? _overwriteLookup[defaultOverwrite] : (typeof(this.vars.overwrite) === "number") ? this.vars.overwrite >> 0 : _overwriteLookup[this.vars.overwrite];
			
			if (this.target is Array && typeof(this.target[0]) === "object") {
				_targets = this.target.concat();
				_propLookup = [];
				_siblings = [];
				var i:int = _targets.length;
				while (--i > -1) {
					_siblings[i] = _register(_targets[i], this, false);
					if (_overwrite == 1) if (_siblings[i].length > 1) {
						_applyOverwrite(_targets[i], this, null, 1, _siblings[i]);
					}
				}
				
			} else {
				_propLookup = {};
				_siblings = _tweenLookup[target]
				if (_siblings == null) { //the next few lines accomplish the same thing as _siblings = _register(target, this, false) but faster and only slightly more verbose.
					_siblings = _tweenLookup[target] = [this];
				} else {
					_siblings[_siblings.length] = this;
					if (_overwrite == 1) {
						_applyOverwrite(target, this, null, 1, _siblings);
					}
				}
			}
			
			if (this.vars.immediateRender || (duration == 0 && _delay == 0 && this.vars.immediateRender != false)) {
				render(-_delay, false, true);
			}
		}
		protected function _init():void {
			var i:int, initPlugins:Boolean, pt:PropTween, p:String, copy:Object;
			if (vars.startAt) {
				vars.startAt.overwrite = 0;
				vars.startAt.immediateRender = true;
				_startAt = new TweenLite(target, 0, vars.startAt);
				if (vars.immediateRender) {
					_startAt = null; //tweens that render immediately (like most from() and fromTo() tweens) shouldn't revert when their parent timeline's playhead goes backward past the startTime because the initial render could have happened anytime and it shouldn't be directly correlated to this tween's startTime. Imagine setting up a complex animation where the beginning states of various objects are rendered immediately but the tween doesn't happen for quite some time - if we revert to the starting values as soon as the playhead goes backward past the tween's startTime, it will throw things off visually. Reversion should only happen in TimelineLite/Max instances where immediateRender was false (which is the default in the convenience methods like from()).
					if (_time === 0 && _duration !== 0) {
						return; //we skip initialization here so that overwriting doesn't occur until the tween actually begins. Otherwise, if you create several immediateRender:true tweens of the same target/properties to drop into a TimelineLite or TimelineMax, the last one created would overwrite the first ones because they didn't get placed into the timeline yet before the first render occurs and kicks in overwriting.
					}
				}
			} else if (vars.runBackwards && vars.immediateRender && _duration !== 0) {
				//from() tweens must be handled uniquely: their beginning values must be rendered but we don't want overwriting to occur yet (when time is still 0). Wait until the tween actually begins before doing all the routines like overwriting. At that time, we should render at the END of the tween to ensure that things initialize correctly (remember, from() tweens go backwards)
				if (_startAt != null) {
					_startAt.render(-1, true);
					_startAt = null;
				} else if (_time === 0) {
					copy = {};
					for (p in vars) { //copy props into a new object and skip any reserved props, otherwise onComplete or onUpdate or onStart could fire. We should, however, permit autoCSS to go through.
						if (!(p in _reservedProps)) {
							copy[p] = vars[p];
						}
					}
					copy.overwrite = 0;
					_startAt = TweenLite.to(target, 0, copy);
					return;
				}
			}
			if (vars.ease is Ease) {
				_ease = (vars.easeParams is Array) ? vars.ease.config.apply(vars.ease, vars.easeParams) : vars.ease;
			} else if (typeof(vars.ease) === "function") {
				_ease = new Ease(vars.ease, vars.easeParams);
			} else {
				_ease = defaultEase;
			}
			_easeType = _ease._type;
			_easePower = _ease._power;
			_firstPT = null;
			
			if (_targets) {
				i = _targets.length;
				while (--i > -1) {
					if ( _initProps( _targets[i], (_propLookup[i] = {}), _siblings[i], (_overwrittenProps ? _overwrittenProps[i] : null)) ) {
						initPlugins = true;
					}
				}
			} else {
				initPlugins = _initProps(target, _propLookup, _siblings, _overwrittenProps);
			}
			
			if (initPlugins) {
				_onPluginEvent("_onInitAllProps", this); //reorders the array in order of priority. Uses a static TweenPlugin method in order to minimize file size in TweenLite
			}
			if (_overwrittenProps) if (_firstPT == null) if (typeof(target) !== "function") { //if all tweening properties have been overwritten, kill the tween. If the target is a function, it's most likely a delayedCall so let it live.
				_enabled(false, false);
			}
			if (vars.runBackwards) {
				pt = _firstPT;
				while (pt) {
					pt.s += pt.c;
					pt.c = -pt.c;
					pt = pt._next;
				}
			}
			_onUpdate = vars.onUpdate;
			_initted = true;
		}
		
		protected function _initProps(target:Object, propLookup:Object, siblings:Array, overwrittenProps:Object):Boolean {
			var p:String, i:int, initPlugins:Boolean, plugin:Object, a:Array;
			if (target == null) {
				return false;
			}
			for (p in vars) {
				if (p in _reservedProps) {
					if (p === "onStartParams" || p === "onUpdateParams" || p === "onCompleteParams" || p === "onReverseCompleteParams" || p === "onRepeatParams") {
						a = vars[p];
						if (a != null) {
							i = a.length;
							while (--i > -1) {
								if (a[i] === "{self}") {
									a = vars[p] = a.concat(); //copy the array in case the user referenced the same array in multiple tweens/timelines (each {self} should be unique)
									a[i] = this;
								}
							}
						}
					}
					
				} else if ((p in _plugins) && (plugin = new _plugins[p]())._onInitTween(target, vars[p], this)) {
					_firstPT = new PropTween(plugin, "setRatio", 0, 1, p, true, _firstPT, plugin._priority);
					i = plugin._overwriteProps.length;
					while (--i > -1) {
						propLookup[plugin._overwriteProps[i]] = _firstPT;
					}
					if (plugin._priority || ("_onInitAllProps" in plugin)) {
						initPlugins = true;
					}
					if (("_onDisable" in plugin) || ("_onEnable" in plugin)) {
						_notifyPluginsOfEnabled = true;
					}
					
				} else {
					_firstPT = propLookup[p] = new PropTween(target, p, 0, 1, p, false, _firstPT);
					_firstPT.s = (!_firstPT.f) ? Number(target[p]) : target[ ((p.indexOf("set") || !("get" + p.substr(3) in target)) ? p : "get" + p.substr(3)) ]();
					_firstPT.c = (typeof(vars[p]) === "number") ? Number(vars[p]) - _firstPT.s : (typeof(vars[p]) === "string" && vars[p].charAt(1) === "=") ? int(vars[p].charAt(0)+"1") * Number(vars[p].substr(2)) : Number(vars[p]) || 0;				
				}
			}
			
			if (overwrittenProps) if (_kill(overwrittenProps, target)) { //another tween may have tried to overwrite properties of this tween before init() was called (like if two tweens start at the same time, the one created second will run first)
				return _initProps(target, propLookup, siblings, overwrittenProps);
			}
			if (_overwrite > 1) if (_firstPT != null) if (siblings.length > 1) if (_applyOverwrite(target, this, propLookup, _overwrite, siblings)) {
				_kill(propLookup, target);
				return _initProps(target, propLookup, siblings, overwrittenProps);
			}
			return initPlugins;
		}
		
		
		
		/** @private (see Animation.render() for notes) **/
		override public function render(time:Number, suppressEvents:Boolean=false, force:Boolean=false):void {
			var isComplete:Boolean, callback:String, pt:PropTween, prevTime:Number = _time;
			if (time >= _duration) {
				_totalTime = _time = _duration;
				ratio = _ease._calcEnd ? _ease.getRatio(1) : 1;
				if (!_reversed) {
					isComplete = true;
					callback = "onComplete";
				}
				if (_duration == 0) { //zero-duration tweens are tricky because we must discern the momentum/direction of time in order to determine whether the starting values should be rendered or the ending values. If the "playhead" of its timeline goes past the zero-duration tween in the forward direction or lands directly on it, the end values should be rendered, but if the timeline's "playhead" moves past it in the backward direction (from a postitive time to a negative time), the starting values must be rendered.
					if (time == 0 || _rawPrevTime < 0) if (_rawPrevTime != time) {
						force = true;
						if (_rawPrevTime > 0) {
							callback = "onReverseComplete";
							if (suppressEvents) {
								time = -1; //when a callback is placed at the VERY beginning of a timeline and it repeats (or if timeline.seek(0) is called), events are normally suppressed during those behaviors (repeat or seek()) and without adjusting the _rawPrevTime back slightly, the onComplete wouldn't get called on the next render. This only applies to zero-duration tweens/callbacks of course. 
							}
						}
					}
					_rawPrevTime = time;
				}
				
			} else if (time < 0.0000001) { //to work around occasional floating point math artifacts, round super small values to 0. 
				_totalTime = _time = 0;
				ratio = _ease._calcEnd ? _ease.getRatio(0) : 0;
				if (prevTime != 0 || (_duration == 0 && _rawPrevTime > 0)) {
					callback = "onReverseComplete";
					isComplete = _reversed;
				}
				if (time < 0) {
					_active = false;
					if (_duration == 0) { //zero-duration tweens are tricky because we must discern the momentum/direction of time in order to determine whether the starting values should be rendered or the ending values. If the "playhead" of its timeline goes past the zero-duration tween in the forward direction or lands directly on it, the end values should be rendered, but if the timeline's "playhead" moves past it in the backward direction (from a postitive time to a negative time), the starting values must be rendered.
						if (_rawPrevTime >= 0) {
							force = true;
						}
						_rawPrevTime = time;
					}
					
				} else if (!_initted) { //if we render the very beginning (time == 0) of a fromTo(), we must force the render (normal tweens wouldn't need to render at a time of 0 when the prevTime was also 0). This is also mandatory to make sure overwriting kicks in immediately.
					force = true;
				}
				
			} else {
				_totalTime = _time = time;
				if (_easeType) {
					var r:Number = time / _duration;
					if (_easeType == 1 || (_easeType == 3 && r >= 0.5)) {
						r = 1 - r;
					}
					if (_easeType == 3) {
						r *= 2;
					}
					if (_easePower == 1) {
						r *= r;
					} else if (_easePower == 2) {
						r *= r * r;
					} else if (_easePower == 3) {
						r *= r * r * r;
					} else if (_easePower == 4) {
						r *= r * r * r * r;
					}
					if (_easeType == 1) {
						ratio = 1 - r;
					} else if (_easeType == 2) {
						ratio = r;
					} else if (time / _duration < 0.5) {
						ratio = r / 2;
					} else {
						ratio = 1 - (r / 2);
					}
					
				} else {
					ratio = _ease.getRatio(time / _duration);
				}
				
			}
			
			if (_time == prevTime && !force) {
				return;
			} else if (!_initted) {
				_init();
				if (!_initted) { //immediateRender tweens typically won't initialize until the playhead advances (_time is greater than 0) in order to ensure that overwriting occurs properly.
					return;
				}
				//_ease is initially set to defaultEase, so now that init() has run, _ease is set properly and we need to recalculate the ratio. Overall this is faster than using conditional logic earlier in the method to avoid having to set ratio twice because we only init() once but renderTime() gets called VERY frequently.
				if (_time && !isComplete) {
					ratio = _ease.getRatio(_time / _duration);
				} else if (isComplete && _ease._calcEnd) {
					ratio = _ease.getRatio((_time === 0) ? 0 : 1);
				}
			}
			
			if (!_active) if (!_paused) {
				_active = true;  //so that if the user renders a tween (as opposed to the timeline rendering it), the timeline is forced to re-render and align it with the proper time/frame on the next rendering cycle. Maybe the tween already finished but the user manually re-renders it as halfway done.
			}
			if (prevTime == 0) {
				if (_startAt != null) {
					if (time >= 0) {
						_startAt.render(time, suppressEvents, force);
					} else if (!callback) {
						callback = "_dummyGS"; //if no callback is defined, use a dummy value just so that the condition at the end evaluates as true because _startAt should render AFTER the normal render loop when the time is negative. We could handle this in a more intuitive way, of course, but the render loop is the MOST important thing to optimize, so this technique allows us to avoid adding extra conditional logic in a high-frequency area.
					}
				}
				if (vars.onStart) if (_time != 0 || _duration == 0) if (!suppressEvents) {
					vars.onStart.apply(null, vars.onStartParams);
				}
			}
			
			pt = _firstPT;
			while (pt) {
				if (pt.f) {
					pt.t[pt.p](pt.c * ratio + pt.s);
				} else {
					pt.t[pt.p] = pt.c * ratio + pt.s;
				}
				pt = pt._next;
			}
			
			if (_onUpdate != null) {
				if (time < 0 && _startAt != null) {
					_startAt.render(time, suppressEvents, force); //note: for performance reasons, we tuck this conditional logic inside less traveled areas (most tweens don't have an onUpdate). We'd just have it at the end before the onComplete, but the values should be updated before any onUpdate is called, so we ALSO put it here and then if it's not called, we do so later near the onComplete.
				}
				if (!suppressEvents) {
					_onUpdate.apply(null, vars.onUpdateParams);
				}
			}
			
			if (callback) if (!_gc) { //check gc because there's a chance that kill() could be called in an onUpdate
				if (time < 0 && _startAt != null && _onUpdate == null) {
					_startAt.render(time, suppressEvents, force);
				}
				if (isComplete) {
					if (_timeline.autoRemoveChildren) {
						_enabled(false, false);
					}
					_active = false;
				}
				if (!suppressEvents) if (vars[callback]) {
					vars[callback].apply(null, vars[callback + "Params"]);
				}
			}
			
		}
		
		override public function _kill(vars:Object=null, target:Object=null):Boolean {
			if (vars === "all") {
				vars = null;
			}
			if (vars == null) if (target == null || target == this.target) {
				return _enabled(false, false);
			}
			target = target || _targets || this.target;
			var i:int, overwrittenProps:Object, p:String, pt:PropTween, propLookup:Object, changed:Boolean, killProps:Object, record:Boolean;
			if (target is Array && typeof(target[0]) === "object") {
				i = target.length;
				while (--i > -1) {
					if (_kill(vars, target[i])) {
						changed = true;
					}
				}
			} else {
				if (_targets) {
					i = _targets.length;
					while (--i > -1) {
						if (target === _targets[i]) {
							propLookup = _propLookup[i] || {};
							_overwrittenProps = _overwrittenProps || [];
							overwrittenProps = _overwrittenProps[i] = vars ? _overwrittenProps[i] || {} : "all";
							break;
						}
					}
				} else if (target !== this.target) {
					return false;
				} else {
					propLookup = _propLookup;
					overwrittenProps = _overwrittenProps = vars ? _overwrittenProps || {} : "all";
				}
				if (propLookup) {
					killProps = vars || propLookup;
					record = (vars != overwrittenProps && overwrittenProps != "all" && vars != propLookup && (vars == null || vars._tempKill != true)); //_tempKill is a super-secret way to delete a particular tweening property but NOT have it remembered as an official overwritten property (like in BezierPlugin)
					for (p in killProps) {
						pt = propLookup[p]
						if (pt != null) {
							if (pt.pg && pt.t._kill(killProps)) {
								changed = true; //some plugins need to be notified so they can perform cleanup tasks first
							}
							if (!pt.pg || pt.t._overwriteProps.length === 0) {
								if (pt._prev) {
									pt._prev._next = pt._next;
								} else if (pt == _firstPT) {
									_firstPT = pt._next;
								}
								if (pt._next) {
									pt._next._prev = pt._prev;
								}
								pt._next = pt._prev = null;
							}
							delete propLookup[p];
						}
						if (record) { 
							overwrittenProps[p] = 1;
						}
					}
					if (_firstPT == null && _initted) { //if all tweening properties are killed, kill the tween. Without this line, if there's a tween with multiple targets and then you killTweensOf() each target individually, the tween would technically still remain active and fire its onComplete even though there aren't any more properties tweening. 
						_enabled(false, false);
					}
				}
			}
			return changed;
		}
				
		override public function invalidate():* {
			if (_notifyPluginsOfEnabled) {
				_onPluginEvent("_onDisable", this);
			}
			_firstPT = null;
			_overwrittenProps = null;
			_onUpdate = null;
			_startAt = null;
			_initted = _active = _notifyPluginsOfEnabled = false;
			_propLookup = (_targets) ? {} : [];
			return this;
		}
		
		override public function _enabled(enabled:Boolean, ignoreTimeline:Boolean=false):Boolean {
			if (enabled && _gc) {
				if (_targets) {
					var i:int = _targets.length;
					while (--i > -1) {
						_siblings[i] = _register(_targets[i], this, true);
					}
				} else {
					_siblings = _register(target, this, true);
				}
			}
			super._enabled(enabled, ignoreTimeline);
			if (_notifyPluginsOfEnabled) if (_firstPT != null) {
				return _onPluginEvent(((enabled) ? "_onEnable" : "_onDisable"), this);
			} 
			return false;
		}
		
		
		public static function to(target:Object, duration:Number, vars:Object):TweenLite {
			return new TweenLite(target, duration, vars);
		}
		
		public static function from(target:Object, duration:Number, vars:Object):TweenLite {
			vars = _prepVars(vars, true);
			vars.runBackwards = true;
			return new TweenLite(target, duration, vars);
		}
		
		public static function fromTo(target:Object, duration:Number, fromVars:Object, toVars:Object):TweenLite {
			toVars = _prepVars(toVars, true);
			fromVars = _prepVars(fromVars);
			toVars.startAt = fromVars;
			toVars.immediateRender = (toVars.immediateRender != false && fromVars.immediateRender != false);
			return new TweenLite(target, duration, toVars);
		}
		
		protected static function _prepVars(vars:Object, immediateRender:Boolean=false):Object {
			if (vars._isGSVars) {
				vars = vars.vars;
			}
			if (immediateRender && !("immediateRender" in vars)) {
				vars.immediateRender = true;
			}
			return vars;
		}
		
		public static function delayedCall(delay:Number, callback:Function, params:Array=null, useFrames:Boolean=false):TweenLite {
			return new TweenLite(callback, 0, {delay:delay, onComplete:callback, onCompleteParams:params, onReverseComplete:callback, onReverseCompleteParams:params, immediateRender:false, useFrames:useFrames, overwrite:0});
		}
		
		public static function set(target:Object, vars:Object):TweenLite {
			return new TweenLite(target, 0, vars);
		}
		
		private static function _dumpGarbage(event:Event):void {
			if ((_rootFrame / 60) >> 0 === _rootFrame / 60) { //faster than !(_rootFrame % 60)
				var i:int, a:Array, tgt:Object;
				for (tgt in _tweenLookup) {
					a = _tweenLookup[tgt];
					i = a.length;
					while (--i > -1) {
						if (a[i]._gc) {
							a.splice(i, 1);
						}
					}
					if (a.length === 0) {
						delete _tweenLookup[tgt];
					}
				}
			}
		}
		
		
		
		public static function killTweensOf(target:*, vars:Object=null):void {
			var a:Array = getTweensOf(target), i:int = a.length;
			while (--i > -1) {
				TweenLite(a[i])._kill(vars, target);
			}
		}
		
		public static function killDelayedCallsTo(func:Function):void {
			killTweensOf(func);
		}
		
		public static function getTweensOf(target:*):Array {
			var i:int, a:Array, j:int, t:TweenLite;
			if (target is Array && typeof(target[0]) != "string" && typeof(target[0]) != "number") {
				i = target.length;
				a = [];
				while (--i > -1) {
					a = a.concat(getTweensOf(target[i]));
				}
				i = a.length;
				//now get rid of any duplicates (tweens of arrays of objects could cause duplicates)
				while (--i > -1) {
					t = a[i];
					j = i;
					while (--j > -1) {
						if (t === a[j]) {
							a.splice(i, 1);
						}
					}
				}
			} else {
				a = _register(target).concat();
				i = a.length;
				while (--i > -1) {
					if (a[i]._gc) {
						a.splice(i, 1);
					}
				}
			}
			return a;
		}
		
		protected static function _register(target:Object, tween:TweenLite=null, scrub:Boolean=false):Array {
			var a:Array = _tweenLookup[target], 
				i:int;
			if (a == null) {
				a = _tweenLookup[target] = [];
			}
			if (tween) {
				i = a.length;
				a[i] = tween;
				if (scrub) {
					while (--i > -1) {
						if (a[i] === tween) {
							a.splice(i, 1);
						}
					}
				}
			}
			return a;
		}
		
		protected static function _applyOverwrite(target:Object, tween:TweenLite, props:Object, mode:int, siblings:Array):Boolean {
			var i:int, changed:Boolean, curTween:TweenLite;
			if (mode == 1 || mode >= 4) {
				var l:int = siblings.length;
				for (i = 0; i < l; i++) {
					curTween = siblings[i];
					if (curTween != tween) {
						if (!curTween._gc) if (curTween._enabled(false, false)) {
							changed = true;
						}
					} else if (mode == 5) {
						break;
					}
				}
				return changed;
			}
			//NOTE: Add 0.0000000001 to overcome floating point errors that can cause the startTime to be VERY slightly off (when a tween's time() is set for example)
			var startTime:Number = tween._startTime + 0.0000000001, overlaps:Array = [], oCount:int = 0, zeroDur:Boolean = (tween._duration == 0), globalStart:Number;
			i = siblings.length;
			while (--i > -1) {
				curTween = siblings[i];
				if (curTween === tween || curTween._gc || curTween._paused) {
					//ignore
				} else if (curTween._timeline != tween._timeline) {
					globalStart = globalStart || _checkOverlap(tween, 0, zeroDur);
					if (_checkOverlap(curTween, globalStart, zeroDur) === 0) {
						overlaps[oCount++] = curTween;
					}
				} else if (curTween._startTime <= startTime) if (curTween._startTime + curTween.totalDuration() / curTween._timeScale + 0.0000000001 > startTime) if (!((zeroDur || !curTween._initted) && startTime - curTween._startTime <= 0.0000000002)) {
					overlaps[oCount++] = curTween;
				}
			}
			
			i = oCount;
			while (--i > -1) {
				curTween = overlaps[i];
				if (mode == 2) if (curTween._kill(props, target)) {
					changed = true;
				}
				if (mode !== 2 || (!curTween._firstPT && curTween._initted)) { 
					if (curTween._enabled(false, false)) { //if all property tweens have been overwritten, kill the tween.
						changed = true;
					}
				}
			}
			return changed;
		}
		
		private static function _checkOverlap(tween:Animation, reference:Number, zeroDur:Boolean):Number {
			var tl:SimpleTimeline = tween._timeline, 
				ts:Number = tl._timeScale, 
				t:Number = tween._startTime,
				min:Number = 0.0000000001;
			while (tl._timeline) {
				t += tl._startTime;
				ts *= tl._timeScale;
				if (tl._paused) {
					return -100;
				}
				tl = tl._timeline;
			}
			t /= ts;
			return (t > reference) ? t - reference : ((zeroDur && t == reference) || (!tween._initted && t - reference < 2 * min)) ? min : ((t += tween.totalDuration() / tween._timeScale / ts) > reference + min) ? 0 : t - reference - min;
		}
		
		
	}
	
}

