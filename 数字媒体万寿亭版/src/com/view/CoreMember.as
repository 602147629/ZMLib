package com.view
{
	import com.core.IMember;
	import com.manager.ScreenLinerTransitionManager;
	import com.manager.Vision;
	import com.model.MenuXMLData;
	import com.vo.MenuItemVo;
	import com.vo.MenuVo;
	
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	
	import starling.display.Quad;
	
	public class CoreMember
	{
		private static var coreMember:CoreMember;
		public static function getInstance():CoreMember{
			if(coreMember == null)coreMember = new CoreMember();
			return coreMember;
		}
		
		public function show():void{
			initFace();
		}
		
//		public static const SCREEN_HEIGHT:Number = 1160;
		
		private var nav:ScreenNavigator;
		private var back:Quad;
		private function initFace():void
		{
			if(nav == null){
				nav = new ScreenNavigator(Vision.senceWidth,Vision.screenHeight);
				nav.y = (Vision.farmMenuHeight + Vision.admanageHeight) * Vision.heightScale;
				createBack();
				createSreen();
				//				var ti:ScreenSlidingStackTransitionManager = 
				//					new ScreenSlidingStackTransitionManager(nav);
				var lt:ScreenLinerTransitionManager = new ScreenLinerTransitionManager(nav);
			}
		}
		
		public function showNavigator():void{
			Vision.addView(Vision.MAIN,back);
			Vision.addView(Vision.MAIN,nav);
		}
		
		public function hideNavigator():void{
			Vision.removeView(Vision.MAIN,back);
			Vision.removeView(Vision.MAIN,nav);
		}
		
		public function showBack():void{
			back.visible = true;
		}
		
		public function hideBack():void{
			back.visible = false;
		}
		
		private function createBack():void
		{
			back = new Quad(Vision.senceWidth,Vision.screenHeight + Vision.admanageHeight * Vision.heightScale,0xFFFFFF);
			back.touchable = false;
			back.y = nav.y;
			nav.addChild(back);
		}
		
		private function createSreen():void
		{
			var mList:Vector.<MenuVo> = MenuXMLData.getMenuList();
			//遍历所有的条目 添加进程
			for each (var mvo:MenuVo in mList) 
			{
				if(mvo.items == null || mvo.items.length == 0){
					mvo.items = MenuXMLData.createTempItems(mvo);
				}
				for each (var item:MenuItemVo in mvo.items) 
				{
					nav.addScreen(item.id + "",new ScreenNavigatorItem(item.view));
					//添加子显示屏幕
				}
			}
		}
		/**
		 * 显示某个屏幕
		 * @param id
		 */		
		public function showScreen(id:String):void{
			nav.showScreen(id);
		}
		/**
		 * 添加该界面的远程数据
		 * @param obj
		 */		
		public function setRemoteParams(id:int,typeID:String):void{
			(nav.activeScreen as IMember).setRemoteParams(id,typeID);//添加远程数据
		}
		
		public function set memberData(obj:Object):void{
			(nav.activeScreen as IMember).memberData = obj;//添加自定义数据
		}
		
		public function addTitle(ti:String):void{
			//			(nav.activeScreen as Object).title = ti;
		}
		
	}
}