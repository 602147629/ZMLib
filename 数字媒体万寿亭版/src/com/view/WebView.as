package com.view
{
	import com.component.ScrollBar;
	import com.event.ScrollEvent;
	import com.greensock.TweenLite;
	import com.host.MyHTMLHost;
	import com.manager.Vision;
	import com.model.FarmRemoteData;
	import com.utils.StarlingClip;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.LocationChangeEvent;
	import flash.events.MouseEvent;
	import flash.html.HTMLLoader;
	import flash.net.URLRequest;
	
	import ui.ria.McCycleLoading;
	import ui.ria.UIScrollBar;
	
	public class WebView
	{
		private static var webView:WebView;
		public static function getInstance():WebView{
			if(webView == null)webView = new WebView();
			return webView;
		}
		private var url:String;//目标地址
		private var loadCount:int;//最多加载5次后不加载
		/**
		 * 链接目标网址
		 * @param url
		 */		
		public function showUrl(url:String):void{
			if(!FarmRemoteData.isConnect)return;//没有联网状态
			this.url = url;
			initFace();
			loadCount = 0;
			loadUrl();
			//			GamePad.addChangeDirect(onDirect);
		}
		
//		private function onDirect(e:PadEvent):void
//		{
//			if(e.direct == GamePad.DIRECT_UP){
//				stageWebView.scrollV -= 100 * Vision.heightScale;
//			}else if(e.direct == GamePad.DIRECT_DOWN){
//				stageWebView.scrollV += 100 * Vision.heightScale;
//			}
//		}
		
		//		private function onDom(e:HTMLUncaughtScriptExceptionEvent):void
		//		{
		//			trace("javascript异常:" + e.exceptionValue);
		//		}
		
		//正在激活状态
		public function get isActive():Boolean{
			return stageWebView != null ? stageWebView.parent != null : false;
		}
		
		private function loadUrl():void
		{
			if(stageWebView == null)return;
			//			stageWebView.loadURL(url);
//			if(stageWebView.historyLength > 0){
//				stageWebView.historyGo(stageWebView.historyLength - 1);//走历史首页
//			}else{
				stageWebView.load(new URLRequest(url));
//			}
			//			stageWebView.addEventListener(ErrorEvent.ERROR,onError);
			stageWebView.addEventListener(Event.COMPLETE,onWebComplete);
			stageWebView.addEventListener(LocationChangeEvent.LOCATION_CHANGING,onChanging);
			stageWebView.addEventListener(Event.HTML_RENDER,onRender);
			scrollBar.addEventListener(ScrollEvent.SCROLL,onScroll);
			//			Vision.stage.addEventListener(MouseEvent.MOUSE_DOWN,onDragDown);
			hideWeb();
			showLoading();
		}
		
//		private var preY:Number;
//		private function onDragDown(e:MouseEvent):void
//		{
//			preY = e.stageY;
//			Vision.stage.addEventListener(MouseEvent.MOUSE_MOVE,onDragMove);
//		}
//		
//		private function onDragMove(e:MouseEvent):void
//		{
//			Vision.stage.addEventListener(MouseEvent.MOUSE_UP,onDragStop);
//			var nowY:Number = e.stageY;
//			var dirtY:Number = nowY - preY;
//			trace("增加距离" + dirtY);
//			stageWebView.scrollV += dirtY;
//		}
//		
//		private function onDragStop(e:MouseEvent):void
//		{
//			Vision.stage.removeEventListener(MouseEvent.MOUSE_MOVE,onDragMove);
//			Vision.stage.removeEventListener(MouseEvent.MOUSE_UP,onDragStop);
//		}
		
		private function onChanging(e:LocationChangeEvent):void
		{
//			trace("跳转地址:" + e.location);
//			checkSize();
		}
		
		private var loadingMc:StarlingClip;
		private function showLoading():void
		{
			if(loadingMc == null){
				loadingMc = new StarlingClip(McCycleLoading,24);
				loadingMc.touchable = false;
				loadingMc.x = Vision.senceWidth / 2;
				loadingMc.y = baseY + viewHeight / 2;
			}
			Vision.addView(Vision.TIPS,loadingMc);
			loadingMc.gotoAndPlay(1);
			loadingMc.addFrameScript(loadingMc.totalFrames,mcGoto);
		}
		
		private function mcGoto():void{
			loadingMc.gotoAndPlay("loop");
			loadingMc.addFrameScript(loadingMc.totalFrames,mcGoto);
		}
		
		private function onWebComplete(e:Event):void
		{
//			stageWebView.removeEventListener(Event.COMPLETE,onWebComplete);
			showWeb();
			hideLoading();
			checkSize();
			scrollBar.reset();//重置位置
		}
		
		private function hideLoading():void
		{
			loadingMc.stop();
			Vision.removeView(Vision.TIPS,loadingMc);
			loadingMc.addFrameScript(loadingMc.totalFrames,null);
		}
		
		private function onError(e:ErrorEvent):void
		{
			trace("加载网页出错:" + e);
			if(++ loadCount < 5){
				loadUrl();//继续加载
			}
		}
		/**
		 * 关闭
		 */		
		public function hide():void{
			if(stageWebView != null){
				hideWeb();
				hideLoading();
				stageWebView.removeEventListener(FocusEvent.FOCUS_IN,onFocuseIn);
				stageWebView.removeEventListener(LocationChangeEvent.LOCATION_CHANGE,onChanging);
				stageWebView.removeEventListener(ErrorEvent.ERROR,onError);
				stageWebView.removeEventListener(Event.COMPLETE,onWebComplete);
				stageWebView.removeEventListener(Event.HTML_RENDER,onRender);
				scrollBar.removeEventListener(ScrollEvent.SCROLL,onScroll);
				scrollBar.close();
//				stageWebView.
//				GamePad.removeChangeDirect(onDirect);
			}
		}
		
		
		private function onScroll(e:ScrollEvent):void
		{
			TweenLite.to(stageWebView,.2,{scrollV:e.postion});
//			stageWebView.scrollV = e.postion;
		}
		
		public function historyBack():void{
			if(stageWebView != null)stageWebView.historyBack();
		}
		
		private var uiScroll:UIScrollBar;
		private var scrollBar:ScrollBar;
		private var stageWebView:HTMLLoader;
//		private var scrollWidth:Number = 100;
//		private var htmlSp:Sprite;
		private function initFace():void
		{
			if(stageWebView == null){
				stageWebView = new HTMLLoader();
				stageWebView.htmlHost = new MyHTMLHost();
				
				uiScroll = new UIScrollBar();
//				uiScroll.width = scrollWidth;
				uiScroll.x = Vision.senceWidth - uiScroll.width;
				
				scrollBar = new ScrollBar();
				scrollBar.init(uiScroll.mcBg,uiScroll.btnPole,uiScroll.btnUp,uiScroll.btnDown);
				scrollBar.barHeight  = viewHeight;
				
				normalClick(uiScroll.mcBg);
				normalClick(uiScroll.btnPole);
				normalClick(uiScroll.btnUp);
				normalClick(uiScroll.btnDown);
			}
			stageWebView.y = uiScroll.y = baseY;
			stageWebView.width = viewWidth;// - uiScroll.width;
			stageWebView.height = viewHeight;
		}
		
		private function normalClick(mc:MovieClip):void
		{
			mc.gotoAndStop(1);
			mc.addEventListener(MouseEvent.MOUSE_DOWN,onMcDown);
			mc.addEventListener(MouseEvent.MOUSE_OUT,onMcOut);
			mc.addEventListener(MouseEvent.MOUSE_UP,onMcOut);
		}
		
		private function onMcOut(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.gotoAndStop(1);
		}
		
		private function onMcDown(e:MouseEvent):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			mc.gotoAndStop(3);
		}
		
		private function onRender(e:Event):void
		{
//			if(stageWebView.scrollRect != null){
				var h:Number = stageWebView.contentHeight - viewHeight;
				if(h <= 0){
					scrollBar.close();
					uiScroll.visible = false;
				}else{
					scrollBar.open();
					scrollBar.dragHeight = h;
					uiScroll.visible = true;
				}
//			}
		}
		
		private function checkSize():void{
//			stageWebView.width = viewWidth;
//			stageWebView.height = stageWebView.contentHeight;
		}
		//		private function onDeviceReady( e:Event ):void
		//		{
		//			trace('onDeviceReady');
		//			// all is loaded and ok, show the view
		//			Vision.stage.addChild(stageWebView);
		//		}
		
		private var viewWidth:Number = Vision.senceWidth;
		private var viewHeight:Number = Vision.senceHeight - Vision.MENU_HEIGHT * Vision.heightScale - Vision.MENU_ITEM_HEIGHT * Vision.heightScale - Vision.admanageHeight * Vision.heightScale;
		private var baseY:Number = (Vision.admanageHeight + Vision.farmMenuHeight) * Vision.heightScale;
		private function showWeb():void
		{
			//			stageWebView.viewPort = new Rectangle( 0, baseY,viewWidth, viewHeight);
			//			stageWebView.stage = Vision.stage;
			Vision.stage.addChild(stageWebView);
			Vision.stage.addChild(uiScroll);
		}
		
		private function hideWeb():void{
			//			stageWebView.viewPort = null;//不必显示
			if(stageWebView != null && stageWebView.parent == Vision.stage){
				Vision.stage.removeChild(stageWebView);
				Vision.stage.removeChild(uiScroll);
			}
		}
		
		private function onFocuseIn(e:Event):void
		{
			//			trace("获得焦点");
			StandMember.getInstance().startTime();
		}
	}
}