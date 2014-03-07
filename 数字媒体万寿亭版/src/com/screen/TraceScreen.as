package com.screen
{
	import com.core.IMember;
	import com.manager.Vision;
	import com.model.DateSource;
	import com.model.FarmDataBase;
	import com.rendener.TraceDateRendener;
	import com.component.ColumnChartView;
	import com.component.TabBarView;
	import com.vo.FoodDetailsVo;
	import com.vo.FoodVo;
	import com.vo.TraceVo;
	
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.events.ItemEvent;
	import feathers.layout.VerticalLayout;
	
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class TraceScreen extends Screen implements IMember
	{
		private var ccv:ColumnChartView;
		private var tab:TabBarView;
		private var traceDateList:List;//食物关系列表
		public static var paddingLeft:Number = 102 * Vision.widthScale;
		
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
			ccv.yField = "price";
			ccv.mesureUnit = "元";
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
			
			createList();
			
			createHeader();
		}
		private function createText(w:Number,h:Number,fontSize:Number,color:uint = 0x4d4d4d,label:String = ""):TextField{
			var labelText:TextField = new TextField(w,h,label);
			labelText.color = color;
			labelText.fontSize = fontSize;
			labelText.hAlign = HAlign.LEFT;
			labelText.vAlign = VAlign.CENTER;
			labelText.autoScale = false;
			addChild(labelText);
			return labelText;
		}
		/**
		 * 创建顶部页眉文字
		 */		
		private function createHeader():void
		{
			var baseY:Number = 430 * Vision.heightScale;
			var kindLabel:TextField = createText(200 * Vision.widthScale,50 * Vision.heightScale,
				22 * Vision.heightScale,0x4d4d4d,"菜类");
			addChild(kindLabel);
			kindLabel.x = 176 * Vision.widthScale;
			kindLabel.y = baseY;
			
			var weightLabel:TextField = createText(200 * Vision.widthScale,50 * Vision.heightScale,
				22 * Vision.heightScale,0x4d4d4d,"重量(千克)");
			addChild(weightLabel);
			weightLabel.x = 310 * Vision.widthScale;
			weightLabel.y = baseY;
			
			var priceLabel:TextField = createText(250 * Vision.widthScale,50 * Vision.heightScale,
				22 * Vision.heightScale,0x4d4d4d,"单价(元/千克)");
			addChild(priceLabel);
			priceLabel.x = 420 * Vision.widthScale;
			priceLabel.y = baseY;
			
			var totalPriceLabel:TextField = createText(200 * Vision.widthScale,50 * Vision.heightScale,
				22 * Vision.heightScale,0x4d4d4d,"总价(元)");
			addChild(totalPriceLabel);
			totalPriceLabel.x = 570 * Vision.widthScale;
			totalPriceLabel.y = baseY;
			
			var merchIdLabel:TextField = createText(200 * Vision.widthScale,50 * Vision.heightScale,
				22 * Vision.heightScale,0x4d4d4d,"商户编号");
			addChild(merchIdLabel);
			merchIdLabel.x = 690 * Vision.widthScale;
			merchIdLabel.y = baseY;
			
			var merchNameLabel:TextField = createText(200 * Vision.widthScale,50 * Vision.heightScale,
				22 * Vision.heightScale,0x4d4d4d,"商户姓名");
			addChild(merchNameLabel);
			merchNameLabel.x = 800 * Vision.widthScale;
			merchNameLabel.y = baseY;
			
			var dealDateLabel:TextField = createText(200 * Vision.widthScale,50 * Vision.heightScale,
				22 * Vision.heightScale,0x4d4d4d,"交易时间");
			addChild(dealDateLabel);
			dealDateLabel.x = 930 * Vision.widthScale;
			dealDateLabel.y = baseY;
		}
		
		private function createList():void
		{
			traceDateList = new List();
			traceDateList.itemRendererType = TraceDateRendener;
			var layout:VerticalLayout = new VerticalLayout();//布局
			layout.verticalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			var gap:Number = 15;
			layout.gap = gap * Vision.heightScale;
			traceDateList.layout = layout;
			traceDateList.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			traceDateList.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
			//纵向滑动
			addChild(traceDateList);
			
			traceDateList.width = Vision.senceWidth;
			traceDateList.height = 600 * Vision.heightScale;
			
			traceDateList.addEventListener(ItemEvent.ITEM_CLICK,onChangeItem);
		}
		
		private var selectedFood:FoodDetailsVo;//选中的食物数据
		private function onChangeItem(e:ItemEvent):void
		{
			selectedFood = e.selectedItem as FoodDetailsVo;
			showDate(selectedFood,tab.selectedItem);
		}
		
		override protected function draw():void
		{
			//			traceDateList.x = paddingLeft;
			traceDateList.y = 480 * Vision.heightScale;
		}
		
		private function clickItem(e:ItemEvent):void
		{
			if(traceDateList.dataProvider != null){
				var data:Object = e.selectedItem;
				if(selectedFood != null){
					showDate(selectedFood,data);
				}
			}
		}
		
		private function showDate(listData:FoodVo,dateData:Object):void{
			ccv.dataProvider = DateSource.queryByRange(listData.id,dateData.date);
			ccv.title = listData.name + "一" + dateData.label + "消费统计";
		}
		
		public function setRemoteParams(id:int,typeID:String):void
		{
			var tList:Vector.<TraceVo> = FarmDataBase.getDataList(id,typeID) as Vector.<TraceVo>;
			if(tList != null){
				traceDateList.dataProvider = new ListCollection(tList);
				if(tList.length > 0 && tList[0].foodList.length > 0){
					var food:FoodDetailsVo = tList[0].foodList[0];
					if(food != selectedFood){
						selectedFood = food;
						if(tab.selectedItem != null){
							showDate(selectedFood,tab.selectedItem);
							//默认显示
						}
					}
				}
			}
		}
		public function set memberData(obj:Object):void{
			
		}
	}
}