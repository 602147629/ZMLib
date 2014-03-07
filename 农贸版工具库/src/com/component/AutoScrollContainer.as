package com.component
{
	import com.layout.Layout;
	import com.manager.TimerManager;
	import com.manager.Vision;
	import com.rendener.BasicItemRenderer;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	public class AutoScrollContainer extends Sprite
	{
		private var actualWidth:Number;
		private var actualHeight:Number;
		private var markRect:Bitmap;
		public function AutoScrollContainer(w:Number,h:Number){
			super();
			//			this.width = actualWidth = w;
			//			this.height = actualHeight = h;//交互区域大小
			markRect = new Bitmap(new BitmapData(1,1));
			markRect.width = w;
			markRect.height = h;
		}
		private var _columns:int = 1;//1列
		public function set columns(value:int):void
		{
			_columns = value;
		}
		
		private var _offCount:int = 2;//偏移2个数据
		private var _rows:int;//显示的行数
		public function get rows():int
		{
			return _rows;
		}
		public function set rows(value:int):void
		{
			_rows = value;
			changeView();
		}
		
		private var _layout:String = Layout.Vertical;//默认纵向布局方式
		public function get layout():String
		{
			return _layout;
		}
		public function set layout(value:String):void
		{
			if(_layout != value){
				_layout = value;
				changeView();
			}
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
			changeView();
		}
		
		private var _vGap:Number = 0;//行间距
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
			Vision.visionStage.addEventListener(Event.ENTER_FRAME,showView);
			addEventListener(Event.ADDED_TO_STAGE,addToStage);
		}		
		
		private function showView(e:Event = null):void{
			//			this.clipRect = new Rectangle(0,0,actualWidth,actualHeight);
			//显示区域大小
			Vision.visionStage.removeEventListener(Event.ENTER_FRAME,showView);
			createRendener();
			if(stage != null){//需要显示
				move();
			}
		}
		
		private function createRendener():void
		{
			if(_dataProvider == null || _dataProvider.length == 0)return;
			clearChildren();
			if(layout == Layout.Vertical){//纵向布局方式
				createVerticalRendener();
			}else if(layout == Layout.Horizontal){
				createHorizontalRendener();
			}
		}
		//清除子实例
		private function clearChildren():void
		{
			stop();
			removeChildren();
		}
		
		private function createVerticalRendener():void
		{
			var count:int = 0;
			for (var i:int = 0; i < _rows + _offCount; i++) 
			{
				for (var j:int = 0; j < _columns; j++) 
				{
					if(_itemRendererType != null){
						var place:int = getDataPlace(_selectedIndex + count);
						var data:Object = _dataProvider[place];
						var item:BasicItemRenderer = new _itemRendererType();
						addChild(item);
						item.owner = this;
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
		
		private function createHorizontalRendener():void
		{
			var count:int = 0;
			for (var i:int = 0; i < _columns + _offCount; i++) 
			{
				for (var j:int = 0; j < _rows; j++) 
				{
					if(_itemRendererType != null){
						var place:int = getDataPlace(_selectedIndex + count);
						var data:Object = _dataProvider[place];
						var item:BasicItemRenderer = new _itemRendererType();
						addChild(item);
						item.owner = this;
						item.x = (item.width + _hGap) * i;
						item.y = (item.height + _vGap) * j;//高度还是按照j数据
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
		
		private function getDataPlace(index:int):int
		{
			if(index > _dataProvider.length - 1){//超过最大索引值
				index = index % _dataProvider.length;//减少一轮
			}
			return index;
		}
		
		private function addToStage(e:Event):void
		{
			move();
			this.parent.addChild(markRect);
			this.mask = markRect;
			markRect.x = this.x;
			markRect.y = this.y;
			//			markRect.scaleX = this.scaleX;
			//			markRect.scaleY = this.scaleY;
			addEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
		}
		
		private function removeFromStage(e:Event):void
		{
			if(markRect.parent != null){
				markRect.parent.removeChild(markRect);
			}
			stop();
		}		
		
		private function get isStop():Boolean{
			return _dataProvider == null || _rows * _columns >= _dataProvider.length;
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
				if(layout == Layout.Vertical){//纵向布局方式
					moveVerticalRendener();
				}else if(layout == Layout.Horizontal){
					moveHorizontalRendener();
				}
			}
		}
		/**
		 * 横向移动
		 */		
		private function moveHorizontalRendener():void
		{
			for (var i:int = 0; i < this.numChildren; i++) 
			{
				var item:BasicItemRenderer = getChildAt(i) as BasicItemRenderer;
				item.x -= _scrollSpeed;//开始移动
				if(item.x < -item.width + 1){
					var tCount:int = _columns + _offCount;
					item.x += (item.width + _hGap) * tCount;
					//放到最后
					var targetIndex:int = item.index + tCount * _rows;
					var place:int = getDataPlace(targetIndex);
					item.index += tCount * _rows;//自身索引值
					item.data = _dataProvider[place];//替换数据
				}
			}
		}
		/**
		 * 纵向移动
		 */		
		private function moveVerticalRendener():void
		{
			for (var i:int = 0; i < this.numChildren; i++) 
			{
				var item:BasicItemRenderer = getChildAt(i) as BasicItemRenderer;
				item.y -= _scrollSpeed;//开始移动
				if(item.y < -item.height + 1){
					var tCount:int = _rows + _offCount;
					item.y += (item.height + _vGap) * tCount;
					//放到最后
					var targetIndex:int = item.index + tCount * _columns;
					var place:int = getDataPlace(targetIndex);
					item.index += tCount * _columns;//自身索引值
					item.data = _dataProvider[place];//替换数据
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