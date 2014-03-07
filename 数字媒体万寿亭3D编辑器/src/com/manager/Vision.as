package com.manager
{
	import com.control.FreeCameraControl;
	import com.engine.AwayEngine;
	import com.greensock.TweenLite;
	import com.utils.GraphicsUtil;
	import com.utils.StarlingConvert;
	import com.vo.ImageVo;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.utils.Dictionary;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	/**
	 * 游戏视图管理器 主要是交互层 UI层 tips层的管理和添加移除等功能
	 * @author gao sir
	 */	
	public class Vision
	{
		public static var CUT_Y:int = -11;
		
		public static const NORMAL_WIDTH:int = 1080;//800;//正常舞台宽高参照值
		public static const NORMAL_HEIGHT:int = 1920;//480;
		
		public static var GRID_SIZE:int = 50;
		
		public static var deviceWidth:int;//设备宽高
		public static var deviceHeight:int;
		
		public static const MAIN:String = 'main';
		public static const UI:String = 'ui';
		public static const TIPS:String = 'tip';
		
		/** 全局 舞台实例 */		
		public static var stage:flash.display.Stage;
		
		public static var staring:Starling;
		/** 全局 staringStage实例 */		
		public static var staringStage:starling.display.Stage;
		/** 全局 staringRoot实例 */
		public static var staringRoot:starling.display.DisplayObjectContainer;
		public static var root:flash.display.DisplayObjectContainer;
		
//		public static var normalScale:Number = 1;//正常尺寸和舞台宽高放大的比例
		public static var widthScale:Number = 1;//正常尺寸和舞台宽高放大的比例
		public static var heightScale:Number = 1;//正常尺寸和舞台宽高放大的比例
		
		public static function get normalScale():Number{
			return widthScale < heightScale ? widthScale : heightScale;
		}
		
		private static const DPO_DIC:Dictionary = 
			new Dictionary(true);//通过各自的键存储三个容器
		//Dictionary优化后的存储结构Object
		
		private static var shadeLayer:starling.display.Sprite;//背景遮蔽层
		/**
		 * 初始化三层游戏容器
		 * @param root Main的实例(根容器)
		 * @param m 是pc端 还是移动端
		 */		
		/*public static function createChildren(
			root:DisplayObjectContainer,m:String = "pc"):void{
			//分别添加三层容器 main ui tip (Sprite)
			Vision.stage = root.stage;//存储舞台
			var main:Sprite = new Sprite();
			root.addChild(main);
			DPO_DIC[Vision.MAIN] = main;
			//将对应的容器添加到DPO_DIC存储结构中
			
			var us:Sprite = new Sprite();
			us.mouseEnabled = false;
			root.addChild(us);
			DPO_DIC[Vision.UI] = us;
			
			var tip:Sprite = new Sprite();
			tip.mouseEnabled = false;
			root.addChild(tip);
			DPO_DIC[Vision.TIP] = tip;
			
		}*/
		public static var TEXTURE_EMPTY:Texture;
		//空数据
		public static function createGpu(dpc:starling.display.DisplayObjectContainer,
										 m:String = "pc"):void{
			if(TEXTURE_EMPTY == null)TEXTURE_EMPTY = Texture.empty(1,1);
			
			setMode(m);
			
			checkScale();
			
			staringRoot = dpc;
			staringStage = dpc.stage;
			//			main.mouseEnabled = false;
			//在MAIN层创建容器 然后由DPO_DIC存储该容器
			
			var main:starling.display.Sprite = new starling.display.Sprite();
			dpc.addChild(main);
			DPO_DIC[MAIN] = main;
			
			var quad:Quad = new Quad(senceWidth,senceHeight,0xEEEEEE,true)//遮蔽黑板层
			quad.alpha = .5;
			shadeLayer = new starling.display.Sprite();
			shadeLayer.addChild(quad);
			dpc.addChild(shadeLayer);
			shadeLayer.visible = false;
			
			var us:starling.display.Sprite = new starling.display.Sprite();
			dpc.addChild(us);
			DPO_DIC[UI] = us;
			
			var tip:starling.display.Sprite = new starling.display.Sprite();
			dpc.addChild(tip);
			DPO_DIC[TIPS] = tip;
			//让此容器不接受鼠标事件 
			//但子容器可以选择性接收
			
		}
		
		private static function checkScale():void
		{
			widthScale = senceWidth / NORMAL_WIDTH;
			heightScale = senceHeight / NORMAL_HEIGHT;
			trace("横向比例:" + widthScale,"纵向比例:" + heightScale);
//			normalScale = scaleW > scaleH ? scaleH : scaleW;
			
//			GRID_SIZE *= normalScale;//重新调整格子大小
//			CUT_Y *= normalScale;
		}
		
		public static var mode:String;
		private static function setMode(m:String):void{
			mode = m;
			if(m == 'pc'){
				deviceWidth = senceWidth;
				deviceHeight = senceHeight;
			}else if(m == 'android'){
				deviceWidth = Capabilities.screenResolutionX;
				deviceHeight = Capabilities.screenResolutionY;
			}else{
				deviceWidth = Capabilities.screenResolutionY;
				deviceHeight = Capabilities.screenResolutionX;
			}
		}
		
		public static function showShade():void{
			shadeLayer.alpha = 0;
			shadeLayer.visible = true;
			TweenLite.to(shadeLayer,.5,{alpha:1});
		}
		public static function hideShade(onComplete:Function = null):void{
			TweenLite.to(shadeLayer,.5,{alpha:0,onComplete:shadeOver,
				onCompleteParams:[onComplete]});
		}
		
		private static function shadeOver(onComplete:Function = null):void{
			shadeLayer.visible = false;
			if(onComplete != null)onComplete();
		}
			
		/**
		 * 将目标显示对象添加到相应的层次容器中
		 * @param id 对应容器的标识
		 * @param dpo 目标的显示对象
		 */		
		public static function addView(id:String,
									   dpo:starling.display.DisplayObject):void{
			var layer:starling.display.Sprite = DPO_DIC[id];//访问目标层次
			layer.addChild(dpo);//添加到目标容器中
		}
		/**
		 * 将目标显示对象从相应的层次容器中移除掉(如果不是他的子对象???)
		 * @param id
		 * @param dpo
		 */		
		public static function removeView(id:String,
										  dpo:starling.display.DisplayObject):void{
			var layer:starling.display.Sprite = DPO_DIC[id];//访问目标层次
			if(dpo.parent == layer){//如果目标的父容器就是该层 才移除
				layer.removeChild(dpo);//从父容器内移除
			}
		}
		
		public static function getLayer(id:String):starling.display.DisplayObjectContainer{
			return DPO_DIC[id];
		}
		
		public static function center(dpo:starling.display.DisplayObject):void{
			/*dpo.x = (_stageWidth - dpo.width)>>1;
			dpo.y = ((_stageHeight - dpo.height)>>1)-dpo.parent.y;*/
			centerDpo(dpo,senceWidth,senceHeight);
		}
		
		public static function centerDpo(dpo:starling.display.DisplayObject,
										 w:Number,h:Number):void{
			var rect:Rectangle = dpo.getBounds(dpo);
			dpo.x = /*dpo.parent.x + */w / 2 - rect.width / 2 - rect.x;
			dpo.y = h / 2 - rect.height / 2 - rect.y;
		}
		
		//代理获取舞台宽度
		public static function get senceWidth():Number{
			return stage.stageWidth;
		}
		//代理获取舞台高度
		public static function get senceHeight():Number{
			return stage.stageHeight;
		}
		
		private static var bmdDic:Dictionary = new Dictionary(true);
		//key color value bmd
		public static function getBmd(color:uint):BitmapData{
			if(bmdDic[color] === undefined)bmdDic[color] = new BitmapData(1,1,false,color);
			return bmdDic[color];
		}
		
		/*public static function convertBmd(dpo:flash.display.DisplayObject):BitmapData{
			var bounds:Rectangle = dpo.getBounds(null);
			var offSetX:int = bounds.x * dpo.scaleX;
			var offSetY:int = bounds.y * dpo.scaleY;
			var matrix:Matrix = new Matrix(1,0,0,1,-offSetX,-offSetY);
			var bitmapData:BitmapData = new BitmapData(dpo.width,dpo.height,true,0x00000000);
			bitmapData.lock();
			bitmapData.draw(dpo,matrix);
			bitmapData.unlock();
			return bitmapData;
		}*/
		
		
		private static var fadeDic:Dictionary = new Dictionary(true);
		private static var fadeId:int;
		
		/**
		 * 淡入淡出效果
		 * @param dpo
		 * @param minAlpha 最低alpha值
		 * @param maxAlpha 最高alpha值
		 * @param time 间隔(秒)数
		 * @param count 次数 -1表示无限
		 * return fadeId 淡入淡出id
		 */		
		public static function fadeInOut(dpo:Object,minAlpha:Number = 0,maxAlpha:Number = 1,
						time:Number = .3,count:int = -1,onComplete:Function = null,...args):int{
			/*var fadeList:Vector.<FadeVo> = fadeDic[++ fadeId] = new Vector.<FadeVo>;
			for each (var dpo:DisplayObject in dpoList) 
			{
				fadeList.push(new FadeVo(dpo,dpo.alpha));
			}*/
			fadeDic[++ fadeId] = new FadeVo(dpo,dpo.alpha);
			dpo.alpha = maxAlpha;
			fadeIn(dpo,minAlpha,maxAlpha,time,count,onComplete,args);
			return fadeId;
		}
		/**
		 * 清空对应一波的fade
		 * @param id
		 */		
		public static function fadeClear(id:int):void{
			var fade:FadeVo = fadeDic[id];
			if(fade != null)fade.dispose();
//			var fadeList:Vector.<FadeVo> = fadeDic[id];
//			for each (var fade:FadeVo in fadeList) 
//			{
//				fade.dispose();
//			}
//			fadeList.length = 0;
			delete fadeDic[id];
		}
		
		private static function fadeIn(dpo:Object,minAlpha:Number = 0,maxAlpha:Number = 1,
			time:Number = .3,count:int = -1,onComplete:Function = null,args:* = null):void{
			if(count == 0){
			if(onComplete != null)args != null ? onComplete.apply(null,args):onComplete();
			}else TweenLite.to(dpo,time,{alpha:minAlpha,onComplete:fadeOut,overwrite:2,
				onCompleteParams:[dpo,minAlpha,maxAlpha,time,count,onComplete,args]});
		}
		
		private static function fadeOut(dpo:Object,minAlpha:Number = 0,maxAlpha:Number = 1,
			time:Number = .3,count:int = -1,onComplete:Function = null,args:* = null):void{
			TweenLite.to(dpo,time,{alpha:maxAlpha,onComplete:fadeIn,overwrite:2,
				onCompleteParams:[dpo,minAlpha,maxAlpha,time,--count,onComplete,args]});
		}
		
		/**
		 * 震动效果
		 * @param dpo 需要震动的显示对象
		 * @param level 震级 3级附加模糊效果
		 * by GY
		 */	
		public static function quakeWave(dpo:starling.display.DisplayObject,
										 onComplete:Function = null,...args):void{
			//dpo.y - 12,dpo.y + 8,dpo.y - 6,
			var quakeSiteList:Vector.<Point> = new Vector.<Point>();
			for (var i:int = 0; i < 10; i++) 
			{
				quakeSiteList.push(new Point(
					getRandom(dpo.x - 10,dpo.x + 10),getRandom(dpo.y - 10,dpo.y + 10)));
			}
			quakeSiteList.push(new Point(dpo.x,dpo.y));
			quakeTween(dpo,quakeSiteList,onComplete,args);
		}
		
		private static function getRandom(min:Number,max:Number):Number{
			return Math.random() * (max - min) + min;
		}
		
		private static function quakeTween(dpo:starling.display.DisplayObject,
						quakeSiteList:Vector.<Point>,onComplete:Function = null,
						args:Array = null):void{
			var point:Point = quakeSiteList.shift();
			if(quakeSiteList.length == 0){ //已经不存在下一个点blurry
				dpo.x = point.x;
				dpo.y = point.y;
				if(onComplete != null)
					args != null ? onComplete.apply(null,args) : onComplete();
				return;
			}
			TweenLite.to(dpo,.01,{x:point.x,y:point.y,onComplete:quakeTween,
				onCompleteParams:[dpo,quakeSiteList,onComplete,args]});
		}
		private static var drawSp:flash.display.Sprite;
		private static var itemDic:Dictionary = new Dictionary(true);
		private static var drawBd:BitmapData;
//		public static const ITEM_WIDTH:Number = 118;
		public static var menuWidth:Number = -1;//菜单宽度 
		public static const NORMAL_ITEM_HEIGHT:Number = 200;//普通菜单条目高度
		public static const MENU_ITEM_HEIGHT:Number = 83;//菜单条目高度
		public static const FOOD_ITEM_HEIGHT:Number = 85;//食物条目高度
		public static const TRACE_ITEM_HEIGHT:Number = 56;//追溯条目高度
		public static const MERCH_ITEM_HEIGHT:Number = 40;//商户条目高度
		public static const MENU_GAP:int = 2;
		public static function createLeftTab(w:Number,h:Number,color:uint,lineColor:uint = 0):Texture{
			return getTabTexture(w,h,color,lineColor,"left");
		}
		public static function createRightTab(w:Number,h:Number,color:uint,lineColor:uint = 0):Texture{
			return getTabTexture(w,h,color,lineColor,"right");
		}
		public static function createNormalTab(w:Number,h:Number,color:uint,lineColor:uint = 0):Texture{
			return getTabTexture(w,h,color,lineColor);
		}
		private static var tabDic:Dictionary = new Dictionary(true);
		private static function getTabTexture(w:Number,h:Number,color:uint,lineColor:uint = 0,
											  kind:String = "default"):Texture{
			if(tabDic[w + "_" + h + "_" + color + "_" + lineColor + "_" + kind] != null){
				return tabDic[w + "_" + h + "_" + color + "_" + lineColor + "_" + kind];
			}
			if(nodeShape == null){
				createNodeShape();
			}
			var thickness:int = Math.ceil(1 * Vision.heightScale);
			nodeShape.graphics.clear();
			nodeShape.graphics.lineStyle(thickness,lineColor);
			nodeShape.graphics.beginFill(color);
			switch(kind){
				case "left":
					nodeShape.graphics.drawRoundRectComplex(thickness / 2,thickness / 2,w - thickness,h - thickness,10,0,10,0);
					break;
				case "right":
					nodeShape.graphics.drawRoundRectComplex(thickness / 2,thickness / 2,w - thickness,h - thickness,0,10,0,10);
					break;
				case "default":
					nodeShape.graphics.drawRect(thickness / 2,thickness / 2,w - thickness,h - thickness);
					break;
			}
			nodeShape.graphics.endFill();
			
			var bd:BitmapData = AssetManager.getSourceBd(w + thickness * 2,h + thickness * 2);
			bd.draw(nodeShape);
			var t:Texture = Texture.fromBitmapData(bd);
			tabDic[w + "_" + h + "_" + color + "_" + lineColor + "_" + kind] = t;
//			bd.dispose();
			return t;
		}
		
		private static var rectDic:Dictionary = new Dictionary(true);
		public static function createRoundRect(w:Number,h:Number,color:uint):Texture{
			w = Math.ceil(w);
			h = Math.ceil(h);
			if(rectDic[w + "_" + h + "_" + color] != null){
				return rectDic[w + "_" + h + "_" + color];
			}
			if(nodeShape == null){
				createNodeShape();
			}
			nodeShape.graphics.clear();
			nodeShape.graphics.beginFill(color);
			nodeShape.graphics.drawRoundRect(0,0,w,h,10);
			nodeShape.graphics.endFill();
			var bd:BitmapData = AssetManager.getSourceBd(w,h);
			bd.draw(nodeShape);
			var t:Texture = Texture.fromBitmapData(bd);
			rectDic[w + "_" + h + "_" + color] = t;
//			bd.dispose();
			return t;
		}
		
		/**
		 * 创建子条目背景色块
		 * @return 
		 */		
		public static function createItemBack(color:uint):Texture{
			if(drawSp == null){
				createDrawSp();
			}
			if(itemDic[color] != null){
				return itemDic[color];
			}
			drawItem(color);
			drawBd.fillRect(drawBd.rect,0);
			drawBd.draw(drawSp);
			var t:Texture = Texture.fromBitmapData(drawBd);
			itemDic[color] = t;
			return t;
		}
		
		private static function drawItem(color:uint):void
		{
			drawSp.graphics.clear();
			drawSp.graphics.beginFill(color);
			drawSp.graphics.drawRoundRectComplex(0,0,menuWidth,MENU_ITEM_HEIGHT * Vision.heightScale,5,5,5,5);
			drawSp.graphics.endFill();
		}
		
		private static function createDrawSp():void
		{
			drawSp = new flash.display.Sprite();
			//(118,83)
			var shape:Shape = new Shape();
			drawSp.addChild(shape);
			shape.graphics.beginFill(0xFFFFFF,.2);
			shape.graphics.drawRoundRectComplex(0,0,menuWidth,MENU_ITEM_HEIGHT / 2 * Vision.heightScale,5,5,0,0);
			shape.graphics.endFill();
			drawBd = AssetManager.getSourceBd(menuWidth,MENU_ITEM_HEIGHT * Vision.heightScale);
		}
		
		private static var starDic:Dictionary = new Dictionary(true);
		/**
		 * @param color
		 * @param radius 外半径
		 * @return 
		 */		
		public static function createStar(color:uint,radius:Number = 5):Image{
			radius = Math.ceil(radius);
			if(starDic[color] != null){
				var ivo:ImageVo = starDic[color];
				var image:Image = new Image(ivo.texture);
				image.width = image.height = radius * 2;
				image.pivotX = image.pivotY = radius;
				return image;//已经存在就不绘制了
			}
			if(nodeShape == null){
				createNodeShape();
			}
			var minR:Number = radius / 2;
			GraphicsUtil.drawRegularStar(nodeShape.graphics,5,minR,radius,color);
			ivo = StarlingConvert.convertBmd(nodeShape);
			image = new Image(ivo.texture);
			image.width = image.height = radius * 2;
			image.pivotX = image.pivotY = radius;
			starDic[color] = ivo;
			return image;
		}
		
		private static var circleDic:Dictionary = new Dictionary(true);
		public static function createCircle(color:uint,radius:Number = 5):Image{
			radius = Math.ceil(radius);
			if(circleDic[color] != null){
				var ivo:ImageVo = circleDic[color];
				var image:Image = new Image(ivo.texture);
				image.width = image.height = radius * 2;
				image.pivotX = image.pivotY = radius;
				return image;//已经存在就不绘制了
			}
			if(nodeShape == null){
				createNodeShape();
			}
			nodeShape.graphics.clear();
			nodeShape.graphics.beginFill(color);
			nodeShape.graphics.drawCircle(0,0,radius);
			nodeShape.graphics.endFill();
			ivo = StarlingConvert.convertBmd(nodeShape);
			image = new Image(ivo.texture);
			image.width = image.height = radius * 2;
			image.pivotX = image.pivotY = radius;
			circleDic[color] = ivo;
			return image;
		}
		
		private static var nodeShape:Shape;
		private static var nodeDic:Dictionary = new Dictionary(true);
		/**
		 * 创建节点小圆
		 * @return 
		 */		
		public static function createNode(color:uint,radius:Number = 5):Texture{
			if(nodeDic[color] != null){
				return nodeDic[color];//已经存在就不绘制了
			}
			if(nodeShape == null){
				createNodeShape();
			}
			nodeShape.graphics.clear();
			nodeShape.graphics.beginFill(color);
			nodeShape.graphics.drawCircle(0,0,radius * Vision.heightScale);
			nodeShape.graphics.endFill();
			var ivo:ImageVo = StarlingConvert.convertBmd(nodeShape);
			nodeDic[color] = ivo.texture;
			return ivo.texture;
		}
		
		private static function createNodeShape():void
		{
			nodeShape = new Shape();
		}
		/**
		 * 屏蔽车型的拖拽交互 保护一般组件的交互
		 */		
		public static function shield():void{
			//			dpo.addEventListener(TouchEvent.TOUCH,onStopEngine);
			Vision.staringStage.addEventListener(TouchEvent.TOUCH,onStopEngine);
		}
		public static function unShield():void{
			//			dpo.addEventListener(TouchEvent.TOUCH,onStopEngine);
			Vision.staringStage.removeEventListener(TouchEvent.TOUCH,onStopEngine);
		}
		
		private static function onStopEngine(e:TouchEvent):void
		{
			var touch:Touch = e.getTouch(e.target as starling.display.DisplayObject);
			if(touch != null && e.target != Vision.staringStage){
				if(touch.phase == TouchPhase.BEGAN){
					//					trace('触发触摸元件:' + touch);
//					AwayEngine.cameraEnabled = false;
					FreeCameraControl.getInstance().close();
					stage.addEventListener(MouseEvent.MOUSE_UP,stageTouch,false,5,true);
					stage.addEventListener(Event.MOUSE_LEAVE,stageTouch,false,5,true);
				}
			}
		}
		
		private static function stageTouch(e:Event):void
		{
//			AwayEngine.cameraEnabled = true;
			FreeCameraControl.getInstance().open();
			Vision.stage.removeEventListener(MouseEvent.MOUSE_UP,stageTouch);
			Vision.stage.removeEventListener(Event.MOUSE_LEAVE,stageTouch);
//			e.stopImmediatePropagation();
		}
		
	}
}
import com.greensock.TweenLite;

class FadeVo{
	private var preAlpha:Number;
	private var dpo:Object;
	
	public function FadeVo(dpo:Object,preAlpha:Number){
		this.dpo = dpo;
		this.preAlpha = preAlpha;
//		if(preAlpha != 1 && preAlpha != 0)
//			trace('preAlpha: '+ preAlpha);
	}
	public function dispose():void{
		dpo.alpha = preAlpha;
		TweenLite.killTweensOf(dpo);
		dpo = null;
	}
	
}