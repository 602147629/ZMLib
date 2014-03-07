package com.component
{
	import com.event.ScrollEvent;
	import com.manager.TimerManager;
	import com.manager.Vision;
	
	import flash.display.DisplayObject;
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	/**
	 * 步骤1:设置back,bar,upBtn,downBtn
	 * 步骤2:设置滚动条高度
	 * 步骤3:设置最大拖动距离
	 * 步骤4:侦听滑动事件 获取滑动位置
	 */	
	public class ScrollBar extends EventDispatcher
	{
		//起始y坐标
		private function get startY():Number{
			if(_upBtn != null){
				return _upBtn.height;
			}
			return 0;
		}
		private function get endY():Number{
			if(_downBtn != null){
				return _barHeight - _downBtn.height - _bar.height;
			}
			return _barHeight - _bar.height;
		}
		/**
		 * 滚动条恢复原位
		 */		
		public function reset():void{
			if(_bar != null){
				_bar.y = startY;
			}
		}
		private var _back:InteractiveObject;//设置背景容器
		private var _bar:InteractiveObject;//设置滚动的按钮实例
		private var _upBtn:InteractiveObject;
		private var _downBtn:InteractiveObject;
		/**
		 * @param back 滚动条背景视图
		 * @param bar 滚动条按钮
		 * @param upBtn 上下按钮
		 * @param downBtn
		 */		
		public function init(back:InteractiveObject,bar:InteractiveObject,
							 upBtn:InteractiveObject = null,
							 downBtn:InteractiveObject = null):void{
			this._back = back;
			this._bar = bar;
			this._upBtn = upBtn;
			this._downBtn = downBtn;
			open();
		}
		
		public function open():void{
			addListeners();
		}
		
		public function close():void{
			removeListeners();
		}
		
		private var _barHeight:Number;
		/**
		 * 滚动条整体高度
		 * @param value
		 */		
		public function set barHeight(value:Number):void
		{
			_barHeight = value;
			if(_back != null){
				_back.height = value;//背景高度
				if(_downBtn != null){
					_downBtn.y = value - _downBtn.height;//固定好坐标
				}
				reset();
			}
		}
		private var _dragHeight:Number;//可拖动的高度
		/**
		 * 可拖动的范围高度
		 * @param value
		 */		
		public function set dragHeight(value:Number):void{
			_dragHeight = value;
			if(_bar != null){
				_bar.height = remainHeight - value;
			}
		}
		/**
		 * 除去上下按钮剩下的距离
		 */		
		private function get remainHeight():Number{
			var h:Number = _barHeight;
			if(_upBtn != null){
				h -= _upBtn.height;
			}
			if(_downBtn != null){
				h -= _downBtn.height;
			}
			return h;
		}
//		private var dragRect:Rectangle;
		private function addListeners():void
		{
			if(_bar != null){
				_bar.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
				Vision.stage.addEventListener(MouseEvent.MOUSE_WHEEL,onWheel);
				_back.addEventListener(MouseEvent.CLICK,onBackClick);
				if(_upBtn != null){
					_upBtn.addEventListener(MouseEvent.MOUSE_DOWN,onBtnUp);
				}
				if(_downBtn != null){
					_downBtn.addEventListener(MouseEvent.MOUSE_DOWN,onBtnDown);
				}
			}
		}
		
		private function onBackClick(e:MouseEvent):void
		{
			var interH:Number = _dragHeight * .3;//拖动的高度
			if(_back.mouseY * _back.scaleY < _bar.y){
				_bar.y -= interH;
			}else{
				_bar.y += interH;
			}
			checkBar();
		}
		
		private function onBtnDown(e:MouseEvent):void
		{
			moveDown();
			TimerManager.setIntervalOut(55,moveDown);
			Vision.stage.addEventListener(MouseEvent.MOUSE_UP,stopDown);
		}
		
		private function stopDown(e:MouseEvent):void
		{
			TimerManager.clearIntervalOut(moveDown);
		}
		
		private function moveDown():void
		{
			var interH:Number = _dragHeight * .1;//拖动的高度
			_bar.y += interH;
			checkBar();
		}
		
		private function onBtnUp(e:MouseEvent):void
		{
			moveUp();
			TimerManager.setIntervalOut(55,moveUp);
			Vision.stage.addEventListener(MouseEvent.MOUSE_UP,stopUp);
		}
		
		private function moveUp():void
		{
			var interH:Number = _dragHeight * .1;//拖动的高度
			_bar.y -= interH;
			checkBar();
		}
		
		private function stopUp(e:MouseEvent):void
		{
			TimerManager.clearIntervalOut(moveUp);
		}
		
		private function removeListeners():void{
			if(_bar != null){
				_bar.removeEventListener(MouseEvent.MOUSE_DOWN,onDown);
				Vision.stage.removeEventListener(MouseEvent.MOUSE_WHEEL,onWheel);
//				Vision.stage.removeEventListener(Event.ENTER_FRAME,onMove);
				TimerManager.clearIntervalOut(onMove);
				_back.removeEventListener(MouseEvent.CLICK,onBackClick);
				if(_upBtn != null){
					_upBtn.removeEventListener(MouseEvent.MOUSE_DOWN,onBtnUp);
				}
				if(_downBtn != null){
					_downBtn.removeEventListener(MouseEvent.MOUSE_DOWN,onBtnDown);
				}
			}
		}
		
		private var barPointY:Number;
		private function onDown(e:MouseEvent):void
		{
			barPointY = _bar.mouseY;
//			Vision.stage.addEventListener(Event.ENTER_FRAME,onMove);
			TimerManager.setIntervalOut(15,onMove);
			Vision.stage.addEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		
		private function onUp(e:MouseEvent):void
		{
//			Vision.stage.removeEventListener(Event.ENTER_FRAME,onMove);
			TimerManager.clearIntervalOut(onMove);
			Vision.stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
		}
		/**
		 * 滑动的时候立即刷新目标坐标
		 * @param e
		 */		
		private function onMove(e:Event = null):void
		{
			if(_bar.parent != null){
				_bar.y = _bar.parent.mouseY - barPointY * _bar.scaleY;
			}
			checkBar();
		}
		
		private function checkBar():void
		{
			if(_bar.y < startY)_bar.y = startY;
			else if(_bar.y > endY)_bar.y = endY;
			var se:ScrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
			se.postion = getBarPos();
			dispatchEvent(se);
		}
		
		private function onWheel(e:MouseEvent):void
		{
			var interH:Number = _dragHeight * .1;//拖动的高度
			var sign:int = e.delta > 0 ? -1 : 1;
			_bar.y += sign * interH;
			checkBar();
		}
//		private var _bar:Sprite;//设置滚动的按钮实例
//		public function set bar(value:Sprite):void
//		{
//			_bar = value;
//			startY = _bar.y;
//			_bar.startDrag(false,new Rectangle(_bar.x,_bar.y,0,0));
//			var thisRect:Rectangle = _back.getBounds(null);
//			var rect:Rectangle = _bar.getBounds(null);
//			normalWidth = _bar.x + rect.x - thisRect.x;//
//			_isShowBar ? addListeners() : removeListeners();
//		}
		/**
		 * 获取到当前bar的滚动位置
		 * @return 
		 */		
		private function getBarPos():Number{
			return _bar.y - startY;
		}	
	}
}