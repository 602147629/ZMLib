package com.component
{
	import com.manager.TimerManager;
	import com.manager.Vision;
	
	import flash.geom.Rectangle;
	
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	import feathers.display.BasicItemRenderer;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class AutoScrollContainer extends ScrollContainer
	{
//		private var actualWidth:Number;
//		private var actualHeight:Number;
		public function AutoScrollContainer(w:Number,h:Number){
			super();
			this.width = actualWidth = w;
			this.height = actualHeight = h;//交互区域大小
			scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
		}
		private var _columns:int = 1;//1列
		public function set columns(value:int):void
		{
			_columns = value;
		}
		
		private var _offCount:int = 2;//偏移2个数据
		private var _maxRows:int;//最多显示的条目数
		public function get maxRows():int
		{
			return _maxRows;
		}
		public function set maxRows(value:int):void
		{
			_maxRows = value;
			changeView();
		}
		
		private var _autoFill:Boolean;//自动补全
		public function set autoFill(value:Boolean):void
		{
			_autoFill = value;
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
		private var _hGap:Number = 0;//列间距
		public function get hGap():Number
		{
			return _hGap;
		}
		
		public function set hGap(value:Number):void
		{
			_hGap = value;
		}
		
		private var _vGap:Number;//间距
		public function get vGap():Number
		{
			return _vGap;
		}
		public function set vGap(value:Number):void
		{
			_vGap = value;
			changeView();
		}
		
		private var _selectedIndex:int;
		public function set selectedIndex(value:int):void
		{
			_selectedIndex = value;
			changeView();
		}
		
		private var _dataProvider:Object;
		public function get dataProvider():Object
		{
			return _dataProvider;
		}
		
		private var _scrollSpeed:Number = 1;//卷动速度
		public function set scrollSpeed(value:Number):void
		{
			_scrollSpeed = value;
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
		
		private function changeView():void
		{
			Vision.staringStage.addEventListener(starling.events.Event.ENTER_FRAME,showView);
			addEventListener(Event.ADDED_TO_STAGE,addToStage);
		}		
		
		private function showView(e:Event = null):void{
//			this.clipRect = new Rectangle(0,0,actualWidth,actualHeight);
			//显示区域大小
			Vision.staringStage.removeEventListener(starling.events.Event.ENTER_FRAME,showView);
			createRendener();
			if(stage != null){//需要显示
				move();
			}
		}
			
		private function createRendener():void
		{
			if(_dataProvider == null || _dataProvider.length == 0)return;
			var count:int = 0;
			for (var i:int = 0; i < _maxRows + _offCount; i++) 
			{
				for (var j:int = 0; j < _columns; j++) 
				{
					if(_itemRendererType != null){
						var place:int = getDataPlace(_selectedIndex + count);
						var data:Object = _dataProvider[place];
						var item:BasicItemRenderer = new _itemRendererType();
						addChild(item);
						item.x = (item.width + _hGap) * j;
						item.y = (item.height + _vGap) * i;//高度还是按照i数据
						item.place = place;
						item.index = count;//自身索引值
						item.data = data;
					}
					if(!_autoFill && isStop && count == _dataProvider.length - 1){
						return;//不需要滚动内容不用填满
					}
					++count;
				}
			}
		}
		
		private function getDataPlace(place:int):int
		{
			if(place > _dataProvider.length - 1){//超过最大索引值
				place = place % _dataProvider.length;//减少一轮
			}
			return place;
		}
		
		private function addToStage(e:Event):void
		{
			move();
			addEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
		}
		
		private function removeFromStage(e:Event):void
		{
			stop();
		}		
		
		private function get isStop():Boolean{
			return _dataProvider == null || _maxRows * _columns >= _dataProvider.length;
		}
		
		private function move():void{
			if(!isStop){//不需要移动
				TimerManager.setIntervalOut(20,moveRendener);
//				Vision.staringStage.addEventListener(starling.events.Event.ENTER_FRAME,moveRendener);
			}
		}
		
		private function moveRendener(e:Event = null):void
		{
			if(_dataProvider != null && _dataProvider.length > 0 && this.numChildren > 0){
				for (var i:int = 0; i < this.numChildren; i++) 
				{
					var item:BasicItemRenderer = getChildAt(i) as BasicItemRenderer;
					item.y -= _scrollSpeed;//开始移动
					if(item.y < -item.height + 1){
						var tCount:int = _maxRows + _offCount;
						item.y += (item.height + _vGap) * tCount;
						//放到最后
						var targetPlace:int = item.place + tCount * _columns;
						var place:int = getDataPlace(targetPlace);
						item.place = place;
						item.index += tCount * _columns;//自身索引值
						item.data = _dataProvider[place];//替换数据
					}
				}
			}
		}
		
		public function stop():void
		{
//			Vision.staringStage.removeEventListener(starling.events.Event.ENTER_FRAME,moveRendener);
			TimerManager.clearIntervalOut(moveRendener);
		}
		
		public override function get width():Number{
			return actualWidth;
		}
		public override function get height():Number{
			return actualHeight;
		}
		
		
		
	}
}