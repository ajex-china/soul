﻿package soul.tween{
	import soul.tween.core.Animation;
	import soul.tween.core.SimpleTimeline;

	public class TimelineLite extends SimpleTimeline {
		public static const version:String = "12.0.11";
		protected static const _paramProps:Array = ["onStartParams","onUpdateParams","onCompleteParams","onReverseCompleteParams","onRepeatParams"];
		
		protected var _labels:Object;
		
		public function TimelineLite(vars:Object=null) {
			super(vars);
			_labels = {};
			autoRemoveChildren = (this.vars.autoRemoveChildren == true);
			smoothChildTiming = (this.vars.smoothChildTiming == true);
			_sortChildren = true;
			_onUpdate = this.vars.onUpdate;
			var i:int = _paramProps.length,
				j:int, a:Array;
			while (--i > -1) {
				if ((a = this.vars[_paramProps[i]])) {
					j = a.length;
					while (--j > -1) {
						if (a[j] === "{self}") {
							a = this.vars[_paramProps[i]] = a.concat(); //copy the array in case the user referenced the same array in multiple timelines/tweens (each {self} should be unique)
							a[j] = this;
						}
					}
				}
			}
			
			if (this.vars.tweens is Array) {
				this.add(this.vars.tweens, 0, this.vars.align || "normal", this.vars.stagger || 0);
			}
		}
		
		public function to(target:Object, duration:Number, vars:Object, position:*="+=0"):* {
			return duration ? add( new TweenLite(target, duration, vars), position) : this.set(target, vars, position);
		}
		
		public function from(target:Object, duration:Number, vars:Object, position:*="+=0"):* {
			return add( TweenLite.from(target, duration, vars), position);
		}
		
		public function fromTo(target:Object, duration:Number, fromVars:Object, toVars:Object, position:*="+=0"):* {
			return duration ? add(TweenLite.fromTo(target, duration, fromVars, toVars), position) : this.set(target, toVars, position);
		}
		
		public function staggerTo(targets:Array, duration:Number, vars:Object, stagger:Number, position:*="+=0", onCompleteAll:Function=null, onCompleteAllParams:Array=null):* {
			var tl:TimelineLite = new TimelineLite({onComplete:onCompleteAll, onCompleteParams:onCompleteAllParams});
			for (var i:int = 0; i < targets.length; i++) {
				if (vars.startAt != null) {
					vars.startAt = _copy(vars.startAt);
				}
				tl.to(targets[i], duration, _copy(vars), i * stagger);
			}
			return add(tl, position);
		}
		
		public function staggerFrom(targets:Array, duration:Number, vars:Object, stagger:Number=0, position:*="+=0", onCompleteAll:Function=null, onCompleteAllParams:Array=null):* {
			vars = _prepVars(vars);
			if (!("immediateRender" in vars)) {
				vars.immediateRender = true;
			}
			vars.runBackwards = true;
			return staggerTo(targets, duration, vars, stagger, position, onCompleteAll, onCompleteAllParams);
		}
		
		public function staggerFromTo(targets:Array, duration:Number, fromVars:Object, toVars:Object, stagger:Number=0, position:*="+=0", onCompleteAll:Function=null, onCompleteAllParams:Array=null):* {
			toVars = _prepVars(toVars);
			fromVars = _prepVars(fromVars);
			toVars.startAt = fromVars;
			toVars.immediateRender = (toVars.immediateRender != false && fromVars.immediateRender != false);
			return staggerTo(targets, duration, toVars, stagger, position, onCompleteAll, onCompleteAllParams);
		}
		
		public function call(callback:Function, params:Array=null, position:*="+=0"):* {
			return add( TweenLite.delayedCall(0, callback, params), position);
		}
		
		public function set(target:Object, vars:Object, position:*="+=0"):* {
			position = _parseTimeOrLabel(position, 0, true);
			vars = _prepVars(vars);
			if (vars.immediateRender == null) {
				vars.immediateRender = (position === _time && !_paused);
			}
			return add( new TweenLite(target, 0, vars), position);
		}
		
		protected static function _prepVars(vars:Object):Object { //to accommodate TweenLiteVars and TweenMaxVars instances for strong data typing and code hinting
			return (vars._isGSVars) ? vars.vars : vars;
		}
		
		protected static function _copy(vars:Object):Object {
			var copy:Object = {}, p:String;
			for (p in vars) {
				copy[p] = vars[p];
			}
			return copy;
		}
		
		public static function exportRoot(vars:Object=null, omitDelayedCalls:Boolean=true):TimelineLite {
			vars = vars || {};
			if (!("smoothChildTiming" in vars)) {
				vars.smoothChildTiming = true;
			}
			var tl:TimelineLite = new TimelineLite(vars),
				root:SimpleTimeline = tl._timeline;
			root._remove(tl, true);
			tl._startTime = 0;
			tl._rawPrevTime = tl._time = tl._totalTime = root._time;
			var tween:Animation = root._first, next:Animation;
			while (tween) {
				next = tween._next;
				if (!omitDelayedCalls || !(tween is TweenLite && TweenLite(tween).target == tween.vars.onComplete)) {
					tl.add(tween, tween._startTime - tween._delay);
				}
				tween = next;
			}
			root.add(tl, 0);
			return tl;
		}
		
		override public function insert(value:*, timeOrLabel:*=0):* {
			return add(value, timeOrLabel || 0);
		}
		
		override public function add(value:*, position:*="+=0", align:String="normal", stagger:Number=0):* {
			if (typeof(position) !== "number") {
				position = _parseTimeOrLabel(position, 0, true, value);
			}
			if (!(value is Animation)) {
				if (value is Array) {
					var i:int, 
						curTime:Number = Number(position), 
						l:Number = value.length, 
						child:*;
					for (i = 0; i < l; i++) {
						child = value[i];
						if (child is Array) {
							child = new TimelineLite({tweens:child});
						}
						add(child, curTime);
						if (typeof(child) === "string" || typeof(child) === "function") {
							//do nothing
						} else if (align === "sequence") {
							curTime = child._startTime + (child.totalDuration() / child._timeScale);
						} else if (align === "start") {
							child._startTime -= child.delay();
						}
						curTime += stagger;
					}
					return _uncache(true);
				} else if (typeof(value) === "string") {
					return addLabel(String(value), position);
				} else if (typeof(value) === "function") {
					value = TweenLite.delayedCall(0, value);
				} else {
					trace("Cannot add " + value + " into the TimelineLite/Max: it is neither a tween, timeline, function, nor a String.");
					return this;
				}
			}
			
			super.add(value, position);
			
			//if the timeline has already ended but the inserted tween/timeline extends the duration, we should enable this timeline again so that it renders properly.  
			if (_gc) if (!_paused) if (_time === _duration) if (_time < duration()) {
				//in case any of the anscestors had completed but should now be enabled...
				var tl:SimpleTimeline = this;
				while (tl._gc && tl._timeline) {
					if (tl._timeline.smoothChildTiming) {
						tl.totalTime(tl._totalTime, true); //also enables them
					} else {
						tl._enabled(true, false);
					}
					tl = tl._timeline;
				}
			}
			
			return this;
		}
		
		
		public function remove(value:*):* {
			if (value is Animation) {
				return _remove(value, false);
			} else if (value is Array) {
				var i:Number = value.length;
				while (--i > -1) {
					remove(value[i]);
				}
				return this;
			} else if (typeof(value) == "string") {
				return removeLabel(String(value));
			}
			return kill(null, value);
		}
		
		override public function _remove(tween:Animation, skipDisable:Boolean=false):* {
			super._remove(tween, skipDisable);
			if (_last == null) {
				_time = _totalTime = 0;
			} else if (_time > _last._startTime) {
				_time = duration();
				_totalTime = _totalDuration;
			}
			return this;
		}
		
		public function append(value:*, offsetOrLabel:*=0):* {
			return add(value, _parseTimeOrLabel(null, offsetOrLabel, true, value));
		}
		
		public function insertMultiple(tweens:Array, timeOrLabel:*=0, align:String="normal", stagger:Number=0):* {
			return add(tweens, timeOrLabel || 0, align, stagger);
		}
		
		public function appendMultiple(tweens:Array, offsetOrLabel:*=0, align:String="normal", stagger:Number=0):* {
			return add(tweens, _parseTimeOrLabel(null, offsetOrLabel, true, tweens), align, stagger);
		}
		
		public function addLabel(label:String, position:*):* {
			_labels[label] = _parseTimeOrLabel(position);
			return this;
		}
		
		public function removeLabel(label:String):* {
			delete _labels[label];
			return this;
		}
		
		public function getLabelTime(label:String):Number {
			return (label in _labels) ? Number(_labels[label]) : -1;
		}
		
		protected function _parseTimeOrLabel(timeOrLabel:*, offsetOrLabel:*=0, appendIfAbsent:Boolean=false, ignore:Object=null):Number {
			var i:int;
			//if we're about to add a tween/timeline (or an array of them) that's already a child of this timeline, we should remove it first so that it doesn't contaminate the duration().
			if (ignore is Animation && ignore.timeline === this) {
				remove(ignore);
			} else if (ignore is Array) {
				i = ignore.length;
				while (--i > -1) {
					if (ignore[i] is Animation && ignore[i].timeline === this) {
						remove(ignore[i]);
					}
				}
			}
			if (typeof(offsetOrLabel) === "string") {
				return _parseTimeOrLabel(offsetOrLabel, (appendIfAbsent && typeof(timeOrLabel) === "number" && !(offsetOrLabel in _labels)) ? timeOrLabel - duration() : 0, appendIfAbsent);
			}
			offsetOrLabel = offsetOrLabel || 0;
			if (typeof(timeOrLabel) === "string" && (isNaN(timeOrLabel) || (timeOrLabel in _labels))) { //if the string is a number like "1", check to see if there's a label with that name, otherwise interpret it as a number (absolute value).
				i = timeOrLabel.indexOf("=");
				if (i === -1) {
					if (!(timeOrLabel in _labels)) {
						return appendIfAbsent ? (_labels[timeOrLabel] = duration() + offsetOrLabel) : offsetOrLabel;
					}
					return _labels[timeOrLabel] + offsetOrLabel;
				}
				offsetOrLabel = parseInt(timeOrLabel.charAt(i-1) + "1", 10) * Number(timeOrLabel.substr(i+1));
				timeOrLabel = (i > 1) ? _parseTimeOrLabel(timeOrLabel.substr(0, i-1), 0, appendIfAbsent) : duration();
			} else if (timeOrLabel == null) {
				timeOrLabel = duration();
			}
			return Number(timeOrLabel) + offsetOrLabel;
		}
		
		override public function seek(position:*, suppressEvents:Boolean=true):* {
			return totalTime((typeof(position) === "number") ? Number(position) : _parseTimeOrLabel(position), suppressEvents);
		}
		
		public function stop():* {
			return paused(true);
		}
		
		public function gotoAndPlay(position:*, suppressEvents:Boolean=true):* {
			return play(position, suppressEvents);
		}
		
		public function gotoAndStop(position:*, suppressEvents:Boolean=true):* {
			return pause(position, suppressEvents);
		}
		
		override public function render(time:Number, suppressEvents:Boolean=false, force:Boolean=false):void {
			if (_gc) {
				_enabled(true, false);
			} else if (!_active && !_paused) {
				_active = true; 
			}
			var totalDur:Number = (!_dirty) ? _totalDuration : totalDuration(), 
				prevTime:Number = _time, 
				prevStart:Number = _startTime, 
				prevTimeScale:Number = _timeScale, 
				prevPaused:Boolean = _paused,
				tween:Animation, isComplete:Boolean, next:Animation, callback:String, internalForce:Boolean;
			if (time >= totalDur) {
				_totalTime = _time = totalDur;
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
				time = totalDur + 0.000001; //to avoid occasional floating point rounding errors in Flash - sometimes child tweens/timelines were not being fully completed (their progress might be 0.999999999999998 instead of 1 because when Flash performed _time - tween._startTime, floating point errors would return a value that was SLIGHTLY off)
				
			} else if (time < 0.0000001) { //to work around occasional floating point math artifacts, round super small values to 0. 
				_totalTime = _time = 0;
				if (prevTime != 0 || (_duration == 0 && _rawPrevTime > 0)) {
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
				time = 0; //to avoid occasional floating point rounding errors (could cause problems especially with zero-duration tweens at the very beginning of the timeline)
				
			} else {
				_totalTime = _time = _rawPrevTime = time;
			}
			
			if ((_time == prevTime || !_first) && !force && !internalForce) {
				return;
			} else if (!_initted) {
				_initted = true;
			}
			if (prevTime == 0) if (vars.onStart) if (_time != 0) if (!suppressEvents) {
				vars.onStart.apply(null, vars.onStartParams);
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
			
			if (callback) if (!_gc) if (prevStart == _startTime || prevTimeScale != _timeScale) if (_time == 0 || totalDur >= totalDuration()) { //if one of the tweens that was rendered altered this timeline's startTime (like if an onComplete reversed the timeline), it probably isn't complete. If it is, don't worry, because whatever call altered the startTime would complete if it was necessary at the new time. The only exception is the timeScale property. Also check _gc because there's a chance that kill() could be called in an onUpdate
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
		
		
		public function _hasPausedChild():Boolean {
			var tween:Animation = _first;
			while (tween) {
				if (tween._paused || ((tween is TimelineLite) && TimelineLite(tween)._hasPausedChild())) {
					return true;
				}
				tween = tween._next;
			}
			return false;
		}		
		
		public function getChildren(nested:Boolean=true, tweens:Boolean=true, timelines:Boolean=true, ignoreBeforeTime:Number=-9999999999):Array {
			var a:Array = [], 
				tween:Animation = _first, 
				cnt:int = 0;
			while (tween) {
				if (tween._startTime < ignoreBeforeTime) {
					//do nothing
				} else if (tween is TweenLite) {
					if (tweens) {
						a[cnt++] = tween;
					}
				} else {
					if (timelines) {
						a[cnt++] = tween;
					}
					if (nested) {
						a = a.concat(TimelineLite(tween).getChildren(true, tweens, timelines));
						cnt = a.length;
					}
				}
				tween = tween._next;
			}
			return a;
		}
		
		public function getTweensOf(target:Object, nested:Boolean=true):Array {
			var tweens:Array = TweenLite.getTweensOf(target), 
				i:int = tweens.length, 
				a:Array = [], 
				cnt:int = 0;
			while (--i > -1) {
				if (tweens[i].timeline == this || (nested && _contains(tweens[i]))) {
					a[cnt++] = tweens[i];
				}
			}
			return a;
		}
		
		private function _contains(tween:Animation):Boolean {
			var tl:SimpleTimeline = tween.timeline;
			while (tl) {
				if (tl == this) {
					return true;
				}
				tl = tl.timeline;
			}
			return false;
		}
		
		public function shiftChildren(amount:Number, adjustLabels:Boolean=false, ignoreBeforeTime:Number=0):* {
			var tween:Animation = _first;
			while (tween) {
				if (tween._startTime >= ignoreBeforeTime) {
					tween._startTime += amount;
				}
				tween = tween._next;
			}
			if (adjustLabels) {
				for (var p:String in _labels) {
					if (_labels[p] >= ignoreBeforeTime) {
						_labels[p] += amount;
					}
				}
			}
			_uncache(true);
			return this;
		}
		
		override public function _kill(vars:Object=null, target:Object=null):Boolean {
			if (vars == null) if (target == null) {
				return _enabled(false, false);
			}
			var tweens:Array = (target == null) ? getChildren(true, true, false) : getTweensOf(target),
				i:int = tweens.length, 
				changed:Boolean = false;
			while (--i > -1) {
				if (tweens[i]._kill(vars, target)) {
					changed = true;
				}
			}
			return changed;
		}
		
		public function clear(labels:Boolean=true):* {
			var tweens:Array = getChildren(false, true, true),
				i:int = tweens.length;
			_time = _totalTime = 0;
			while (--i > -1) {
				tweens[i]._enabled(false, false);
			}
			if (labels) {
				_labels = {};
			}
			return _uncache(true);
		}
		
		
		override public function invalidate():* {
			var tween:Animation = _first;
			while (tween) {
				tween.invalidate();
				tween = tween._next;
			}
			return this;
		}
		
		override public function _enabled(enabled:Boolean, ignoreTimeline:Boolean=false):Boolean {
			if (enabled == _gc) {
				var tween:Animation = _first;
				while (tween) {
					tween._enabled(enabled, true);
					tween = tween._next;
				}
			}
			return super._enabled(enabled, ignoreTimeline);
		}
		
		
		public function progress(value:Number=NaN):* {
			return (!arguments.length) ? _time / duration() : totalTime(duration() * value, false);
		}
		override public function duration(value:Number=NaN):* {
			if (!arguments.length) {
				if (_dirty) {
					totalDuration(); //just triggers recalculation
				}
				return _duration;
			}
			if (duration() !== 0) if (value !== 0) {
				timeScale(_duration / value);
			}
			return this;
		}
		
		override public function totalDuration(value:Number=NaN):* {
			if (!arguments.length) {
				if (_dirty) {
					var max:Number = 0,
						tween:Animation = _last,
						prevStart:Number = Infinity,
						prev:Animation, end:Number;
					while (tween) {
						prev = tween._prev; //record it here in case the tween changes position in the sequence...
						if (tween._dirty) {
							tween.totalDuration(); //could change the tween._startTime, so make sure the tween's cache is clean before analyzing it.
						}
						if (tween._startTime > prevStart && _sortChildren && !tween._paused) { //in case one of the tweens shifted out of order, it needs to be re-inserted into the correct position in the sequence
							add(tween, tween._startTime - tween._delay);
						} else {
							prevStart = tween._startTime;
						}
						if (tween._startTime < 0 && !tween._paused) { //children aren't allowed to have negative startTimes unless smoothChildTiming is true, so adjust here if one is found.
							max -= tween._startTime;
							if (_timeline.smoothChildTiming) {
								_startTime += tween._startTime / _timeScale;
							}
							shiftChildren(-tween._startTime, false, -9999999999);
							prevStart = 0;
						}
						end = tween._startTime + (tween._totalDuration / tween._timeScale);
						if (end > max) {
							max = end;
						}
						tween = prev;
					}
					_duration = _totalDuration = max;
					_dirty = false;
				}
				return _totalDuration;
			}
			if (totalDuration() != 0) if (value != 0) {
				timeScale( _totalDuration / value );
			}
			return this;
		}
		
		public function usesFrames():Boolean {
			var tl:SimpleTimeline = _timeline;
			while (tl._timeline) {
				tl = tl._timeline;
			}
			return (tl == _rootFramesTimeline);
		}
		
		override public function rawTime():Number {
			return (_paused || (_totalTime !== 0 && _totalTime !== _totalDuration)) ? _totalTime : (_timeline.rawTime() - _startTime) * _timeScale;
		}
		
		
	}
}