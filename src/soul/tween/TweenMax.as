package soul.tween {	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getTimer;
	
	import soul.events.TweenEvent;
	import soul.tween.TweenLite;
	import soul.tween.core.Animation;
	import soul.tween.core.PropTween;
	import soul.tween.core.SimpleTimeline;
	import soul.tween.plugins.*;

	public class TweenMax extends TweenLite implements IEventDispatcher {
		/** @private **/
		public static const version:String = "12.0.11";
		
		TweenPlugin.activate([
			
			//ACTIVATE (OR DEACTIVATE) PLUGINS HERE...
			
			AutoAlphaPlugin,			//tweens alpha and then toggles "visible" to false if/when alpha is zero
			EndArrayPlugin,				//tweens numbers in an Array
			FramePlugin,				//tweens MovieClip frames
			RemoveTintPlugin,			//allows you to remove a tint
			TintPlugin,					//tweens tints
			VisiblePlugin,				//tweens a target's "visible" property
			VolumePlugin,				//tweens the volume of a MovieClip or SoundChannel or anything with a "soundTransform" property
			BevelFilterPlugin,			//tweens BevelFilters
			BezierPlugin,				//enables bezier tweening
			BezierThroughPlugin,		//enables bezierThrough tweening
			BlurFilterPlugin,			//tweens BlurFilters
			ColorMatrixFilterPlugin,	//tweens ColorMatrixFilters (including hue, saturation, colorize, contrast, brightness, and threshold)
			ColorTransformPlugin,		//tweens advanced color properties like exposure, brightness, tintAmount, redOffset, redMultiplier, etc.
			DropShadowFilterPlugin,		//tweens DropShadowFilters
			FrameLabelPlugin,			//tweens a MovieClip to particular label
			GlowFilterPlugin,			//tweens GlowFilters
			HexColorsPlugin,			//tweens hex colors
			RoundPropsPlugin,			//enables the roundProps special property for rounding values
			ShortRotationPlugin			//tweens rotation values in the shortest direction
			
			]);
		
		protected static var _listenerLookup:Object = {onCompleteListener:TweenEvent.COMPLETE, onUpdateListener:TweenEvent.UPDATE, onStartListener:TweenEvent.START, onRepeatListener:TweenEvent.REPEAT, onReverseCompleteListener:TweenEvent.REVERSE_COMPLETE};
		
		public static var ticker:Shape = Animation.ticker;
		
		
		public static function killTweensOf(target:*, vars:Object=null):void {
			TweenLite.killTweensOf(target, vars);
		}
		
		public static function killDelayedCallsTo(func:Function):void {
			TweenLite.killTweensOf(func);
		}
		
		public static function getTweensOf(target:*):Array {
			return TweenLite.getTweensOf(target);
		}
		
		protected var _dispatcher:EventDispatcher;
		protected var _hasUpdateListener:Boolean;
		protected var _repeat:int = 0;
		protected var _repeatDelay:Number = 0;
		protected var _cycle:int = 0;
		public var _yoyo:Boolean;
		
		public function TweenMax(target:Object, duration:Number, vars:Object) {
			super(target, duration, vars);
			_yoyo = (this.vars.yoyo == true);
			_repeat = uint(this.vars.repeat);
			_repeatDelay = this.vars.repeatDelay || 0;
			_dirty = true; //ensures that if there is any repeat, the _totalDuration will get recalculated to accurately report it.

			if (this.vars.onCompleteListener || this.vars.onUpdateListener || this.vars.onStartListener || this.vars.onRepeatListener || this.vars.onReverseCompleteListener) {
				_initDispatcher();
				if (_duration == 0) if (_delay == 0) if (this.vars.immediateRender) {
					_dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
					_dispatcher.dispatchEvent(new TweenEvent(TweenEvent.COMPLETE));
				}
			}
		}
	
		/** @inheritDoc **/
		override public function invalidate():* {
			_yoyo = Boolean(this.vars.yoyo == true);
			_repeat = this.vars.repeat || 0;
			_repeatDelay = this.vars.repeatDelay || 0;
			_hasUpdateListener = false;
			_initDispatcher();
			_uncache(true);
			return super.invalidate();
		}
		
		public function updateTo(vars:Object, resetDuration:Boolean=false):* {
			var curRatio:Number = ratio;
			if (resetDuration) if (timeline != null) if (_startTime < _timeline._time) {
				_startTime = _timeline._time;
				_uncache(false);
				if (_gc) {
					_enabled(true, false);
				} else {
					_timeline.insert(this, _startTime - _delay); //ensures that any necessary re-sequencing of Animations in the timeline occurs to make sure the rendering order is correct.
				}
			}
			for (var p:String in vars) {
				this.vars[p] = vars[p];
			}
			if (_initted) {
				if (resetDuration) {
					_initted = false;
				} else {
					if (_notifyPluginsOfEnabled) if (_firstPT != null) {
						_onPluginEvent("_onDisable", this); //in case a plugin like MotionBlur must perform some cleanup tasks
					}
					if (_time / _duration > 0.998) { //if the tween has finished (or come extremely close to finishing), we just need to rewind it to 0 and then render it again at the end which forces it to re-initialize (parsing the new vars). We allow tweens that are close to finishing (but haven't quite finished) to work this way too because otherwise, the values are so small when determining where to project the starting values that binary math issues creep in and can make the tween appear to render incorrectly when run backwards. 
						var prevTime:Number = _time;
						render(0, true, false);
						_initted = false;
						render(prevTime, true, false);
					} else if (_time > 0) {
						_initted = false;
						_init();
						var inv:Number = 1 / (1 - curRatio),
							pt:PropTween = _firstPT, endValue:Number;
						while (pt) {
							endValue = pt.s + pt.c; 
							pt.c *= inv;
							pt.s = endValue - pt.c;
							pt = pt._next;
						}
					}
				}
			}
			return this;
		}
		
		override public function render(time:Number, suppressEvents:Boolean=false, force:Boolean=false):void {
			var totalDur:Number = (!_dirty) ? _totalDuration : totalDuration(), 
				prevTime:Number = _time,
				prevTotalTime:Number = _totalTime, 
				prevCycle:Number = _cycle, 
				isComplete:Boolean, callback:String, pt:PropTween;
			if (time >= totalDur) {
				_totalTime = totalDur;
				_cycle = _repeat;
				if (_yoyo && (_cycle & 1) != 0) {
					_time = 0;
					ratio = _ease._calcEnd ? _ease.getRatio(0) : 0;
				} else {
					_time = _duration;
					ratio = _ease._calcEnd ? _ease.getRatio(1) : 1;
				}
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
				_totalTime = _time = _cycle = 0;
				ratio = _ease._calcEnd ? _ease.getRatio(0) : 0;
				if (prevTotalTime != 0 || (_duration == 0 && _rawPrevTime > 0)) {
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
				
				if (_repeat != 0) {
					var cycleDuration:Number = _duration + _repeatDelay;
					_cycle = (_totalTime / cycleDuration) >> 0; //originally _totalTime % cycleDuration but floating point errors caused problems, so I normalized it. (4 % 0.8 should be 0 but Flash reports it as 0.79999999!)
					if (_cycle !== 0) if (_cycle === _totalTime / cycleDuration) {
						_cycle--; //otherwise when rendered exactly at the end time, it will act as though it is repeating (at the beginning)
					}
					_time = _totalTime - (_cycle * cycleDuration);
					if (_yoyo) if ((_cycle & 1) != 0) {
						_time = _duration - _time;
					}
					if (_time > _duration) {
						_time = _duration;
					} else if (_time < 0) {
						_time = 0;
					}
				}
				
				if (_easeType) {
					var r:Number = _time / _duration, type:int = _easeType, pow:int = _easePower;
					if (type == 1 || (type == 3 && r >= 0.5)) {
						r = 1 - r;
					}
					if (type == 3) {
						r *= 2;
					}
					if (pow == 1) {
						r *= r;
					} else if (pow == 2) {
						r *= r * r;
					} else if (pow == 3) {
						r *= r * r * r;
					} else if (pow == 4) {
						r *= r * r * r * r;
					}
					
					if (type == 1) {
						ratio = 1 - r;
					} else if (type == 2) {
						ratio = r;
					} else if (_time / _duration < 0.5) {
						ratio = r / 2;
					} else {
						ratio = 1 - (r / 2);
					}
					
				} else {
					ratio = _ease.getRatio(_time / _duration);
				}
				
			}
			
			if (prevTime == _time && !force) {
				if (prevTotalTime !== _totalTime) if (_onUpdate != null) if (!suppressEvents) { //so that onUpdate fires even during the repeatDelay - as long as the totalTime changed, we should trigger onUpdate.
					_onUpdate.apply(vars.onUpdateScope || this, vars.onUpdateParams);
				}
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
				_active = true; //so that if the user renders a tween (as opposed to the timeline rendering it), the timeline is forced to re-render and align it with the proper time/frame on the next rendering cycle. Maybe the tween already finished but the user manually re-renders it as halfway done.
			}
			if (prevTotalTime == 0) {
				if (_startAt != null) {
					if (time >= 0) {
						_startAt.render(time, suppressEvents, force);
					} else if (!callback) {
						callback = "_dummyGS"; //if no callback is defined, use a dummy value just so that the condition at the end evaluates as true because _startAt should render AFTER the normal render loop when the time is negative. We could handle this in a more intuitive way, of course, but the render loop is the MOST important thing to optimize, so this technique allows us to avoid adding extra conditional logic in a high-frequency area.
					}
				}
				if (_totalTime != 0 || _duration == 0) if (!suppressEvents) {
					if (vars.onStart) {
						vars.onStart.apply(null, vars.onStartParams);
					}
					if (_dispatcher) {
						_dispatcher.dispatchEvent(new TweenEvent(TweenEvent.START));
					}
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
			if (_hasUpdateListener) {
				if (time < 0 && _startAt != null && _onUpdate == null) {
					_startAt.render(time, suppressEvents, force);
				}
				if (!suppressEvents) {
					_dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
				}
			}
			if (_cycle != prevCycle) if (!suppressEvents) if (!_gc) {
				if (vars.onRepeat) {
					vars.onRepeat.apply(null, vars.onRepeatParams);
				}
				if (_dispatcher) {
					_dispatcher.dispatchEvent(new TweenEvent(TweenEvent.REPEAT));
				}
			}
			if (callback) if (!_gc) { //check gc because there's a chance that kill() could be called in an onUpdate
				if (time < 0 && _startAt != null && _onUpdate == null && !_hasUpdateListener) {
					_startAt.render(time, suppressEvents, true);
				}
				if (isComplete) {
					if (_timeline.autoRemoveChildren) {
						_enabled(false, false);
					}
					_active = false;
				}
				if (!suppressEvents) {
					if (vars[callback]) {
						vars[callback].apply(null, vars[callback + "Params"]);
					}
					if (_dispatcher) {
						_dispatcher.dispatchEvent(new TweenEvent(((callback == "onComplete") ? TweenEvent.COMPLETE : TweenEvent.REVERSE_COMPLETE)));
					}
				}
			}
		}
		
		
		protected function _initDispatcher():Boolean {
			var found:Boolean = false, p:String;
			for (p in _listenerLookup) {
				if (p in vars) if (vars[p] is Function) {
					if (_dispatcher == null) {
						_dispatcher = new EventDispatcher(this);
					}
					_dispatcher.addEventListener(_listenerLookup[p], vars[p], false, 0, true);
					found = true;
				}
			}
			return found;
		}
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			if (_dispatcher == null) {
				_dispatcher = new EventDispatcher(this);
			}
			if (type == TweenEvent.UPDATE) {
				_hasUpdateListener = true;
			}
			_dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			if (_dispatcher) {
				_dispatcher.removeEventListener(type, listener, useCapture);
			}
		}
		
		public function hasEventListener(type:String):Boolean {
			return (_dispatcher == null) ? false : _dispatcher.hasEventListener(type);
		}
		
		public function willTrigger(type:String):Boolean {
			return (_dispatcher == null) ? false : _dispatcher.willTrigger(type);
		}
		
		public function dispatchEvent(event:Event):Boolean {
			return (_dispatcher == null) ? false : _dispatcher.dispatchEvent(event);
		}
		
		
		public static function to(target:Object, duration:Number, vars:Object):TweenMax {
			return new TweenMax(target, duration, vars);
		}
		
		public static function from(target:Object, duration:Number, vars:Object):TweenMax {
			vars = _prepVars(vars, true);
			vars.runBackwards = true;
			return new TweenMax(target, duration, vars);
		}
		
		public static function fromTo(target:Object, duration:Number, fromVars:Object, toVars:Object):TweenMax {
			toVars = _prepVars(toVars, false);
			fromVars = _prepVars(fromVars, false);
			toVars.startAt = fromVars;
			toVars.immediateRender = (toVars.immediateRender != false && fromVars.immediateRender != false);
			return new TweenMax(target, duration, toVars);
		}
		
		public static function staggerTo(targets:Array, duration:Number, vars:Object, stagger:Number=0, onCompleteAll:Function=null, onCompleteAllParams:Array=null):Array {
			vars = _prepVars(vars, false);
			var a:Array = [],
				l:int = targets.length,
				delay:Number = vars.delay || 0,
				copy:Object,
				i:int,
				p:String;
			for (i = 0; i < l; i++) {
				copy = {};
				for (p in vars) {
					copy[p] = vars[p];
				}
				copy.delay = delay;
				if (i == l - 1) if (onCompleteAll != null) {
					copy.onComplete = function():void {
						if (vars.onComplete) {
							vars.onComplete.apply(null, vars.onCompleteParams);
						}
						onCompleteAll.apply(null, onCompleteAllParams);
					}
				}
				a[i] = new TweenMax(targets[i], duration, copy);
				delay += stagger;
			}
			return a;
		}
		
		public static function staggerFrom(targets:Array, duration:Number, vars:Object, stagger:Number=0, onCompleteAll:Function=null, onCompleteAllParams:Array=null):Array {
			vars = _prepVars(vars, true);
			vars.runBackwards = true;
			if (vars.immediateRender != false) {
				vars.immediateRender = true;
			}
			return staggerTo(targets, duration, vars, stagger, onCompleteAll, onCompleteAllParams);
		}
		
		public static function staggerFromTo(targets:Array, duration:Number, fromVars:Object, toVars:Object, stagger:Number=0, onCompleteAll:Function=null, onCompleteAllParams:Array=null):Array {
			toVars = _prepVars(toVars, false);
			fromVars = _prepVars(fromVars, false);
			toVars.startAt = fromVars;
			toVars.immediateRender = (toVars.immediateRender != false && fromVars.immediateRender != false);
			return staggerTo(targets, duration, toVars, stagger, onCompleteAll, onCompleteAllParams);
		}
		
		public static var allTo:Function = staggerTo;
		
		public static var allFrom:Function = staggerFrom;
		
		public static var allFromTo:Function = staggerFromTo; 
		
		public static function delayedCall(delay:Number, callback:Function, params:Array=null, useFrames:Boolean=false):TweenMax {
			return new TweenMax(callback, 0, {delay:delay, onComplete:callback, onCompleteParams:params, onReverseComplete:callback, onReverseCompleteParams:params, immediateRender:false, useFrames:useFrames, overwrite:0});
		}
		
		public static function set(target:Object, vars:Object):TweenMax {
			return new TweenMax(target, 0, vars);
		}
		
		public static function isTweening(target:Object):Boolean {
			var a:Array = TweenLite.getTweensOf(target),
				i:int = a.length,
				tween:TweenLite;
			while (--i > -1) {
				tween = a[i];
				if (tween._active || (tween._startTime == tween._timeline._time && tween._timeline._active)) {
					return true;
				}
			}
			return false;
		}
		
		public static function getAllTweens(includeTimelines:Boolean=false):Array {
			var a:Array = _getChildrenOf(_rootTimeline, includeTimelines);
			return a.concat( _getChildrenOf(_rootFramesTimeline, includeTimelines) );
		}
		
		/** @private **/
		protected static function _getChildrenOf(timeline:SimpleTimeline, includeTimelines:Boolean):Array {
			if (timeline == null) {
				return [];
			}
			var a:Array = [],
				cnt:int = 0,
				tween:Animation = timeline._first;
			while (tween) {
				if (tween is TweenLite) {
					a[cnt++] = tween;
				} else {
					if (includeTimelines) {
						a[cnt++] = tween;
					}
					a = a.concat(_getChildrenOf(SimpleTimeline(tween), includeTimelines));
					cnt = a.length;
				}
				tween = tween._next;
			}
			return a;
		}
		
		public static function killAll(complete:Boolean=false, tweens:Boolean=true, delayedCalls:Boolean=true, timelines:Boolean=true):void {
			var a:Array = getAllTweens(timelines),
				l:int = a.length,
				isDC:Boolean,
				allTrue:Boolean = (tweens && delayedCalls && timelines),
				tween:Animation, i:int;
			for (i = 0; i < l; i++) {
				tween = a[i];
				if (allTrue || (tween is SimpleTimeline) || ((isDC = (TweenLite(tween).target == TweenLite(tween).vars.onComplete)) && delayedCalls) || (tweens && !isDC)) {
					if (complete) {
						tween.totalTime(tween.totalDuration());
					} else {
						tween._enabled(false, false);
					}
				}
			}
		}
		
		public static function killChildTweensOf(parent:DisplayObjectContainer, complete:Boolean=false):void {
			var a:Array = getAllTweens(false),
				curTarget:Object, curParent:DisplayObjectContainer,
				l:int = a.length, i:int;
			for (i = 0; i < l; i++) {
				curTarget = a[i].target;
				if (curTarget is DisplayObject) {
					curParent = curTarget.parent;
					while (curParent) {
						if (curParent == parent) {
							if (complete) {
								a[i].totalTime(a[i].totalDuration());
							} else {
								a[i]._enabled(false, false);
							}
						}
						curParent = curParent.parent;
					}
				}
			}
		}
		
		public static function pauseAll(tweens:Boolean=true, delayedCalls:Boolean=true, timelines:Boolean=true):void {
			_changePause(true, tweens, delayedCalls, timelines);
		}
		
		public static function resumeAll(tweens:Boolean=true, delayedCalls:Boolean=true, timelines:Boolean=true):void {
			_changePause(false, tweens, delayedCalls, timelines);
		}
		
		private static function _changePause(pause:Boolean, tweens:Boolean=true, delayedCalls:Boolean=false, timelines:Boolean=true):void {
			var a:Array = getAllTweens(timelines),
				isDC:Boolean, 
				tween:Animation,
				allTrue:Boolean = (tweens && delayedCalls && timelines),
				i:int = a.length;
			while (--i > -1) {
				tween = a[i];
				isDC = (tween is TweenLite && TweenLite(tween).target == tween.vars.onComplete);
				if (allTrue || (tween is SimpleTimeline) || (isDC && delayedCalls) || (tweens && !isDC)) {
					tween.paused(pause);
				}
			}
		}
		
	
		public function progress(value:Number=NaN):* {
			return (!arguments.length) ? _time / duration() : totalTime( duration() * ((_yoyo && (_cycle & 1) !== 0) ? 1 - value : value) + (_cycle * (_duration + _repeatDelay)), false);
		}
		
		public function totalProgress(value:Number=NaN):* {
			return (!arguments.length) ? _totalTime / totalDuration() : totalTime( totalDuration() * value, false);
		}
		
		override public function time(value:Number=NaN, suppressEvents:Boolean=false):* {
			if (!arguments.length) {
				return _time;
			}
			if (_dirty) {
				totalDuration();
			}
			if (value > _duration) {
				value = _duration;
			}
			if (_yoyo && (_cycle & 1) !== 0) {
				value = (_duration - value) + (_cycle * (_duration + _repeatDelay));
			} else if (_repeat != 0) {
				value += _cycle * (_duration + _repeatDelay);
			}
			return totalTime(value, suppressEvents);
		}
		
		override public function duration(value:Number=NaN):* {
			if (!arguments.length) {
				return this._duration; //don't set _dirty = false because there could be repeats that haven't been factored into the _totalDuration yet. Otherwise, if you create a repeated TweenMax and then immediately check its duration(), it would cache the value and the totalDuration would not be correct, thus repeats wouldn't take effect.
			}
			return super.duration(value);
		}
		
		override public function totalDuration(value:Number=NaN):* {
			if (!arguments.length) {
				if (_dirty) {
					//instead of Infinity, we use 999999999999 so that we can accommodate reverses
					_totalDuration = (_repeat == -1) ? 999999999999 : _duration * (_repeat + 1) + (_repeatDelay * _repeat);
					_dirty = false;
				}
				return _totalDuration;
			}
			return (_repeat == -1) ? this : duration( (value - (_repeat * _repeatDelay)) / (_repeat + 1) );
		}
		
		public function repeat(value:int=0):* {
			if (!arguments.length) {
				return _repeat;
			}
			_repeat = value;
			return _uncache(true);
		}
		
		public function repeatDelay(value:Number=NaN):* {
			if (!arguments.length) {
				return _repeatDelay;
			}
			_repeatDelay = value;
			return _uncache(true);
		}
		
		public function yoyo(value:Boolean=false):* {
			if (!arguments.length) {
				return _yoyo;
			}
			_yoyo = value;
			return this;
		}
		
		public static function globalTimeScale(value:Number=NaN):Number {
			if (!arguments.length) {
				return (_rootTimeline == null) ? 1 : _rootTimeline._timeScale;
			}
			value = value || 0.0001; //can't allow zero because it'll throw the math off
			if (_rootTimeline == null) {
				TweenLite.to({}, 0, {}); //forces initialization in case globalTimeScale is set before any tweens are created.
			}
			var tl:SimpleTimeline = _rootTimeline,
				t:Number = (getTimer() / 1000);
			tl._startTime = t - ((t - tl._startTime) * tl._timeScale / value);
			tl = _rootFramesTimeline;
			t = _rootFrame;
			tl._startTime = t - ((t - tl._startTime) * tl._timeScale / value);
			_rootFramesTimeline._timeScale = _rootTimeline._timeScale = value;
			return value;
		}
		
		
	}
}

