package com.engine
{
	import com.greensock.TweenLite;
	
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import away3d.cameras.Camera3D;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.controllers.FirstPersonController;
	import away3d.controllers.HoverController;
	import away3d.core.base.SubGeometry;
	import away3d.debug.AwayStats;
	import away3d.lights.LightBase;
	import away3d.materials.ColorMaterial;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.textures.PlanarReflectionTexture;

	public class AwayEngine
	{
		private static var colorDic:Dictionary = new Dictionary(true);
		public static function getColorMaterial(color:uint,showLight:Boolean = true):ColorMaterial{
			if(colorDic[color] == null){
				var c:ColorMaterial = new ColorMaterial(color);
//				c.smooth = true;
				colorDic[color] = c;
			}
			c = colorDic[color];
			c.lightPicker = showLight ? AwayEngine.lightPicker : null;
			return colorDic[color];
		}
		private static var reflect:PlanarReflectionTexture;
		public static function addReflect(r:PlanarReflectionTexture):void{
			reflect = r;
		}
		
		public static function get senceHeight():int
		{
			return nativeStage.stageHeight;
		}
		public static function get senceWidth():int
		{
			return nativeStage.stageWidth;
		}
		
		private static var _view3D:View3D;

		public static function get view3D():View3D
		{
			return _view3D;
		}
		
		public static function get camera():Camera3D{
			return _view3D.camera;
		}

		public static function addMesh(obj:ObjectContainer3D):void{
			_view3D.scene.addChild(obj);
		}
		
		public static function removeMesh(obj:ObjectContainer3D):void{
			if(obj.parent != null){
				obj.parent.removeChild(obj);
			}
		}
		
		private static var _lightPicker:StaticLightPicker;
		public static function get lightPicker():StaticLightPicker
		{
			if(_lightPicker == null)createPicker();
			return _lightPicker;
		}

		private static var lightList:Array;
		public static function addLight(light:LightBase):void{
			if(_lightPicker == null)createPicker();
			lightList.push(light);
			addMesh(light);
			_lightPicker.lights = lightList;
		}
		
		public static function removeLight(light:LightBase):void{
			if(lightList == null)return;
			var index:int = lightList.indexOf(light);
			if(index >= 0){
				lightList.splice(index,1);
				_lightPicker.lights = lightList;
				removeMesh(light);
			}
		}
		
		private static function createPicker():void{
			lightList = [];
			_lightPicker = new StaticLightPicker(lightList);
		}
		
		private static var _hoverController:HoverController;//360全景展示相机控制器
		public static function get hoverController():HoverController
		{
			return _hoverController;
		}

		private static var nativeStage:flash.display.Stage;
//		private static var starlingStage:starling.display.Stage;
		
		private static var lastPanAngle:Number;
		private static var lastTiltAngle:Number;
		private static var lastMouseX:Number;
		private static var lastMouseY:Number;
		private static var move:Boolean;
		public static function set stage(s:flash.display.Stage):void{
			nativeStage = s;
		}
		public static function createView(s:flash.display.Stage,/*ss:starling.display.Stage,*/
										  anti:int = 4,canUpdate:Boolean = true):View3D
		{
			nativeStage = s;
//			starlingStage = ss;
			initView(anti);
			if(_showStats){
				showStats = _showStats;
			}
			cameraEnabled = true;
			if(canUpdate)s.addEventListener(Event.ENTER_FRAME, onUpdate);
//			nativeStage.scaleMode = StageScaleMode.NO_SCALE;
			nativeStage.align = StageAlign.TOP_LEFT;
			return _view3D;
		}
		
		private static var _cameraEnabled:Boolean;
		public static function set cameraEnabled(value:Boolean):void{
			_cameraEnabled = value;
			if(value){
//				starlingStage.addEventListener(TouchEvent.TOUCH,stageTouch);
				nativeStage.addEventListener(MouseEvent.MOUSE_WHEEL,onWheel);
				nativeStage.addEventListener(MouseEvent.MOUSE_DOWN,stageTouch);
				nativeStage.addEventListener(MouseEvent.MOUSE_UP,stageTouch);
				nativeStage.addEventListener(Event.MOUSE_LEAVE,stageTouch);
				nativeStage.addEventListener(Event.RESIZE, onResize);
			}else{
//				starlingStage.removeEventListener(TouchEvent.TOUCH,stageTouch);
				nativeStage.removeEventListener(MouseEvent.MOUSE_WHEEL,onWheel);
				nativeStage.removeEventListener(MouseEvent.MOUSE_DOWN,stageTouch);
				nativeStage.removeEventListener(MouseEvent.MOUSE_UP,stageTouch);
				nativeStage.removeEventListener(Event.MOUSE_LEAVE,stageTouch);
				nativeStage.removeEventListener(Event.RESIZE, onResize);
				onMouseUp();
			}
		}
		
		public static function stageTouch(e:Event):void
		{
//			var touch:Touch = e.getTouch(starlingStage);
//			if(touch)
//			{
				switch(e.type/*touch.phase*/)
				{
					case MouseEvent.MOUSE_DOWN:
						onMouseDown();
						break;
					case Event.MOUSE_LEAVE:
					case MouseEvent.MOUSE_UP:
						onMouseUp();
						break;
				}
//			}
		}
		
		public static function addResize(func:Function):void{
			nativeStage.addEventListener(Event.RESIZE, func);
		}
		public static function removeResize(func:Function):void{
			nativeStage.removeEventListener(Event.RESIZE, func);
		}
		
		/**
		 * 侦听舞台尺寸改变事件
		 */
		private static function onResize(event:Event = null):void
		{
			_view3D.width = nativeStage.stageWidth;
			_view3D.height = nativeStage.stageHeight;
			if(_stats != null)_stats.x = _stats.y = 0;
		}
		
		private static var _stats:AwayStats;//调试窗口
		private static var _showStats:Boolean;//显示away状态
		public static function set showStats(value:Boolean):void{
			_showStats = value;
			if(value){
				if(_stats == null && _view3D != null){
					_stats = new AwayStats(_view3D);
					if(nativeStage != null)nativeStage.addChild(_stats);
				}
			}else{
				if(_stats != null)nativeStage.removeChild(_stats);
			}
		}
		
		/**
		 * 鼠标按下事件
		 */
		private static function onMouseDown():void
		{
			if(_hoverController == null || !_cameraEnabled)return;//不能交互
//			trace('触发触摸舞台');
			lastPanAngle = _hoverController.panAngle;
			lastTiltAngle = _hoverController.tiltAngle;
			lastMouseX = nativeStage.mouseX;
			lastMouseY = nativeStage.mouseY;
			move = true;
//			follow();
		}
		
		/**
		 * 鼠标弹起事件
		 */
		private static function onMouseUp():void
		{
			move = false;
		}
		
		private static var _perDistance:Number = 100;//放大镜移动的距离
		public static function get perDistance():Number
		{
			return _perDistance;
		}
		public static function set perDistance(value:Number):void
		{
			_perDistance = value;
		}
		
		private static function onWheel(e:MouseEvent):void
		{
			if(e.delta > 0){
				zoomCamera(false);
			}else{
				zoomCamera(true);
			}
		}
		/**
		 * 让相机临时停止旋转
		 */		
		public static function stopCamera():void{
			move = false;
		}
		
		public static function zoomCamera(isLarge:Boolean = false):void{
			if(_hoverController == null)return;//未初始化
			if(isLarge){
				if(_hoverController.distance > minDistance){
					if(_hoverController.distance - _perDistance < minDistance){
						var tarDis:Number = minDistance;
					}else{
						tarDis = _hoverController.distance - _perDistance;
					}
					TweenLite.to(_hoverController,.5,
						{distance:tarDis});
				}
			}else{
				if(_hoverController.distance < maxDistance){
					if(_hoverController.distance + _perDistance > maxDistance){
						tarDis = maxDistance;
					}else{
						tarDis = _hoverController.distance + _perDistance;
					}
					TweenLite.to(_hoverController,.5,
						{distance:tarDis});
				}
					
			}
		}
		
		private static function initView(anti:int):void
		{
			if(_view3D == null)_view3D = new View3D();
			_view3D.antiAlias = anti;
			_view3D.backgroundColor = _backgroundColor;
			_view3D.backgroundAlpha = 0;
		}
		private static var _backgroundColor:uint;
		public static function set backgroundColor(value:uint):void{
			_backgroundColor = value;
			if(_view3D != null)_view3D.backgroundColor = value;
		}
		
	/*	private static function initCamera(camera:Camera3D):void
		{
			if(_hoverController == null)
				_hoverController = new HoverController(camera);
		}*/
		
		
		
		private static var minDistance:Number;
		private static var maxDistance:Number;
//		public static function setCamera(minDis:Number,maxDis:Number,
//				minTiltAngle:Number = 0,maxTiltAngle:Number = 90,
//				panAngle:Number = 45,tiltAngle:Number = 20):void{
//			minDistance = minDis;
//			maxDistance = maxDis;
//			initCamera(_view3D.camera);
////			_hoverController.lookAtObject = 目标模型
////			_hoverController.lookAtPosition = new Vector3D(300,0,0);
//			_hoverController.distance = (maxDis + minDis) / 2;//摄像机和目标点距离
//			_hoverController.minTiltAngle = minTiltAngle;//摄像机以X轴旋转最小角度
//			_hoverController.maxTiltAngle = maxTiltAngle;//摄像机以X轴旋转最大角度
//			_hoverController.panAngle = panAngle;//摄像机以Y轴旋转角度
//			_hoverController.tiltAngle = tiltAngle;//摄像机以X轴旋转角度
//		}
		
		
//		private static const minFinity:Number = -Infinity;
//		private static const maxFinity:Number = Infinity;
		public static function setHoverCamera(minDis:Number,maxDis:Number,
										 minTiltAngle:Number = 0,maxTiltAngle:Number = 90,
										 minPanAngle:Number = NaN,maxPanAngle:Number = NaN,
										 panAngle:Number = 45,tiltAngle:Number = 20):void{
			minDistance = minDis;
			maxDistance = maxDis;
			
//			if(_hoverController == null)
			_hoverController = new HoverController(_view3D.camera);
			//			_hoverController.lookAtObject = 目标模型
			//			_hoverController.lookAtPosition = new Vector3D(300,0,0);
			
			_hoverController.targetObject = _view3D.camera;
			_hoverController.distance = (maxDis + minDis) / 2;//摄像机和目标点距离
			_hoverController.minTiltAngle = minTiltAngle;//摄像机以X轴旋转最小角度
			_hoverController.maxTiltAngle = maxTiltAngle;//摄像机以X轴旋转最大角度
			if(!isNaN(minPanAngle)){
				_hoverController.minPanAngle = minPanAngle;
			}
			if(!isNaN(maxPanAngle)){
				_hoverController.maxPanAngle = maxPanAngle;
			}
			_hoverController.panAngle = panAngle;//摄像机以Y轴旋转角度
			_hoverController.tiltAngle = tiltAngle;//摄像机以X轴旋转角度
//			_hoverController.lookAtObject = null;
//			_hoverController.lookAtObject = _view3D.camera;
//			_hoverController.update();
//			if(_firstPersonController != null){
//				_firstPersonController.targetObject = null;
//			}
		}
		
		private static var _firstPersonController:FirstPersonController;
		public static function setFirstPersonCamera(minTiltAngle:Number = 0,maxTiltAngle:Number = 90,
													panAngle:Number = 45,tiltAngle:Number = 20):void{
//			if(_firstPersonController == null){
				_firstPersonController = new FirstPersonController(_view3D.camera);
//			}
//				_firstPersonController.fly = true;
			_firstPersonController.minTiltAngle = minTiltAngle;
			_firstPersonController.maxTiltAngle = maxTiltAngle;
			_firstPersonController.panAngle = panAngle;
			_firstPersonController.tiltAngle = tiltAngle;
//			if(_hoverController != null){
//				_hoverController.lookAtObject = _hoverController.targetObject = null;
//			}
//			_firstPersonController.targetObject = _view3D.camera;
			
		}
		
		public static function moveHorizontal(isLeft:Boolean):void{
			if(_firstPersonController != null){
				if(isLeft){
					_firstPersonController.incrementStrafe(-10);
				}else{
					_firstPersonController.incrementStrafe(10);
				}
			}
		}
		public static function moveVertical(isUp:Boolean):void{
			if(_firstPersonController != null){
				if(isUp){
					_firstPersonController.incrementWalk(10);
				}else{
					_firstPersonController.incrementWalk(-10);
				}
			}
		}
		
		public static function onUpdate(event:Event = null):void
		{
			// 渲染3D世界
			if (move) {
				_hoverController.panAngle = 0.3 * (nativeStage.mouseX - lastMouseX) + lastPanAngle;
				_hoverController.tiltAngle = 0.3 * (nativeStage.mouseY - lastMouseY) + lastTiltAngle;
//				follow();
			}
			if(reflect != null){
				if(_hoverController != null)_hoverController.update();
				reflect.render(_view3D);
			}
			_view3D.render();
		}
		
//		private static function follow():void{
//			if(nativeStage.hasEventListener(CAMERA_MOVE))nativeStage.dispatchEvent(new Event(CAMERA_MOVE));
//		}
		
		public static function addLoop(handler:Function):void{
			if(nativeStage != null)
			nativeStage.addEventListener(Event.ENTER_FRAME,handler);
		}
//		private static const CAMERA_MOVE:String = "CAMERA_MOVE";
		public static function followCamera(handler:Function):void{
//			nativeStage.addEventListener(CAMERA_MOVE,handler);
			if(_hoverController != null)_hoverController.setUpadeFuction(handler);
		}
		public static function removeLoop(handler:Function):void{
			if(nativeStage != null)
			nativeStage.removeEventListener(Event.ENTER_FRAME,handler);
		}
		public static function control(handler:Function):void{
			nativeStage.addEventListener(MouseEvent.CLICK,handler);
		}
		
		public static function createSubGeom(pList:Vector.<Point>,height:Number = 50):SubGeometry{
			var subGeom : SubGeometry = new SubGeometry();
			//			new SphereGeometry
			var vertex : Vector.<Number> = new Vector.<Number>();
			var indices : Vector.<uint> = new Vector.<uint>();
			
			var v1:Vector.<Vector3D> = new Vector.<Vector3D>();
			var v2:Vector.<Vector3D> = new Vector.<Vector3D>();
			for each (var p:Point in pList) 
			{
				v1.push(new Vector3D(p.x,0,-p.y));
				v2.push(new Vector3D(p.x,height,-p.y));
			}
			var count:int = 0;
			count = createMatrix(v1,vertex,indices,count);
			for (var i:int = v1.length - 1; i >= 0; i--) 
			{
				if(i == 0){
					var j:int = v1.length - 1;
				}else{
					j = i - 1;
				}
				count = createMatrix(new <Vector3D>[v1[i],v1[j],v2[j],v2[i]],vertex,indices,count);
			}
			v2.reverse();
			count = createMatrix(v2,vertex,indices,count);
			subGeom.updateVertexData(vertex);
			subGeom.updateIndexData(indices);
			return subGeom;
		}
		
		private static function createMatrix(vList:Vector.<Vector3D>,
									  vertex:Vector.<Number>,indices:Vector.<uint>,count:int):int{
			for(var i:int = vList.length - 1; i >= 2  ; i --){
				var fNode:Vector3D = vList[vList.length - 1];
				var sNode:Vector3D = vList[i - 1];
				var tNode:Vector3D = vList[i - 2];
				vertex.push(fNode.x,fNode.y,fNode.z,sNode.x,sNode.y,sNode.z,tNode.x,tNode.y,tNode.z);
				//				indices.push(pList.length - 1,i - 1,i - 2);
				indices.push(count++,count++,count++);
			}
			return count;
		}
		
	}
}