package com.view
{
	import com.core.IMember;
	import com.manager.ScreenLinerTransitionManager;
	import com.manager.Vision;
	import com.model.MenuXMLData;
	import com.vo.MenuVo;
	
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	import feathers.motion.transitions.ScreenSlidingStackTransitionManager;

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
		private var nav:ScreenNavigator;
		private function initFace():void
		{
			if(nav == null){
				nav = new ScreenNavigator();
				nav.y = 200 * Vision.heightScale;
				createSreen();
//				var ti:ScreenSlidingStackTransitionManager = 
//					new ScreenSlidingStackTransitionManager(nav);
//				var lt:ScreenLinerTransitionManager = new ScreenLinerTransitionManager(nav);
			}
			Vision.addView(Vision.MAIN,nav);
		}
		
		private function createSreen():void
		{
			var mList:Vector.<MenuVo> = MenuXMLData.getMenuList();
			//遍历所有的条目 添加进程
			for each (var mvo:MenuVo in mList) 
			{
				nav.addScreen(mvo.id + "",new ScreenNavigatorItem(mvo.view));
					//添加子显示屏幕
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
		
		public function addTitle(ti:String):void{
//			(nav.activeScreen as Object).title = ti;
		}
		
	}
}