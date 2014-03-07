package com.rendener
{
	import com.greensock.TweenLite;
	import com.manager.Vision;
	import com.screen.TraceScreen;
	import com.vo.FoodDetailsVo;
	import com.vo.TraceVo;
	
	import feathers.controls.List;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.display.BasicItemRenderer;
	import feathers.events.ItemEvent;
	import feathers.layout.VerticalLayout;
	
	import starling.display.Quad;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class TraceDateRendener extends BasicItemRenderer
	{
		private var titleLabel:TextField;
		private var titleBack:Quad;
		override protected function initialize():void
		{
			createList();
			
			var w:Number = 940 * Vision.widthScale;
			titleBack = new Quad(w,35 * Vision.heightScale,0xe5e5e5);
			titleBack.x = TraceScreen.paddingLeft;
			addChild(titleBack);
			
			titleLabel = new TextField(250 * Vision.widthScale,100 * Vision.heightScale,"");
			titleLabel.color = 0x4d4d4d;
			titleLabel.fontSize = 30 * Vision.heightScale;
			titleLabel.hAlign = HAlign.RIGHT;
			titleLabel.bold = true;
			titleLabel.autoScale = false;
			titleLabel.x = TraceScreen.paddingLeft + w - titleLabel.width - 10 * Vision.widthScale;
			addChild(titleLabel);
			
			createBorder();
		}
		
		private function createText(w:Number,h:Number,fontSize:Number,color:uint = 0x4d4d4d,
									label:String = ""):TextField{
			var labelText:TextField = new TextField(w,h,label);
			labelText.color = color;
			labelText.fontSize = fontSize;
			labelText.hAlign = HAlign.LEFT;
			labelText.vAlign = VAlign.CENTER;
			labelText.autoScale = false;
			addChild(labelText);
			return labelText;
		}
		
		private var leftLine:Quad;
		private var topLine:Quad;
		private var bottomLine:Quad;
		private var dateBack:Quad;
		private var dateLabel:TextField;
		/**
		 * 创建左侧小边框和文字
		 */		
		private function createBorder():void
		{
			var lineStyle:int = Math.ceil(2 * Vision.heightScale);
			leftLine = new Quad(lineStyle,1,0x7e887f);
			addChild(leftLine);
			leftLine.x = TraceScreen.paddingLeft;
			leftLine.pivotX = leftLine.width / 2;
			
			topLine = new Quad(28 * Vision.widthScale,lineStyle,0x7e887f);
			addChild(topLine);
			topLine.x = TraceScreen.paddingLeft;
			topLine.pivotY = topLine.height / 2;
			
			bottomLine = new Quad(28 * Vision.widthScale,lineStyle,0x7e887f);
			addChild(bottomLine);
			bottomLine.x = TraceScreen.paddingLeft;
			bottomLine.pivotY = bottomLine.height / 2;
			
			dateBack = new Quad(100 * Vision.widthScale,50 * Vision.heightScale,0x7e887f);
			addChild(dateBack);
			dateBack.x = TraceScreen.paddingLeft - dateBack.width;
			dateBack.pivotY = dateBack.height / 2;
			
			dateLabel = createText(dateBack.width,dateBack.height,25 * Vision.heightScale,0xFFFFFF);
			addChild(dateLabel);
			dateLabel.hAlign = HAlign.CENTER;
			dateLabel.x = dateBack.x;
		}
		
		private var foodList:List;//食物列表
		private function createList():void
		{
			foodList = new List();
			foodList.itemRendererType = TraceFoodRendener;
			var layout:VerticalLayout = new VerticalLayout();//布局
			layout.verticalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			var gap:Number = 0;
			layout.gap = gap * Vision.heightScale;
			foodList.layout = layout;
			foodList.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			foodList.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			//纵向滑动
			addChild(foodList);
			
			foodList.x = TraceScreen.paddingLeft;
			foodList.width = 950 * Vision.widthScale;
//			foodList.height = (Vision.FOOD_ITEM_HEIGHT + gap) * 7 * Vision.heightScale;
			
			foodList.addEventListener(Event.CHANGE,onChange);
		}
		/**
		 * 显示选中的数据
		 */		
		private function onChange(e:Event):void
		{
			var fvo:FoodDetailsVo = foodList.selectedItem as FoodDetailsVo;
			if(fvo != null && this.owner != null){
				var ie:ItemEvent = new ItemEvent(ItemEvent.ITEM_CLICK);
				ie.selectedItem = fvo;
				this.owner.dispatchEvent(ie);
			}
		}
		
		override protected function commitData():void
		{
			if(_data is TraceVo){
				var sum:Number = 0;
				var fList:Vector.<FoodDetailsVo> = (_data as TraceVo).foodList;
				titleBack.y = bottomLine.y = leftLine.height = foodList.height = 
					fList.length * Vision.TRACE_ITEM_HEIGHT * Vision.heightScale;
				titleLabel.y = titleBack.y + titleBack.height / 2 - titleLabel.height / 2;
				dateBack.y = (bottomLine.y + topLine.y) / 2;
				dateLabel.text = (_data as TraceVo).date;
				dateLabel.y = dateBack.y - dateLabel.height / 2;
				for each (var f:FoodDetailsVo in fList) 
				{
					sum += f.weight + f.price;
				}
				titleLabel.text = "总额: " + sum.toFixed(2) + "元";
				foodList.dataProvider = new ListCollection(fList);
			}
		}
		
		public override function get height():Number{
			return foodList.height + titleBack.height;// + 20 *Math.random();
		}
		
//		public override function set index(value:int):void
//		{
//			if(this._index != value)
//			{
//				if(value == 0){
//					foodList.selectedIndex = 0;//默认选中第0
//				}else{
//					foodList.selectedIndex = -1;
//				}
////				if(this.alpha != 1)TweenLite.to(this,.3,{delay:.2 + .1 * value,alpha:1});
//			}
//		}
	}
}