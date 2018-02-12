package com.view
{
	import com.model.Model;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import soul.display.BaseSprite;
	import soul.manager.ResourceManager;
	import soul.tween.TweenLite;
	
	public class BaseView extends BaseSprite implements IView
	{
		protected var resource:ResourceManager = ResourceManager.getInstance();
		protected var model:Model = Model.getInstance();
		private var _isResize:Boolean = true;
		
		public static const SHOW_COMPLETE:String="showComplete";
		public static const HIDE_COMPLETE:String="hideComplete";
		protected var showCompleteFunction:Function;
		protected var hideCompleteFunction:Function;
		protected var showParameterList:Array;
		protected var hideParameterList:Array;
		public function BaseView()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,addStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE,removeStageHandler);
		}
		private function addStageHandler(e:Event):void
		{
			addStage();
		}
		private function removeStageHandler(e:Event):void
		{
			removeStage();
		}
		protected function addStage():void
		{
			if(_isResize) 
			{
				stage.addEventListener(Event.RESIZE,resizeHandler);
				resize();
			}
		}
		protected function removeStage():void
		{
			stage.removeEventListener(Event.RESIZE,resizeHandler);
		}
		override public function destory():void
		{
			resource = null;
			model = null;
		}
		private function resizeHandler(e:Event):void
		{
			resize();
		}
		public function resize():void
		{
			
		}
		public function show(completeFunction:Function = null,parameterList:Array = null):void
		{
			showCompleteFunction = completeFunction;
			showParameterList = parameterList;
			this.alpha = 0;
			TweenLite.to(this,1,{alpha:1,onComplete:completeFunction,onCompleteParams:parameterList})
		}
		public function hide(completeFunction:Function = null,parameterList:Array = null):void
		{
			hideCompleteFunction = completeFunction;
			hideParameterList = parameterList;
			this.alpha = 1;
			TweenLite.to(this,1,{alpha:0,onComplete:completeFunction,onCompleteParams:parameterList});
		}
	}
}