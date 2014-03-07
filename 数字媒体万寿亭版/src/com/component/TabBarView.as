package com.component
{
	import com.rendener.TabButtonRendener;
	
	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.events.ItemEvent;
	import feathers.layout.HorizontalLayout;
	
	import flash.utils.setTimeout;
	
	import starling.display.Sprite;
	import starling.events.Event;

	/**
	 * 切换tab
	 */	
	public class TabBarView extends Sprite
	{
		public function TabBarView()
		{
			super();
		}
		private var _lineColor:uint;//线颜色
		public function set lineColor(value:uint):void
		{
			_lineColor = value;
		}
		private var _selectColor:uint;//选中颜色
		public function set selectColor(value:uint):void
		{
			_selectColor = value;
		}
		private var _defaultColor:uint = 0xFFFFFF;//默认颜色
		public function set defaultColor(value:uint):void
		{
			_defaultColor = value;
		}
		private var _fontSize:uint = 12;//字体大小
		public function set fontSize(value:uint):void
		{
			_fontSize = value;
		}
		private var _itemWidth:Number = 50;//选项宽高
		public function set itemWidth(value:Number):void
		{
			_itemWidth = value;
		}
		private var _itemHeight:Number = 25;
		public function set itemHeight(value:Number):void
		{
			_itemHeight = value;
		}
		private var _labelField:String = "label";
		public function get labelField():String
		{
			return _labelField;
		}
		public function set labelField(value:String):void
		{
			_labelField = value;
		}
		private var _selectIndex:int = 0;
		public function set selectIndex(value:int):void{
			_selectIndex = value;
		}
		public function get selectedItem():Object{
			return tabList != null && _dataProvider != null && _dataProvider.length > 0 ? 
				_dataProvider[tabList.selectedIndex] : null;
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
				setTimeout(showView,100);
//				showView();
			}
		}
		private var tabList:List;
		private function showView():void
		{
			if(tabList == null){
				createTabList();
			}
		}		
		
		private function createTabList():void
		{
			tabList = new List();
			tabList.itemRendererType = TabButtonRendener;
			var layout:HorizontalLayout = new HorizontalLayout();//布局
			layout.verticalAlign = HorizontalLayout.VERTICAL_ALIGN_JUSTIFY;
			var gap:Number = 3;
			layout.gap = 0;//gap * Vision.widthScale;
			tabList.layout = layout;
			tabList.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			tabList.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			//纵向滑动
			addChild(tabList);
			tabList.dataProvider = getDataList(_dataProvider);
			
			tabList.width = _dataProvider.length * _itemWidth;
			tabList.height = _itemHeight;
			
			tabList.addEventListener(Event.CHANGE,onChange);
			tabList.selectedIndex = _selectIndex;
		}
		
		private function onChange(e:Event):void
		{
			var ie:ItemEvent = new ItemEvent(ItemEvent.ITEM_CLICK);
			ie.selectedIndex = tabList.selectedIndex;
			ie.selectedItem = selectedItem;
			dispatchEvent(ie);
		}
		
		private function getDataList(_dataProvider:Object):ListCollection
		{
			var arr:Array = [];
			for each (var data:Object in _dataProvider) 
			{
				arr.push({label:data[_labelField],width:_itemWidth,height:_itemHeight,
					lineColor:_lineColor,selectColor:_selectColor,defaultColor:_defaultColor,
					fontSize:_fontSize});
			}
			arr[0].isFirst = true;//第一个
			arr[arr.length - 1].isLast = true;//最后一个
			return new ListCollection(arr);
		}
		
	}
}



