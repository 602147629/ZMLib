package com.view
{
	import com.core.IMember;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.manager.TimerManager;
	import com.manager.Vision;
	import com.model.MenuXMLData;
	import com.rendener.MenuRendener;
	import com.utils.StarlingLoader;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearInterval;
	import flash.utils.getTimer;
	
	import feathers.controls.ScreenNavigator;
	import feathers.controls.ScreenNavigatorItem;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	
	public class StandMember
	{
		public static var defaultId:int = 2;//默认待机画面id [2,3,4,5,6]
		private static const DELAY_TIME:Number = 60000;//一分钟60000
		
		private static var standMember:StandMember;
		public static function getInstance():StandMember{
			if(standMember == null)standMember = new StandMember();
			return standMember;
		}
		//		public function show():void{
		//			initFace();
		//		}
		private var nav:ScreenNavigator;
		private function initFace():void
		{
			if(nav == null){
				nav = new ScreenNavigator();
				nav.y = (Vision.MENU_HEIGHT + Vision.admanageHeight) * Vision.heightScale;
				createSreen();
				//				var ti:ScreenSlidingStackTransitionManager = 
				//					new ScreenSlidingStackTransitionManager(nav);
				//				var lt:ScreenFadeTransitionManager = new ScreenFadeTransitionManager(nav);
			}
			Vision.addView(Vision.UI,nav);//放在最高层
		}
		private var preTime:Number;
		public function get isStand():Boolean{
			return nav != null ? nav.parent != null : false;
		}
		/**
		 * 开始计时
		 */		
		public function startTime():void{
			preTime = getTimer();
			Vision.stage.addEventListener(Event.ENTER_FRAME,onLoop);
			Vision.stage.addEventListener(MouseEvent.MOUSE_DOWN,clickStage);
			nav.removeEventListener(TouchEvent.TOUCH,onTouch);
		}
		/**
		 * 屏幕有交互 重新计时
		 */		
		private function clickStage(e:MouseEvent):void
		{
			preTime = getTimer();
		}
		
		private function onLoop(e:Event):void
		{
			if(getTimer() - preTime > DELAY_TIME){
				showDefault();
			}
		}
		
		private function createSreen():void
		{
			//			var mList:Vector.<MenuVo> = MenuXMLData.getMenuList();
			//			//遍历所有的条目 添加进程
			//			for each (var mvo:MenuVo in mList) 
			//			{
			//				if(mvo.stand != null)
			//				nav.addScreen(mvo.id + "",new ScreenNavigatorItem(mvo.stand));
			//					//添加子显示屏幕
			//			}
			nav.addScreen(defaultId + "",new ScreenNavigatorItem(MenuXMLData.getStandClass(defaultId + "")));
			//			showDefault();
		}
		
		private function onTouch(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.currentTarget as DisplayObject);
			if(touch != null && touch.phase == TouchPhase.BEGAN){
				hideScreen();
			}
		}
		
		public function showDefault():void{
			showScreen(defaultId + "");
		}
		/**
		 * 显示某个屏幕
		 * @param id
		 */		
		public function showScreen(id:String):void{
			initFace();
			FarmMenu.getInstance().showStand(int(id));
			CoreMember.getInstance().hideNavigator();
			nav.showScreen(id);
			//			nav.visible = true;
			TweenLite.to(nav,.5,{alpha:1});
			stopTime();
			WebView.getInstance().hide();//关闭网页
//			startTips();
			startTouchTips();
		}
		
		public function hideScreen(resume:Boolean = false):void{
			TweenLite.to(nav,.5,{alpha:0,onComplete:hideOver});
			startTime();//开始计时
			FarmMenu.getInstance().hideStand(resume);
			CoreMember.getInstance().showNavigator();
		}
		
		private function hideOver():void
		{
			//			nav.visible = false;
			Vision.removeView(Vision.UI,nav);//放在最高层
//			endTips();//停止tips
			endTouchTips();
		}
		
		private function stopTime():void
		{
			Vision.stage.removeEventListener(Event.ENTER_FRAME,onLoop);
			Vision.stage.removeEventListener(MouseEvent.MOUSE_DOWN,clickStage);
			nav.addEventListener(TouchEvent.TOUCH,onTouch);
		}
		/**
		 * 添加该界面的远程数据
		 * @param obj
		 */		
		public function setRemoteParams(id:int,typeID:String):void{
			(nav.activeScreen as IMember).setRemoteParams(id,typeID);//添加远程数据
		}
		
		private var touchIcon:Image;
		private function startTouchTips():void{
			if(touchIcon == null){
				StarlingLoader.loadImageFile("assets/other/handTips.png",true,onTouchComplete);
			}else{
				moveTouchTips();
			}
		}
		
		private function endTouchTips():void{
			Vision.fadeClear(touchIcon);
			clearMenuTouch();
			tween.kill();//停止缓动
		}
		
		private var tween:TweenMax;
		private function moveTouchTips(index:int = 0,isAdd:Boolean = true):void
		{
			clearMenuTouch();
			var mLength:int = MenuXMLData.menuLength;
			var nextIndex:int;
			if(isAdd){
				if(index + 1 > mLength - 1){
					isAdd = false;
					nextIndex = index - 1;
				}else{
					nextIndex = index + 1;
				}
			}else{
				if(index - 1 < 0){
					isAdd = true;
					nextIndex = index + 1;
				}else{
					nextIndex = index - 1;
				}
			}
			var baseX:Number = (Vision.menuWidth + Vision.MENU_GAP * Vision.widthScale) * index + (Vision.menuWidth/* - touchIcon.width*/) / 2;
			Vision.fadeInOut(touchIcon,"y",0,10 * Vision.heightScale,.3,3,true,moveTouchTips,nextIndex,isAdd);
			tween = TweenMax.to(touchSp, .5, {overwrite:2,
				bezierThrough:[{x:(touchSp.x + baseX) / 2, y:baseY - 70 * Vision.heightScale},
					{x:baseX, y:baseY},]/*,orientToBezier:true*/,onComplete:showMenuTouch,onCompleteParams:[index]});
		}
		
		private var menuRendener:MenuRendener;
		private function showMenuTouch(index:int):void{
			clearMenuTouch();
			menuRendener = FarmMenu.getInstance().getMenuRendener(index);
			menuRendener.showTips();
		}
		
		private function clearMenuTouch():void
		{
			if(menuRendener != null){
				menuRendener.hideTips();
			}
			menuRendener = null;
		}
		
		private static var baseY:Number;
		private var touchSp:Sprite;
		private function onTouchComplete(t:Texture):void
		{
			if(touchIcon == null){
				touchSp = new Sprite();
				nav.addChild(touchSp);
				touchIcon = new Image(t);
				touchIcon.scaleX = Vision.widthScale;
				touchIcon.scaleY = Vision.heightScale;
				touchIcon.touchable = false;
				touchIcon.alpha = .8;
				touchSp.addChild(touchIcon);
//				baseY = Vision.screenHeight - touchIcon.height + Vision.MENU_ITEM_HEIGHT * Vision.heightScale + 10 * Vision.heightScale;
				baseY = -Vision.MENU_HEIGHT * Vision.heightScale /*- touchIcon.height*/ + 20 * Vision.heightScale;
				touchSp.y = baseY;
			}else{
				touchIcon.texture = t;
				touchIcon.readjustSize();
			}
			moveTouchTips();
		}		
		
		//		private var tipsIcon:Image;
		//		private function startTips():void
		//		{
		//			if(tipsIcon == null){
		//				StarlingLoader.loadImageFile("assets/other/standTips.png",true,onImageComplete);
		//			}else{
		//				moveTips();
		//			}
		//		}
		//		
		//		private function endTips():void{
		//			TimerManager.clearIntervalOut(onMove);
		//		}
		//		
		//		private var speedX:Number = 5 * Vision.widthScale;
		//		private var speedY:Number = 5 * Vision.heightScale;
		//		private function moveTips():void
		//		{
		//			TimerManager.setIntervalOut(25,onMove);
		//		}
		//		
		//		private function onMove():void
		//		{
		//			tipsIcon.x += speedX;
		//			tipsIcon.y += speedY;
		//			checkWall();
		//		}
		//		
		//		private function checkWall():void
		//		{
		//			if(tipsIcon.x < 0){
		//				tipsIcon.x = 0;
		//				speedX = -speedX;
		//			}else if(tipsIcon.x > Vision.senceWidth - tipsIcon.width){
		//				tipsIcon.x = Vision.senceWidth - tipsIcon.width;
		//				speedX = -speedX;
		//			}
		//			if(tipsIcon.y < 0){
		//				tipsIcon.y = 0;
		//				speedY = -speedY;
		//			}else if(tipsIcon.y > Vision.screenHeight + Vision.MENU_ITEM_HEIGHT * Vision.heightScale - tipsIcon.height){
		//				tipsIcon.y = Vision.screenHeight  + Vision.MENU_ITEM_HEIGHT * Vision.heightScale - tipsIcon.height;
		//				speedY = -speedY;
		//			}
		//		}
		//		
		//		private function onImageComplete(t:Texture):void
		//		{
		//			if(tipsIcon == null){
		//				tipsIcon = new Image(t);
		//				tipsIcon.scaleX = Vision.widthScale;
		//				tipsIcon.scaleY = Vision.heightScale;
		//				tipsIcon.touchable = false;
		//				nav.addChild(tipsIcon);
		//				tipsIcon.x = Math.random() * (Vision.senceWidth - tipsIcon.width);
		//				tipsIcon.y = Math.random() * (Vision.screenHeight - tipsIcon.height);
		//			}else{
		//				tipsIcon.texture = t;
		//				tipsIcon.readjustSize();
		//			}
		//			moveTips();
		//		}
		
		
	}
}