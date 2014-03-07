package
{
	import com.engine.AwayEngine;
	import com.engine.PowerEngine;
	import com.manager.Vision;
	import com.utils.CacheUtils;
	
	import flash.display.NativeWindowInitOptions;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.LocationChangeEvent;
	import flash.events.TouchEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.html.HTMLHost;
	import flash.html.HTMLLoader;
	import flash.html.HTMLPopupWindow;
	import flash.html.HTMLWindowCreateOptions;
	import flash.media.StageWebView;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.ui.Keyboard;
	
	import es.xperiments.media.StageWebViewBridge;
	import es.xperiments.media.StageWebViewBridgeEvent;
	import es.xperiments.media.StageWebViewDisk;
	import es.xperiments.media.StageWebviewDiskEvent;
	
	[SWF(width="1080",height="1920",frameRate="60",backgroundColor = 0xFFFFFF)]
//	[SWF(width="400",height="700",frameRate="60",backgroundColor = 0xFFFFFF)]
	public class Main extends Sprite
	{
//		public function Main()
//		{
////			
////			var f:Function = starling.display::Image() as Function;
//			
////			var date:Date = new Date();
////			date.time = 1386128872;
////			trace(date);
//			
//			Starling.handleLostContext = true;
//			var staring:Starling = new Starling(GameMain,stage,null, null, "auto", "baseline");
//			staring.start();
//			staring.showStats = true;
//			
//			Vision.staring = staring;
//			Vision.root = this;
//			Vision.stage = this.stage;
//			
////			var dpo:Sprite = new Sprite();
////			var obj:Object = {xs:100};
////			var list:Array = [1];
////			trace("0" in list);//某个实例身上是否含有"属性"
//		}
		public static const qqUrl:String = "http://ime.qq.com/fcgi-bin/getword";
		
		public function Main()
		{
//			var str:String = "1234";
//			var l:Array = str.split("4");
//			trace(l.length,l);
//			return;
			
//			var color:uint = 0xFF0000;
//			var w:Number = 50;
//			var h:Number = 30;
//			var matrix:Matrix = new Matrix();
//			matrix.createGradientBox(w,h);//变换矩阵范围
//			var nodeShape:Shape = new Shape();
//			nodeShape.graphics.clear();
//			nodeShape.graphics.beginGradientFill(GradientType.LINEAR,[color,color,color],[0,.3,1],[50,100,200],matrix);
//			nodeShape.graphics.drawRect(0,0,w,h);
//			nodeShape.graphics.endFill();
//			addChild(nodeShape);
			
//			stage.addEventListener(TouchEvent.TOUCH_BEGIN,onTouch);
			
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			addEventListener(flash.events.Event.ADDED_TO_STAGE,addToStage);
//			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKey);
			stage.addEventListener(Event.RESIZE,onResize,false,100,true);//最优先处理
			stage.addEventListener(Event.ACTIVATE,onResize,false);
//						Share.clear();
			return;
			var request:URLVariables = new URLVariables();
			request.pg = 9;
			request.p = 1;
			request.q = "c";
			var ur:URLRequest = new URLRequest(qqUrl);
			ur.method = URLRequestMethod.GET;
			ur.data = request;//发送个格式
			var ul:URLLoader = new URLLoader(ur);
			ul.addEventListener(Event.COMPLETE,charComplete);
		}
		
		private function onResize(e:Event):void
		{
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			if(e.type == Event.RESIZE){
				e.stopImmediatePropagation();
			}
		}
		
//		private function onKey(e:KeyboardEvent):void
//		{
//			if(e.keyCode == Keyboard.EXIT){
//				trace("退出键");
//			}
//		}
		
		private var touchId:int;
		private function onTouchMove(e:TouchEvent):void
		{
			touchId = e.touchPointID;
		}
		
		private function charComplete(e:Event):void
		{
			var ul:URLLoader = e.target as URLLoader;
			trace(ul.data);
		}
		
		private function addToStage(e:flash.events.Event):void
		{
			Vision.stage = stage;
			Vision.root = this;
			//			MouseWheelEnabler.init(this.stage);//禁止浏览器滚轮事件
			removeEventListener(flash.events.Event.ADDED_TO_STAGE,addToStage);
			initProxies();
//			initFace();
		}
		
		private var stageWebView:StageWebViewBridge;
		private var htmlLoader:HTMLLoader;
		private function initFace():void
		{
//			var no:NativeWindowInitOptions;
//			no.
			htmlLoader = new HTMLLoader();
			htmlLoader.width = stage.stageWidth;
			htmlLoader.height = stage.stageHeight / 2;
			htmlLoader.load(new URLRequest("http://183.129.255.37:7001/"));
			Vision.stage.addChild(htmlLoader);
			htmlLoader.addEventListener(Event.HTML_DOM_INITIALIZE,onLoadCompplete);
			return;
			
			if(stageWebView == null){
				StageWebViewDisk.addEventListener(StageWebviewDiskEvent.END_DISK_PARSING, onInit );
				StageWebViewDisk.setDebugMode( true );
				StageWebViewDisk.initialize(Vision.stage);
			}else{
//				stageWebView.addEventListener(FocusEvent.FOCUS_IN,onFocuseIn);
//				stageWebView.addEventListener(LocationChangeEvent.LOCATION_CHANGE,onFocuseIn);
			}
		}
		
		private function onLoadCompplete(e:Event):void
		{
			var document:Object = htmlLoader.window.document;
			var anchors:Object = document.getElementsByTagName("a");
			for(var i:Number=0; i < anchors.length; i++) {
				var a:Object = anchors[i];
				a.onmousedown = function(o:Object):void{
					o.preventDefault();
					trace(o);
				};
				continue;
				// Check if anchor has target and if it is _blank so it should be handled seperatly
				var targetAttr:Object = a.attributes.getNamedItem("target");
				if(targetAttr != null && targetAttr.nodeValue == "_blank")
				{
					var urlAttr:Object = a.attributes.getNamedItem("href");
					
					
				}
			}
		}
		
		private function onInit(e:StageWebviewDiskEvent):void
		{
			stageWebView = new StageWebViewBridge(0, 0,stage.stageWidth, stage.stageHeight);
			//			stageWebView.stage = Vision.stage;
			Vision.stage.addChild(stageWebView);
			stageWebView.addEventListener(StageWebViewBridgeEvent.DEVICE_READY, onDeviceReady );
			stageWebView.loadURL("http://183.129.255.37:7001/");
			stageWebView.addEventListener(StageWebViewBridgeEvent.ON_GET_SNAPSHOT,onSnapshot);
			stageWebView.addEventListener(StageWebViewBridgeEvent.DOM_LOADED,onDomLoaded);
//			stageWebView.
			trace(StageWebViewDisk.getRootPath());
//			stageWebView.
//			var uc:URLLoader = new URLLoader(new URLRequest("http://183.129.255.37:7001/"));
//			uc.addEventListener(Event.COMPLETE,onComplete);
//			stageWebView.addEventListener(FocusEvent.FOCUS_IN,onFocuseIn);
//			stageWebView.addEventListener(LocationChangeEvent.LOCATION_CHANGE,onFocuseIn);
//			loadUrl();
		}
		
		private function onComplete(e:Event):void
		{
//			trace(e.target.data);
			var data:String = e.target.data;
			//			stageWebView.loadString(data);
		}
		
		private function onDomLoaded(e:StageWebViewBridgeEvent):void
		{
			trace('onDomLoaded');
		}
		
		private function onSnapshot(e:StageWebViewBridgeEvent):void
		{
			trace('onSnapshot');
		}
		
		private function onDeviceReady( e:Event ):void
		{
			trace('onDeviceReady');
			// all is loaded and ok, show the view
			Vision.stage.addChild(stageWebView);
		}
		
		private function initProxies():void
		{
			PowerEngine.createEngine(GameMain,stage,16/*,CarSence.start*//*,StageBackground*/);
			PowerEngine.backgroundColor = 0xDBEEF1;
			//			PowerEngine.showStats = true;
		}
	}
}