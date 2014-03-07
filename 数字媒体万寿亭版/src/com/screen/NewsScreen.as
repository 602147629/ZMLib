package com.screen
{
	import com.component.ImageFadeView;
	import com.core.IMember;
	import com.manager.Vision;
	import com.model.FarmDataBase;
	import com.rendener.NormalItemRendener;
	import com.vo.NormalItemVo;
	
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.events.ItemEvent;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;
	
	public class NewsScreen extends Screen implements IMember
	{
		private var newsList:List;//新闻列表
		private var imageFade:ImageFadeView;
		override protected function initialize():void
		{
			createList();
			
			imageFade = new ImageFadeView(Vision.IMAGE_FADE_WIDTH * Vision.widthScale,
				400 * Vision.heightScale);
			addChild(imageFade);
			imageFade.dragEnabled = true;
			imageFade.x = (Vision.senceWidth - imageFade.width) / 2;//横向居中
			imageFade.y = 30 * Vision.heightScale;
		}
		
		private static var newsGap:Number = -1;
		private static var newsCount:int = -1;
		private function createList():void
		{
			var baseY:Number = 450 * Vision.heightScale;
			if(newsGap == -1){//开始计算gap
				var listHeight:Number = Vision.screenHeight - baseY - 80 * Vision.heightScale;
				newsCount = listHeight / (Vision.NORMAL_ITEM_HEIGHT * Vision.heightScale);
				newsGap = (listHeight - newsCount * Vision.NORMAL_ITEM_HEIGHT * Vision.heightScale) / (newsCount - 1);
			}
			newsList = new List();
			newsList.y = baseY;
			newsList.itemRendererType = NormalItemRendener;
			var layout:VerticalLayout = new VerticalLayout();//布局
			layout.verticalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			var gap:Number = newsGap / Vision.heightScale;
			layout.gap = gap * Vision.heightScale;
			newsList.layout = layout;
			newsList.scrollerProperties.horizontalScrollPolicy = Scroller.SCROLL_POLICY_OFF;
			newsList.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_AUTO;
			//纵向滑动
			addChild(newsList);
			
			newsList.width = Vision.senceWidth;
			newsList.height = (Vision.NORMAL_ITEM_HEIGHT + gap * (newsCount - 1) / newsCount + 1) * 
				newsCount * Vision.heightScale;
		}
		
//		override protected function draw():void
//		{
//			newsList.y = 450 * Vision.heightScale;
//		}
		/**
		 * 填入远程PHP数据
		 * @param obj
		 */		
		public function setRemoteParams(id:int,typeID:String):void
		{
			var nList:Object = FarmDataBase.getDataList(id,typeID);
			if(nList is Vector.<NormalItemVo>)newsList.dataProvider = new ListCollection(nList);
			var lList:Object = FarmDataBase.getLargeList(id,typeID);
			if(lList is Vector.<NormalItemVo>){
				imageFade.iconFiled = "large";
				imageFade.labelFiled = "title";
				imageFade.dataProvider = lList;
			}
			addListeners();
		}
		
		public function set memberData(obj:Object):void{
			
		}
		
		private function addListeners():void
		{
			newsList.addEventListener(Event.CHANGE,onChange);
			imageFade.addEventListener(ItemEvent.ITEM_CLICK,onItemClick);
		}
		
		private function onItemClick(e:ItemEvent):void
		{
			dispatchItem(e.selectedItem);
		}
		
		private function onChange(e:Event):void
		{
			dispatchItem(newsList.selectedItem);
			newsList.selectedItem = null;//取消选中的条目 如果是同一个可以继续再点
		}
		
		private function dispatchItem(item:Object):void{
			dispatchEventWith("onSelected",false,item);
		}
	}
}