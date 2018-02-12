package soul.tween.core{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.getTimer;

	public class Animation {
		
		public static const version:String = "12.0.7";
		public static var ticker:Shape = new Shape();
		public static var _rootTimeline:SimpleTimeline;
		public static var _rootFramesTimeline:SimpleTimeline;
		protected static var _rootFrame:Number = -1;
		protected static var _tickEvent:Event = new Event("tick");
		
		protected var _onUpdate:Function;

		public var _delay:Number; 
		public var _rawPrevTime:Number;
		public var _active:Boolean; 
		public var _gc:Boolean; 
		public var _initted:Boolean; 
		public var _startTime:Number; 
		public var _time:Number; 
		public var _totalTime:Number; 
		public var _duration:Number; 
		public var _totalDuration:Number; 
		public var _pauseTime:Number;
		public var _timeScale:Number;
		public var _reversed:Boolean;
		public var _timeline:SimpleTimeline;
		public var _dirty:Boolean; 
		public var _paused:Boolean; 
		public var _next:Animation;
		public var _prev:Animation;
		
		public var vars:Object;
		public var timeline:SimpleTimeline;
		public var data:*; 
		
		public function Animation(duration:Number=0, vars:Object=null) {
			this.vars = vars || {};
			if (this.vars._isGSVars) {
				this.vars = this.vars.vars;
			}
			_duration = _totalDuration = duration || 0;
			_delay = Number(this.vars.delay) || 0;
			_timeScale = 1;
			_totalTime = _time = 0;
			data = this.vars.data;
			_rawPrevTime = -1;
			
			if (_rootTimeline == null) {
				if (_rootFrame == -1) {
					_rootFrame = 0;
					_rootFramesTimeline = new SimpleTimeline();
					_rootTimeline = new SimpleTimeline();
					_rootTimeline._startTime = getTimer() / 1000;
					_rootFramesTimeline._startTime = 0;
					_rootTimeline._active = _rootFramesTimeline._active = true;
					ticker.addEventListener("enterFrame", _updateRoot, false, 0, true);
				} else {
					return;
				}
			}
			
			var tl:SimpleTimeline = (this.vars.useFrames) ? _rootFramesTimeline : _rootTimeline;
			tl.add(this, tl._time);
			
			_reversed = (this.vars.reversed == true);
			if (this.vars.paused) {
				paused(true);
			}
		}
		public function play(from:*=null, suppressEvents:Boolean=true):* {
			if (arguments.length) {
				seek(from, suppressEvents);
			}
			reversed(false);
			return paused(false);
		}
		
		public function pause(atTime:*=null, suppressEvents:Boolean=true):* {
			if (arguments.length) {
				seek(atTime, suppressEvents);
			}
			return paused(true);
		}
		
		public function resume(from:*=null, suppressEvents:Boolean=true):* {
			if (arguments.length) {
				seek(from, suppressEvents);
			}
			return paused(false);
		}
		
		public function seek(time:*, suppressEvents:Boolean=true):* {
			return totalTime(Number(time), suppressEvents);
		}
		
		public function restart(includeDelay:Boolean=false, suppressEvents:Boolean=true):* {
			reversed(false);
			paused(false);
			return totalTime((includeDelay ? -_delay : 0), suppressEvents, true);
		}
		
		public function render(time:Number, suppressEvents:Boolean=false, force:Boolean=false):void {
			
		}
		
		
		public function invalidate():* {
			return this;
		}
		
		public function _enabled(enabled:Boolean, ignoreTimeline:Boolean=false):Boolean {
			_gc = !enabled; //note: it is possible for _gc to be true and timeline not to be null in situations where a parent TimelineLite/Max has completed and is removed - the developer might hold a reference to that timeline and later restart() it or something. 
			_active = Boolean(enabled && !_paused && _totalTime > 0 && _totalTime < _totalDuration);
			if (!ignoreTimeline) {
				if (enabled && timeline == null) {
					_timeline.add(this, _startTime - _delay);
				} else if (!enabled && timeline != null) {
					_timeline._remove(this, true);
				}
			}
			return false;
		}
		
		public function _kill(vars:Object=null, target:Object=null):Boolean {
			return _enabled(false, false);
		}
		
		public function kill(vars:Object=null, target:Object=null):* {
			_kill(vars, target);
			return this;
		}
		
		protected function _uncache(includeSelf:Boolean):* {
			var tween:Animation = includeSelf ? this : timeline;
			while (tween) {
				tween._dirty = true;
				tween = tween.timeline;
			}
			return this;
		}
		
		public static function _updateRoot(event:Event=null):void {
			_rootFrame++;
			_rootTimeline.render((getTimer() / 1000 - _rootTimeline._startTime) * _rootTimeline._timeScale, false, false);
			_rootFramesTimeline.render((_rootFrame - _rootFramesTimeline._startTime) * _rootFramesTimeline._timeScale, false, false);
			ticker.dispatchEvent(_tickEvent);
		}
		
		public function eventCallback(type:String, callback:Function=null, params:Array=null):* {
			if (type == null) {
				return null;
			} else if (type.substr(0,2) == "on") {
				if (arguments.length == 1) {
					return vars[type];
				}
				if (callback == null) {
					delete vars[type];
				} else {
					vars[type] = callback;
					vars[type + "Params"] = params;
					if (params) {
						var i:int = params.length;
						while (--i > -1) {
							if (params[i] == "{self}") {
								params = vars[type + "Params"] = params.concat(); //copying the array avoids situations where the same array is passed to multiple tweens/timelines and {self} doesn't correctly point to each individual instance.
								params[i] = this;
							}
						}
					}
				}
				if (type == "onUpdate") {
					_onUpdate = callback;
				}
			}
			return this;
		}
		
		public function delay(value:Number=NaN):* {
			if (!arguments.length) {
				return _delay;
			}
			if (_timeline.smoothChildTiming) {
				startTime( _startTime + value - _delay );
			}
			_delay = value;
			return this;
		}
		
		public function duration(value:Number=NaN):* {
			if (!arguments.length) {
				_dirty = false;
				return _duration;
			}
			_duration = _totalDuration = value;
			_uncache(true); //true in case it's a TweenMax or TimelineMax that has a repeat - we'll need to refresh the totalDuration. 
			if (_timeline.smoothChildTiming) if (_time > 0) if (_time < _duration) if (value != 0) {
				totalTime(_totalTime * (value / _duration), true);
			}
			return this;
		}
		
		public function totalDuration(value:Number=NaN):* {
			_dirty = false;
			return (!arguments.length) ? _totalDuration : duration(value);
		}
		
		public function time(value:Number=NaN, suppressEvents:Boolean=false):* {
			if (!arguments.length) {
				return _time;
			}
			if (_dirty) {
				totalDuration();
			}
			if (value > _duration) {
				value = _duration;
			}
			return totalTime(value, suppressEvents);
		}
		
		public function totalTime(time:Number=NaN, suppressEvents:Boolean=false, uncapped:Boolean=false):* {
			if (!arguments.length) {
				return _totalTime;
			}
			if (_timeline) {
				if (time < 0 && !uncapped) {
					time += totalDuration();
				}
				if (_timeline.smoothChildTiming) {
					if (_dirty) {
						totalDuration();
					}
					if (time > _totalDuration && !uncapped) {
						time = _totalDuration;
					}
					
					_startTime = (_paused ? _pauseTime : _timeline._time) - ((!_reversed ? time : _totalDuration - time) / _timeScale);
					if (!_timeline._dirty) { //for performance improvement. If the parent's cache is already dirty, it already took care of marking the anscestors as dirty too, so skip the function call here.
						_uncache(false);
					}
					if (!_timeline._active) {
						//in case any of the anscestors had completed but should now be enabled...
						var tl:SimpleTimeline = _timeline;
						while (tl._timeline) {
							tl.totalTime(tl._totalTime, true);
							tl = tl._timeline;
						}
					}
				}
				if (_gc) {
					_enabled(true, false);
				}
				if (_totalTime != time) {
					render(time, suppressEvents, false);
				}
			}
			return this;
		}
		
		public function startTime(value:Number=NaN):* {
			if (!arguments.length) {
				return _startTime;
			}
			if (value != _startTime) {
				_startTime = value;
				if (timeline) if (timeline._sortChildren) {
					timeline.add(this, value - _delay); //ensures that any necessary re-sequencing of Animations in the timeline occurs to make sure the rendering order is correct.
				}
			}
			return this;
		}
		
		public function timeScale(value:Number=NaN):* {
			if (!arguments.length) {
				return _timeScale;
			}
			value = value || 0.000001; //can't allow zero because it'll throw the math off
			if (_timeline && _timeline.smoothChildTiming) {
				var t:Number = (_pauseTime || _pauseTime == 0) ? _pauseTime : _timeline._totalTime;
				_startTime = t - ((t - _startTime) * _timeScale / value);
			}
			_timeScale = value;
			return _uncache(false);
		}
		
		public function reversed(value:Boolean=false):* {
			if (!arguments.length) {
				return _reversed;
			}
			if (value != _reversed) {
				_reversed = value;
				totalTime(_totalTime, true);
			}
			return this;
		}
		
		public function paused(value:Boolean=false):* {
			if (!arguments.length) {
				return _paused;
			}
			if (value != _paused) if (_timeline) {
				var raw:Number = _timeline.rawTime(),
					elapsed:Number = raw - _pauseTime;
				if (!value && _timeline.smoothChildTiming) {
					_startTime += elapsed;
					_uncache(false);
				}
				_pauseTime = value ? raw : NaN;
				_paused = value;
				_active = (!value && _totalTime > 0 && _totalTime < _totalDuration);
				if (!value && elapsed != 0 && _duration !== 0) {
					render(_totalTime, true, true);
				}
			}
			if (_gc && !value) {
				_enabled(true, false);
			}
			return this;
		}

	}
}