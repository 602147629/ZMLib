package com.screen
{
	import com.component.ImageFadeView;
	import com.core.IMember;
	import com.manager.ScreenLinerTransitionManager;
	import com.manager.Vision;
	import com.model.FarmDataBase;
	import com.rendener.NormalItemRendener;
	import com.vo.NormalItemVo;
	
	import feathers.controls.Header;
	import feathers.controls.List;
	import feathers.controls.Screen;
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.controls.Scroller;
	import feathers.data.ListCollection;
	import feathers.layout.VerticalLayout;
	
	import starling.events.Event;
	
	public class NormalScreen extends Screen implements IMember
	{
		private var normalNavigator:ScreenNavigator;
		private function initFace():void
		{
			if(normalNavigator == null){
				normalNavigator = new ScreenNavigator(Vision.senceWidth);
				createSreen();
				//				var ti:ScreenSlidingStackTransitionManager = 
				//					new ScreenSlidingStackTransitionManager(nav);
				showScreen(NEWS_ID);//先显示后添加缓动功能
				var lt:ScreenLinerTransitionManager = new ScreenLinerTransitionManager(normalNavigator);
			}
			addChild(normalNavigator);
		}
		private static const NEWS_ID:String = "NEWS_ID";
		private static const DETAILS_ID:String = "DETAILS_ID";
		
		private var newsItem:ScreenNavigatorItem;
		private var detailsItem:ScreenNavigatorItem;
		private function createSreen():void
		{
			newsItem = new ScreenNavigatorItem(NewsScreen,{onSelected:onSelected});
			normalNavigator.addScreen(NEWS_ID,newsItem);
			detailsItem = new ScreenNavigatorItem(DetailsScreen,{onComplete:NEWS_ID});
			normalNavigator.addScreen(DETAILS_ID,detailsItem);
		}
		
		private function onSelected(e:Event,nvo:NormalItemVo):void{
			showScreen(DETAILS_ID);
			(detailsItem.instance as DetailsScreen).memberData = nvo;
		}
		
		private var header:Header;
		override protected function initialize():void
		{
			initFace();
			header = new Header();
			header.height = 50;
			header.width = Vision.senceWidth;
			addChild(header);
			
			addEventListener(Event.REMOVED_FROM_STAGE,removeFromStage);
		}
		
		private function removeFromStage(e:Event):void
		{
			addEventListener(Event.ADDED_TO_STAGE,addToStage);
//			close();
		}
		private function addToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,addToStage);
			//注:让滚动容器恢复起始位置
			showScreen(NEWS_ID,true);//先显示后添加缓动功能
		}
		
		private function showScreen(id:String,noTransition:Boolean = false):void
		{
			normalNavigator.showScreen(id,noTransition);
		}
		
		public function set title(value:String):void{
			header.title = value;
		}
		/**
		 * 填入远程PHP数据
		 * @param obj
		 */		
		public function setRemoteParams(id:int,typeID:String):void
		{
			(newsItem.instance as NewsScreen).setRemoteParams(id,typeID);
			//传递给新闻界面
		}
		public function set memberData(obj:Object):void{
			
		}
		
//		override public function get width():Number
//		{
//			return Vision.senceWidth;
//		}
	}
}