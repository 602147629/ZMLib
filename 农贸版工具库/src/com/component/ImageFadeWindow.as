package com.component
{
	import com.greensock.TweenLite;
	import com.manager.TimerManager;
	import com.manager.Vision;
	import com.rendener.BasicItemRenderer;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class ImageFadeWindow extends Sprite
	{
		private var actualWidth:Number;
		private var actualHeight:Number;
		public function ImageFadeWindow(w:Number,h:Number)
		{
			actualWidth = w;
			actualHeight = h;//交互区域大小
		}
		
		private var _dataProvider:Object;
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		
		public function set dataProvider(value:Object):void
		{
			if(_dataProvider != value){
				_dataProvider = value;
				if(_dataProvider != null){
					changeView();
				}
			}
		}
		
		private var _delay:Number = 1000;//间隔时间 默认1秒
		public function get delay():Number
		{
			return _delay;
		}

		public function set delay(value:Number):void
		{
			_delay = value;
			changeView();
		}
		
		private var _itemRendererType:Class;
		public function get itemRendererType():Class
		{
			return _itemRendererType;
		}
		public function set itemRendererType(value:Class):void
		{
			_itemRendererType = value;
			changeView();
		}
		
		private var _selectIndex:int;//从目标选中的条目开始
		public function get selectIndex():int
		{
			return _selectIndex;
		}
		public function set selectIndex(value:int):void
		{
			_selectIndex = value;
			changeView();
		}
		
		private function changeView():void
		{
			Vision.visionStage.addEventListener(Event.ENTER_FRAME,showView);
			addEventListener(Event.ADDED_TO_STAGE,addToStage);
		}
		
		private function addToStage(e:Event):void
		{
			wait();//继续等待
			addEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
		}
		
		private function removeFromStage(e:Event):void
		{
			//从显示列表移除
			clear();
			removeEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
		}
		
		private function showView(e:Event = null):void{
			//显示区域大小
			Vision.visionStage.removeEventListener(Event.ENTER_FRAME,showView);
			createImages();
			showBack();
			clear();
			if(stage != null){//需要显示
				wait();
			}
		}
		
		private function wait():void{
			TimerManager.setTimeOut(_delay,nextPage);
		}
		
		private function clear():void{
			TimerManager.clearTimeOut(nextPage);
			TweenLite.killTweensOf(frontImage);//停止缓动
			frontImage.alpha = 0;
		}
		
		private function nextPage():void
		{
			if(++_selectIndex > _dataProvider.length - 1){
				_selectIndex = 0;
			}
			showFront();
			showBack();
			frontImage.alpha = 1;
			TweenLite.to(frontImage,.5,{alpha:0,onComplete:wait});
		}
		
		private function showFront():void{
			frontImage.index = backImage.index;
			frontImage.place = backImage.place;
			frontImage.data = backImage.data;
		}
		
		private function showBack():void
		{
			backImage.index = backImage.place = selectIndex;
			backImage.data = _dataProvider[selectIndex];
		}		
		
		private var frontImage:BasicItemRenderer;//前后图片
		private var backImage:BasicItemRenderer;
		private function createImages():void
		{
			if(backImage == null){
				backImage = new _itemRendererType();
				addChild(backImage);
			}
			if(frontImage == null){
				frontImage = new _itemRendererType();
				addChild(frontImage);
			}
		}
		
		public override function get width():Number{
			return actualWidth;
		}
		public override function get height():Number{
			return actualHeight;
		}
	}
}