package soul.tween{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import soul.events.TweenEvent;
	import soul.tween.core.Animation;
	import soul.tween.easing.Ease;

	public class TimelineMax extends TimelineLite implements IEventDispatcher {
		public static const version:String = "12.0.11";
		protected static var _listenerLookup:Object = {onCompleteListener:TweenEvent.COMPLETE, onUpdateListener:TweenEvent.UPDATE, onStartListener:TweenEvent.START, onRepeatListener:TweenEvent.REPEAT, onReverseCompleteListener:TweenEvent.REVERSE_COMPLETE};
		protected static var _easeNone:Ease = new Ease(null, null, 1, 0);
		
		protected var _repeat:int;
		protected var _repeatDelay:Number;
		protected var _cycle:int = 0;
		protected var _locked:Boolean;
		protected var _dispatcher:EventDispatcher;
		protected var _hasUpdateListener:Boolean;
		
		 protected var _yoyo:Boolean;
		
		public function TimelineMax(vars:Object=null) {
			super(vars);
			_repeat = this.vars.repeat || 0;
			_repeatDelay = this.vars.repeatDelay || 0;
			_yoyo = (this.vars.yoyo == true);
			_dirty = true;
			if (this.vars.onCompleteListener || this.vars.onUpdateListener || this.vars.onStartListener || this.vars.onRepeatListener || this.vars.onReverseCompleteListener) {
				_initDispatcher();
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
		
		public function addCallback(callback:Function, position:*, params:Array=null):TimelineMax {
			return add( TweenLite.delayedCall(0, callback, params), position) as TimelineMax;
		}
		
		public function removeCallback(callback:Function, position:*=null):TimelineMax {
			if (callback != null) {
				if (position == null) {
					_kill(null, callback);
				} else {
					var a:Array = getTweensOf(callback, false),
						i:int = a.length,
						time:Number = _parseTimeOrLabel(position);
					while (--i > -1) {
						if (a[i]._startTime === time) {
							a[i]._enabled(false, false);
						}
					}
				}
			}
			return this;
		}
		
		public function tweenTo(position:*, vars:Object=null):TweenLite {
			vars = vars || {};
			var copy:Object = {ease:_easeNone, overwrite:2, useFrames:usesFrames(), immediateRender:false};
			for (var p:String in vars) {
				copy[p] = vars[p];
			}
			copy.time = _parseTimeOrLabel(position);
			var t:TweenLite = new TweenLite(this, (Math.abs(Number(copy.time) - _time) / _timeScale) || 0.001, copy);
			copy.onStart = function():void {
				t.target.paused(true);
				if (t.vars.time != t.target.time()) { //don't make the duration zero - if it's supposed to be zero, don't worry because it's already initting the tween and will complete immediately, effectively making the duration zero anyway. If we make duration zero, the tween won't run at all.
					t.duration( Math.abs( t.vars.time - t.target.time()) / t.target._timeScale );
				}
				if (vars.onStart) { //in case the user had an onStart in the vars - we don't want to overwrite it.
					vars.onStart.apply(null, vars.onStartParams);
				}
			}
			return t;
		}
		
		public function tweenFromTo(fromPosition:*, toPosition:*, vars:Object=null):TweenLite {
			vars = vars || {};
			fromPosition = _parseTimeOrLabel(fromPosition);
			vars.startAt = {onComplete:seek, onCompleteParams:[fromPosition]};
			vars.immediateRender = (vars.immediateRender !== false);
			var t:TweenLite = tweenTo(toPosition, vars);
			return t.duration((Math.abs( t.vars.time - fromPosition) / _timeScale) || 0.001) as TweenLite;
		}
		
		
		override public function render(time:Number, suppressEvents:Boolean=false, force:Boolean=false):void {
			if (_gc) {
				_enabled(true, false);
			}
			_active = !_paused;
			var totalDur:Number = (!_dirty) ? _totalDuration : totalDuration(), 
				prevTime:Number = _time, 
				prevTotalTime:Number = _totalTime, 
				prevStart:Number = _startTime, 
				prevTimeScale:Number = _timeScale, 
				prevRawPrevTime:Number = _rawPrevTime,
				prevPaused:Boolean = _paused, 
				prevCycle:int = _cycle, 
				tween:Animation, isComplete:Boolean, next:Animation, dur:Number, callback:String, internalForce:Boolean;
			if (time >= totalDur) {
				if (!_locked) {
					_totalTime = totalDur;
					_cycle = _repeat;
				}
				if (!_reversed) if (!_hasPausedChild()) {
					isComplete = true;
					callback = "onComplete";
					if (_duration == 0) if (time == 0 || _rawPrevTime < 0) if (_rawPrevTime != time && _first) { //In order to accommodate zero-duration timelines, we must discern the momentum/direction of time in order to render values properly when the "playhead" goes past 0 in the forward direction or lands directly on it, and also when it moves past it in the backward direction (from a postitive time to a negative time).
						internalForce = true;
						if (_rawPrevTime > 0) {
							callback = "onReverseComplete";
						}
					}
				}
				_rawPrevTime = time;
				if (_yoyo && (_cycle & 1) != 0) {
					_time = time = 0;
				} else {
					_time = _duration;
					time = _duration + 0.000001; //to avoid occasional floating point rounding errors in Flash - sometimes child tweens/timelines were not being fully completed (their progress might be 0.999999999999998 instead of 1 because when Flash performed _time - tween._startTime, floating point errors would return a value that was SLIGHTLY off)
				}
				
			} else if (time < 0.0000001) { //to work around occasional floating point math artifacts, round super small values to 0. 
				if (!_locked) {
					_totalTime = _cycle = 0;
				}
				_time = 0;
				if (prevTime != 0 || (_duration == 0 && _rawPrevTime > 0 && !_locked)) {
					callback = "onReverseComplete";
					isComplete = _reversed;
				}
				if (time < 0) {
					_active = false;
					if (_duration == 0) if (_rawPrevTime >= 0 && _first) { //zero-duration timelines are tricky because we must discern the momentum/direction of time in order to determine whether the starting values should be rendered or the ending values. If the "playhead" of its timeline goes past the zero-duration tween in the forward direction or lands directly on it, the end values should be rendered, but if the timeline's "playhead" moves past it in the backward direction (from a postitive time to a negative time), the starting values must be rendered.
						internalForce = true;
					}
				} else if (!_initted) {
					internalForce = true;
				}
				_rawPrevTime = time;
				time = 0;
				
			} else {
				_time = _rawPrevTime = time;
				if (!_locked) {
					_totalTime = time;
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
							time = _duration + 0.000001; //to avoid occasional floating point rounding errors in Flash - sometimes child tweens/timelines were not being fully completed (their progress might be 0.999999999999998 instead of 1 because when Flash performed _time - tween._startTime, floating point errors would return a value that was SLIGHTLY off)
						} else if (_time < 0) {
							_time = time = 0;
						} else {
							time = _time;
						}
					}
				}
			}
			
			if (_cycle != prevCycle) if (!_locked) {
				/*
				make sure children at the end/beginning of the timeline are rendered properly. If, for example, 
				a 3-second long timeline rendered at 2.9 seconds previously, and now renders at 3.2 seconds (which
				would get transated to 2.8 seconds if the timeline yoyos or 0.2 seconds if it just repeats), there
				could be a callback or a short tween that's at 2.95 or 3 seconds in which wouldn't render. So 
				we need to push the timeline to the end (and/or beginning depending on its yoyo value). Also we must
				ensure that zero-duration tweens at the very beginning or end of the TimelineMax work. 
				*/
				var backwards:Boolean = (_yoyo && (prevCycle & 1) !== 0),
					wrap:Boolean = (backwards == (_yoyo && (_cycle & 1) !== 0)),
					recTotalTime:Number = _totalTime,
					recCycle:int = _cycle,
					recRawPrevTime:Number = _rawPrevTime,
					recTime:Number = _time;
				
				_totalTime = prevCycle * _duration;
				if (_cycle < prevCycle) {
					backwards = !backwards;
				} else {
					_totalTime += _duration;
				}
				_time = prevTime; //temporarily revert _time so that render() renders the children in the correct order. Without this, tweens won't rewind correctly. We could arhictect things in a "cleaner" way by splitting out the rendering queue into a separate method but for performance reasons, we kept it all inside this method.
				
				_rawPrevTime = prevRawPrevTime;
				_cycle = prevCycle;
				_locked = true; //prevents changes to totalTime and skips repeat/yoyo behavior when we recursively call render()
				prevTime = (backwards) ? 0 : _duration;	
				render(prevTime, suppressEvents, false);
				if (!suppressEvents) if (!_gc) {
					if (vars.onRepeat) {
						vars.onRepeat.apply(null, vars.onRepeatParams);
					}
					if (_dispatcher) {
						_dispatcher.dispatchEvent(new TweenEvent(TweenEvent.REPEAT));
					}
				}
				if (wrap) {
					prevTime = (backwards) ? _duration + 0.000001 : -0.000001;
					render(prevTime, true, false);
				}
				_locked = false;
				if (_paused && !prevPaused) { //if the render() triggered callback that paused this timeline, we should abort (very rare, but possible)
					return;
				}
				_time = recTime;
				_totalTime = recTotalTime;
				_cycle = recCycle;
				_rawPrevTime = recRawPrevTime;
			}
			
			if ((_time == prevTime || !_first) && !force && !internalForce) {
				if (prevTotalTime !== _totalTime) if (_onUpdate != null) if (!suppressEvents) { //so that onUpdate fires even during the repeatDelay - as long as the totalTime changed, we should trigger onUpdate.
					_onUpdate.apply(vars.onUpdateScope || this, vars.onUpdateParams);
				}
				return;
			} else if (!_initted) {
				_initted = true;
			}
			
			if (prevTotalTime == 0) if (_totalTime != 0) if (!suppressEvents) {
				if (vars.onStart) {
					vars.onStart.apply(this, vars.onStartParams);
				}
				if (_dispatcher) {
					_dispatcher.dispatchEvent(new TweenEvent(TweenEvent.START));
				}
			}
			
			if (_time >= prevTime) {
				tween = _first;
				while (tween) {
					next = tween._next; //record it here because the value could change after rendering...
					if (_paused && !prevPaused) { //in case a tween pauses the timeline when rendering
						break;
					} else if (tween._active || (tween._startTime <= _time && !tween._paused && !tween._gc)) {
						
						if (!tween._reversed) {
							tween.render((time - tween._startTime) * tween._timeScale, suppressEvents, force);
						} else {
							tween.render(((!tween._dirty) ? tween._totalDuration : tween.totalDuration()) - ((time - tween._startTime) * tween._timeScale), suppressEvents, force);
						}
						
					}
					tween = next;
				}
			} else {
				tween = _last;
				while (tween) {
					next = tween._prev; //record it here because the value could change after rendering...
					if (_paused && !prevPaused) { //in case a tween pauses the timeline when rendering
						break;
					} else if (tween._active || (tween._startTime <= prevTime && !tween._paused && !tween._gc)) {
						
						if (!tween._reversed) {
							tween.render((time - tween._startTime) * tween._timeScale, suppressEvents, force);
						} else {
							tween.render(((!tween._dirty) ? tween._totalDuration : tween.totalDuration()) - ((time - tween._startTime) * tween._timeScale), suppressEvents, force);
						}
						
					}
					tween = next;
				}
			}
			
			if (_onUpdate != null) if (!suppressEvents) {
				_onUpdate.apply(null, vars.onUpdateParams);
			}
			if (_hasUpdateListener) if (!suppressEvents) {
				_dispatcher.dispatchEvent(new TweenEvent(TweenEvent.UPDATE));
			}
			
			if (callback) if (!_locked) if (!_gc) if (prevStart === _startTime || prevTimeScale !== _timeScale) if (_time === 0 || totalDur >= totalDuration()) { //if one of the tweens that was rendered altered this timeline's startTime (like if an onComplete reversed the timeline), it probably isn't complete. If it is, don't worry, because whatever call altered the startTime would complete if it was necessary at the new time. The only exception is the timeScale property. Also check _gc because there's a chance that kill() could be called in an onUpdate
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
		
		public function getActive(nested:Boolean=true, tweens:Boolean=true, timelines:Boolean=false):Array {
			var a:Array = [], 
				all:Array = getChildren(nested, tweens, timelines), 
				cnt:int = 0, 
				l:int = all.length,
				i:int, tween:Animation;
			for (i = 0; i < l; i++) {
				tween = all[i];
				//note: we cannot just check tween.active because timelines that contain paused children will continue to have "active" set to true even after the playhead passes their end point (technically a timeline can only be considered complete after all of its children have completed too, but paused tweens are...well...just waiting and until they're unpaused we don't know where their end point will be).
				if (!tween._paused) if (tween._timeline._time >= tween._startTime) if (tween._timeline._time < tween._startTime + tween._totalDuration / tween._timeScale) if (!_getGlobalPaused(tween._timeline)) {
					a[cnt++] = tween;
				}
			}
			return a;
		}
		
		/** @private **/
		protected static function _getGlobalPaused(tween:Animation):Boolean {
			while (tween) {
				if (tween._paused) {
					return true;
				}
				tween = tween._timeline;
			}
			return false;
		}
		
		public function getLabelAfter(time:Number=NaN):String {
			if (!time) if (time != 0) { //faster than isNan()
				time = _time;
			}
			var labels:Array = getLabelsArray(),
				l:int = labels.length,
				i:int;
			for (i = 0; i < l; i++) {
				if (labels[i].time > time) {
					return labels[i].name;
				}
			}
			return null;
		}
		
		public function getLabelBefore(time:Number=NaN):String {
			if (!time) if (time != 0) { //faster than isNan()
				time = _time;
			}
			var labels:Array = getLabelsArray(),
				i:int = labels.length;
			while (--i > -1) {
				if (labels[i].time < time) {
					return labels[i].name;
				}
			}
			return null;
		}
		
		public function getLabelsArray():Array {
			var a:Array = [],
				cnt:int = 0,
				p:String;
			for (p in _labels) {
				a[cnt++] = {time:_labels[p], name:p};
			}
			a.sortOn("time", Array.NUMERIC);
			return a;
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
		
		public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			if (_dispatcher != null) {
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
		
		
		override public function progress(value:Number=NaN):* {
			return (!arguments.length) ? _time / duration() : totalTime( duration() * ((_yoyo && (_cycle & 1) !== 0) ? 1 - value : value) + (_cycle * (_duration + _repeatDelay)), false);
		}
		
		public function totalProgress(value:Number=NaN):* {
			return (!arguments.length) ? _totalTime / totalDuration() : totalTime( totalDuration() * value, false);
		}
		
		override public function totalDuration(value:Number=NaN):* {
			if (!arguments.length) {
				if (_dirty) {
					super.totalDuration(); //just forces refresh
					//Instead of Infinity, we use 999999999999 so that we can accommodate reverses.
					_totalDuration = (_repeat == -1) ? 999999999999 : _duration * (_repeat + 1) + (_repeatDelay * _repeat);
				}
				return _totalDuration;
			}
			return (_repeat == -1) ? this : duration( (value - (_repeat * _repeatDelay)) / (_repeat + 1) );
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
		
		public function repeat(value:Number=0):* {
			if (!arguments.length) {
				return _repeat;
			}
			_repeat = value;
			return _uncache(true);
		}
		
		public function repeatDelay(value:Number=0):* {
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
		public function currentLabel(value:String=null):* {
			if (!arguments.length) {
				return getLabelBefore(_time + 0.00000001);
			}
			return seek(value, true);
		}
		
	}
}