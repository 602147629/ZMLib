package com.screen
{
	import com.component.ColumnChartView;
	import com.component.TabBarView;
	import com.core.IMember;
	import com.manager.Vision;
	import com.model.DateSource;
	import com.model.FarmDataBase;
	import com.rendener.FoodRendener;
	import com.vo.FoodVo;
	
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.events.ItemEvent;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class FoodScreen extends Screen implements IMember
	{
		private var ccv:ColumnChartView;
		
		private var tab:TabBarView;
		
		private var foodList:List;//食物列表
		private var tipsLabel:TextField;
		
		override protected function initialize():void
		{
			var w:Number = 1010 * Vision.widthScale;
			//			var h:Number = 484 * Vision.heightScale;
			var h:Number = 385 * Vision.heightScale;
			ccv = new ColumnChartView(w,h);
			addChild(ccv);
			ccv.y = 28 * Vision.heightScale;
			ccv.x = (Vision.senceWidth - w) / 2;
			ccv.xField = "date";
			ccv.yField = "count";
			//			ccv.dataProvider = DateSource.queryByRange(0,);
			
			tab = new TabBarView();
			addChild(tab);
			tab.lineColor = tab.selectColor = 0x666666;
			tab.dataProvider = DateSource.DATE_SOURCE;
			tab.defaultColor = 0xFFFFFF;
			var iw:Number = 75 * Vision.widthScale;
			tab.itemWidth = iw;
			tab.itemHeight = 45 * Vision.heightScale;
			tab.fontSize = 25 * Vision.heightScale;
			tab.x = ccv.x + w - 20 * Vision.widthScale - iw * DateSource.DATE_SOURCE.length;
			tab.y = ccv.y + 13 * Vision.heightScale;
			tab.addEventListener(ItemEvent.ITEM_CLICK,clickItem);
			
			tipsLabel = new TextField(450 * Vision.widthScale,70 * Vision.heightScale,"本周市场指导价");
			tipsLabel.color = 0x373f42;
			tipsLabel.fontSize = 36 * Vision.normalScale;
			tipsLabel.hAlign = HAlign.CENTER;
			tipsLabel.vAlign = VAlign.TOP;
			tipsLabel.bold = true;
			tipsLabel.x = (Vision.senceWidth - tipsLabel.width) / 2;
			tipsLabel.y = 400 * Vision.heightScale;
			addChild(tipsLabel);
			createList();
		}
		
		private static var newsCount:int = -1;
//		private static var newsGap:Number = -1;
		private function createList():void
		{
			var baseY:Number = 490 * Vision.heightScale;
			if(newsCount == -1){//开始计算gap
				var listHeight:Number = Vision.screenHeight - baseY;/* - 10 * Vision.heightScale*/;
				newsCount = listHeight / (Vision.FOOD_ITEM_HEIGHT * Vision.heightScale);
//				newsGap = (listHeight - newsCount * Vision.NORMAL_ITEM_HEIGHT * Vision.heightScale) / (newsCount - 1);
			}
			foodList = new List();
			foodList.y = baseY;
			foodList.itemRendererType = FoodRendener;
			var layout:VerticalLayout = new VerticalLayout();//布局
			layout.verticalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
//			layout.useVirtualLayout = false;
			var gap:Number = 0;//newsGap / Vision.heightScale;
			layout.gap = gap * Vision.heightScale;
			foodList.layout = layout;
			foodList.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			foodList.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
			//纵向滑动
			addChild(foodList);
			
			foodList.width = Vision.senceWidth;
			foodList.height = (Vision.FOOD_ITEM_HEIGHT + gap) * 
				newsCount * Vision.heightScale;
			
//			foodList.addEventListener(Event.CHANGE,onChange);
			foodList.addEventListener(ItemEvent.ITEM_CLICK,onChange);
		}
		
		private function onChange(e:ItemEvent):void
		{
			if(tab.selectedItem != null){
				showDate(foodList.selectedItem as FoodVo,tab.selectedItem);
			}
		}
		
//		override protected function draw():void
//		{
//			foodList.y = 490 * Vision.heightScale;
//		}
		
		private function clickItem(e:ItemEvent):void
		{
			if(foodList.dataProvider != null){
				var data:Object = e.selectedItem;
				showDate(foodList.selectedItem as FoodVo,data);
			}
		}
		
		private function showDate(listData:FoodVo,dateData:Object):void{
			if(listData == null)return;//还未定义任何数据
			if(listData.selectType == FarmDataBase.TYPE_PRICE){
				var lastLabel:String = "价格走势";
			}else{
				lastLabel = "热销程度";
			}
			ccv.dataProvider = DateSource.queryByRange(listData.id,dateData.date);
			ccv.title = listData.name + "一" + dateData.label + lastLabel;
			ccv.mesureUnit = FarmDataBase.getUnitName(listData.selectType);
		}
		
		public function setRemoteParams(id:int,typeID:String):void
		{
			var nList:Object = FarmDataBase.getDataList(id,typeID);
			if(nList is Vector.<FoodVo>){
				foodList.dataProvider = new ListCollection(nList);
				foodList.selectedIndex = 0;
			}
		}
		public function set memberData(obj:Object):void{
			
		}
	}
}