package com.model
{
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.system.LoaderContext;
	
	public class Model extends EventDispatcher
	{
		private static var _instance:Model;
		public var context:LoaderContext;
		public var serviceObject:Object;
		
		public static function getInstance():Model{
			if(_instance == null){
				_instance = new Model();
			}
			return _instance;
		}
		
	}
}