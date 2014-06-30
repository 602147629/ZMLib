package com.engine
{
	import away3d.cameras.lenses.PerspectiveLens;
	import away3d.containers.View3D;
	import away3d.core.managers.Stage3DManager;
	import away3d.core.managers.Stage3DProxy;
	import away3d.events.Stage3DEvent;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	
	public class PowerEngine
	{
		public static const PLAT_PC:String = 'PC';
		public static const PLAT_PAD:String = 'PAD';
		public static const PLAT_PHONE:String = 'PHONE';
		
		private static var _platform:String;
		/**平台标记*/
		public static function get platform():String
		{
			return _platform;
		}
		
		private static var stage3DManager:Stage3DManager;
		private static var stage3DProxy:Stage3DProxy;
		private static var starlingCheckerboard:Starling;
		private static var starlingStars:Starling;
		private static var away3dView:View3D;
		private static var stage:Stage;
		private static var antiAlias:int;
		private static var initComplete:Function;
		private static var rootClass:Class;
		private static var backClass:Class;
//		private static var theme:Class;
		
//		public static function get senceHeight():int
//		{
//			return stage.stageHeight;
//		}
//		
//		public static function get senceWidth():int
//		{
//			return stage.stageWidth;
//		}
		private static var starlingOnly:Boolean;
		/**
		 * @param rootClass Starling初始化完毕后执行的根容器
		 * @param stage flash源生舞台实例
		 * @param antiAlias 消除锯齿参数 默认为4
		 * @param starlingOnly 只初始化Starling
		 * @param theme 主题 可传入MetalWorksMobileTheme,AeonDesktopTheme,MinimalMobileTheme的类型
		 * @param initComplete 初始化结束后回调
		 */		
		public static function createEngine(rootClass:Class,
				stage:Stage,antiAlias:int = 4,starlingOnly:Boolean = false,
				initComplete:Function = null,backClass:Class = null,plat:String = PLAT_PC):void
		{
//			PowerEngine.theme = theme;
			PowerEngine.rootClass = rootClass;
			PowerEngine.backClass = backClass;
			PowerEngine.stage = stage;
			PowerEngine.antiAlias = antiAlias;
			PowerEngine.initComplete = initComplete;
			PowerEngine.starlingOnly = starlingOnly;
			PowerEngine._platform = plat;
			if(starlingOnly){
				initSingleStarling();
			}else{
				initProxies();
			}
		}
		
		private static var singleStarling:Starling;
		private static function initSingleStarling():void
		{
			Starling.handleLostContext = true;
			singleStarling = new Starling(rootClass,stage, null, null, "auto", "baseline");
			singleStarling.stage.color = _backgroundColor;
			singleStarling.start();
		}
		
		private static function initProxies():void
			
		{
			//为Stage3D对象定义一个新的Stage3DManager;
			stage3DManager = Stage3DManager.getInstance(stage);
			//			//创建一个新的Stage 3D 代理来管理不同的视图。
			stage3DProxy = stage3DManager.getFreeStage3DProxy();
			stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated);
			stage3DProxy.antiAlias = antiAlias;
			stage3DProxy.color = _backgroundColor;
		}
		private static var _backgroundColor:uint = 0xFFFFFF;
		public static function set backgroundColor(value:uint):void{
			_backgroundColor = value;
			if(stage3DProxy != null)stage3DProxy.color = value;
			if(singleStarling != null)singleStarling.stage.color = value;
		}
		
		private static function onContextCreated(e:flash.events.Event = null):void
		{
			stage3DProxy.removeEventListener(Stage3DEvent.CONTEXT3D_CREATED, onContextCreated);
			initStarling();
			initAway();
			initListeners();
			if(initComplete != null)initComplete();
		}
		private static var _awayRenderEnabled:Boolean = false;
		public static function get awayRenderEnabled():Boolean
		{
			return _awayRenderEnabled;
		}
		public static function set awayRenderEnabled(value:Boolean):void
		{
			_awayRenderEnabled = value;
//			if(away3dView == null){
//				initAway();
//			}
		}
		private static function onEnterFrameStage3DProxy(e:flash.events.Event):void
		{
//			stage3DProxy.clear();//清空Context3D 对象
//			if(starlingCheckerboard) starlingCheckerboard.nextFrame();
			
			if(_awayRenderEnabled)AwayEngine.onUpdate();
			starlingStars.nextFrame();
			
//			stage3DProxy.present();//在Stage3D中呈现Context3D 
		}
		
		private static function initStarling():void
		{
			if(PowerEngine.backClass != null) 
			{
				starlingCheckerboard = new Starling(backClass, stage, stage3DProxy.viewPort, stage3DProxy.stage3D);
				starlingCheckerboard.start();
				starlingCheckerboard.stopLoop();
			}
			Starling.handleLostContext = true;
			starlingStars = new Starling(rootClass,stage, stage3DProxy.viewPort, stage3DProxy.stage3D, "auto", "baseline");
//			starlingStars = new Starling(rootClass,stage, null, null, "auto", "baseline");
			starlingStars.stage.color = _backgroundColor;
			starlingStars.start();
			starlingStars.stopLoop();
//			if(theme != null){
//				starlingStars.addEventListener(starling.events.Event.ROOT_CREATED,onRootCreated);
//			}
		}
		
		public static function set showStats(value:Boolean):void{
			if(starlingOnly){
				singleStarling.showStats = value;
			}else{
				AwayEngine.showStats = value;
			}
		}
		
//		private static function onRootCreated(e:starling.events.Event):void
//		{
//			if(theme != null)theme();
//			starlingStars.removeEventListener(starling.events.Event.ROOT_CREATED,onRootCreated);
//		}
		
		private static function initAway():void{
			away3dView = AwayEngine.createView(stage,antiAlias,false);
			away3dView.stage3DProxy = stage3DProxy;
			away3dView.shareContext = true;
			var _perspectiveLens:PerspectiveLens = (away3dView.camera.lens) as PerspectiveLens;
			_perspectiveLens.fieldOfView = _fieldOfView;
			stage.addChild(away3dView);
			
			AwayEngine.addResize(onResize);
		}
		private static var _fieldOfView:int = 60;//默认视角值
		public static function set fieldOfView(value:int):void
		{
			_fieldOfView = value;
			if(away3dView != null){
				var _perspectiveLens:PerspectiveLens = (away3dView.camera.lens) as PerspectiveLens;
				_perspectiveLens.fieldOfView = value;
			}
		}
		private static function initListeners():void {
//			stage.addEventListener(flash.events.Event.ENTER_FRAME, onEnterFrameStage3DProxy);
			stage3DProxy.addEventListener(flash.events.Event.ENTER_FRAME, onEnterFrameStage3DProxy);
		}
		
		private static function onResize(e:flash.events.Event):void
		{
			var viewPort:Rectangle = new Rectangle(0, 0, AwayEngine.senceWidth, 
				AwayEngine.senceHeight);
//			stage3DProxy.viewPort = viewPort;
			starlingStars.viewPort = viewPort;
			stage3DProxy.width = viewPort.width;
			stage3DProxy.height = viewPort.height;
//			stage3DProxy.viewPort.width = AwayEngine.senceWidth;
//			stage3DProxy.viewPort.height = AwayEngine.senceHeight;
		}
		
	}
}