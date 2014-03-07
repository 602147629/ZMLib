package com.view
{
	import com.control.FreeCamera3D;
	import com.control.FreeCameraControl;
	import com.control.GamePad;
	import com.engine.AwayEngine;
	import com.engine.PowerEngine;
	import com.event.PadEvent;
	import com.greensock.TweenLite;
	import com.manager.Vision;
	import com.model.GameModel;
	import com.screen.InfoScreen;
	import com.utils.GameUtil;
	import com.vo.FloorInfoVo;
	import com.vo.LinkInfoVo;
	import com.vo.MeshInfoVo;
	import com.vo.PointVo;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TransformGestureEvent;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	import flash.utils.Dictionary;
	
	import away3d.bounds.AxisAlignedBoundingBox;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.core.pick.PickingColliderType;
	import away3d.entities.Mesh;
	import away3d.events.MouseEvent3D;
	import away3d.lights.PointLight;
	import away3d.materials.ColorMaterial;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.utils.Cast;
	
	public class Game3DView
	{
		private static var merch3DView:Game3DView;
		public static function getInstance():Game3DView{
			if(merch3DView == null)merch3DView = new Game3DView();
			return merch3DView;
		}
		private static var meshIndexDic:Dictionary = new Dictionary(true);
		private static var tagMeshDic:Dictionary = new Dictionary(true);
		
		public function show():void{
			initFace();
			//			tweenShow();
			addListeners();
		}
		
		private function addListeners():void
		{
			if(Multitouch.supportedGestures != null){
				if(Multitouch.supportedGestures.indexOf(TransformGestureEvent.GESTURE_ZOOM) >= 0){
					Vision.stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM,scaleStage);
				}
			}
		}
		private function removeListeners():void
		{
			Vision.stage.removeEventListener(TransformGestureEvent.GESTURE_ZOOM,scaleStage);
		}
		private function scaleStage(e:TransformGestureEvent):void
		{
			if(e.scaleX < 1 || e.scaleX > 1){
				AwayEngine.stopCamera();//停止移动
				AwayEngine.zoomCamera(e.scaleX > 1);
			}
		}
		
		public function hide():void{
			if(meshContainer != null){
				//				tweenHide();
				Vision.unShield();
			}
			removeListeners();
		}
		private var preFloor:int;//前一层的索引值
		private var nowFloor:int;
		
		private function clearChildren(contain:ObjectContainer3D):void{
			if(contain == null)return;
			while(contain.numChildren > 0){
				contain.removeChildAt(0);
			}
		}
		
		private var baseContainer:ObjectContainer3D;
		
		private var meshContainer:ObjectContainer3D;//显示1容器
		//		private var floorDic:Dictionary = new Dictionary(true);//楼层的容器
		
		private var nodeLayer:ObjectContainer3D;//公共设施容器
		private var activeLayer:ObjectContainer3D;//交互层
		private var mapLayer:ObjectContainer3D;//地图容器层(各区域子容器)
		//		private var searchLayer:ObjectContainer3D;//地图搜索层
		//		private var floorLayer:ObjectContainer3D;//楼道数据层
		
		private var searchKey:String = "searchLayer";
		private var floorKey:String = "floorLayer";
		private var roadKey:String = "roadLayer";
		
		private var areaLayerDic:Dictionary = new Dictionary(true);
		private function createArea(parent:ObjectContainer3D,area:int):void{
			var searchLayer:ObjectContainer3D = new ObjectContainer3D();
			parent.addChild(searchLayer);
			areaLayerDic[area + "_" + searchKey] = searchLayer;
			var floorLayer:ObjectContainer3D = new ObjectContainer3D();
			parent.addChild(floorLayer);
			areaLayerDic[area + "_" + floorKey] = searchLayer;
			var roadLayer:ObjectContainer3D = new ObjectContainer3D();
			parent.addChild(roadLayer);
			areaLayerDic[area + "_" + roadKey] = roadLayer;
		}
		/**
		 * 获取关键字相关的容器
		 * @return 
		 */		
		private function getKeyLayer(area:int,key:String):ObjectContainer3D{
			return areaLayerDic[area + "_" + key];
		}
		
		private var freeCamera:FreeCamera3D;
		private var freeCameraControl:FreeCameraControl;
		
		public function showHoverCamera():void{
			//			AwayEngine.setCameraAngle(100 * Vision.normalScale,250 * Vision.normalScale,90,90,NaN,NaN,90,0);
			//			AwayEngine.setHoverCamera(950 * Vision.normalScale,1550 * Vision.normalScale,90,90,NaN,NaN,90,0);
			if(freeCameraControl == null){
				//				freeCamera.defaultTiltAngle = 45;
				freeCamera = new FreeCamera3D(AwayEngine.camera);
				freeCamera.defaultDistance = 1200;
				freeCamera.defaultPanAngle = 90;
				//				freeCamera.defaultTiltAngle = 20;
				freeCamera.reset();
				freeCamera.centerPoint3D = new Vector3D(0,50,0);
				
				freeCameraControl = FreeCameraControl.getInstance();
				freeCameraControl.stage = Vision.stage;
				freeCameraControl.freeCamera = freeCamera;
				//				freeCameraControl.keyBoardTurn = false;//
			}
			//			addPadEvent();
		}
		
		//		public function showFirstCamera():void{
		//			AwayEngine.setFirstPersonCamera(90,90,-90,0);
		//			addPadEvent();
		//		}
		
		private function addPadEvent():void
		{
			GamePad.registerStage(Vision.stage);
			GamePad.openMode(GamePad.MODE_KEYBOARD);
			GamePad.addChangeDirect(changeDirect);
		}
		
		private function initFace():void
		{
			if(baseContainer == null){
				baseContainer = new ObjectContainer3D();
				AwayEngine.addMesh(baseContainer);
				showHoverCamera();
				//				AwayEngine.perDistance = 100;
				
				meshContainer = new ObjectContainer3D();
				baseContainer.addChild(meshContainer);
				
				activeLayer = new ObjectContainer3D();
				baseContainer.addChild(activeLayer);
				
				nodeLayer = new ObjectContainer3D();
				baseContainer.addChild(nodeLayer);
				
				//				searchLayer = new ObjectContainer3D();
				//				baseContainer.addChild(searchLayer);
				
				mapLayer = new ObjectContainer3D();
				baseContainer.addChild(mapLayer);
				
				//				floorLayer = new ObjectContainer3D();
				//				baseContainer.addChild(floorLayer);
				initAreaLayer();
				
				initPointLight();
				changeRotationY(0);
			}
			PowerEngine.awayRenderEnabled = AwayEngine.cameraEnabled = true;
			Vision.shield();
			//			freeCamera.reset();
		}
		
		private function initAreaLayer():void
		{
			for (var i:int = 0; i < GameModel.areaCount; i++) 
			{
				var areaLayer:ObjectContainer3D = new ObjectContainer3D();
				mapLayer.addChild(areaLayer);
				createArea(areaLayer,i);//添加区域容器
			}
		}
		
		private function changeDirect(e:PadEvent):void
		{
			if(e.direct == GamePad.DIRECT_UP){
				//				AwayEngine.moveVertical(true);
				freeCamera.tiltAngle += 5;
			}else if(e.direct == GamePad.DIRECT_DOWN){
				//				AwayEngine.moveVertical(false);
				freeCamera.tiltAngle -= 5;
			}else if(e.direct == GamePad.DIRECT_LEFT){
				//				AwayEngine.moveHorizontal(true);
				freeCamera.panAngle -= 5;
			}else if(e.direct == GamePad.DIRECT_RIGHT){
				//				AwayEngine.moveHorizontal(false);
				freeCamera.panAngle += 5;
			}
		}
		
		private static var txt:TextField;
		private static function createText(label:String):BitmapData{
			if(txt == null){
				txt = new TextField();
				txt.defaultTextFormat = new TextFormat(null,90);
				txt.autoSize = TextFieldAutoSize.LEFT;
				//				txt.autoSize = TextFieldAutoSize.CENTER;
				//				txt.height = 80;
				//				txt.width = 50;
				//				txt.textColor = 0xFFFF00;
				//				txt.background = true;
				//				txt.backgroundColor = 0xFFFF00;
			}
			txt.text = label;
			var bd:BitmapData = new BitmapData(getNearValue(txt.width),getNearValue(txt.height),true,0);
			//							AssetManager.getSourceBd(getNearValue(txt.width),getNearValue(txt.height));
			bd.draw(txt);
			return bd;
		}
		
		private static var shape:Shape;
		private static function createCircle(color:uint = 0xFFFF00,alpha:Number = .5,size:Number = 2):BitmapData{
			if(shape == null){
				shape = new Shape();
			}
			shape.graphics.clear();
			shape.graphics.beginFill(color,alpha);
			shape.graphics.drawCircle(size,size,size);
			shape.graphics.endFill();
			var w:Number = getNearValue(shape.width);
			var h:Number = getNearValue(shape.height);
			
			var bd:BitmapData = new BitmapData(w,h,true,0);
			//							AssetManager.getSourceBd(getNearValue(txt.width),getNearValue(txt.height));
			bd.draw(shape/*,new Matrix(1,0,0,1,-(w - shape.width) / 2,-(h - shape.height) / 2)*/);
			return bd;
		}
		
		private static function getNearValue(w:Number):int{
			var base:int = 2;
			while(w > base){
				base *= 2;
			}
			return base;
		}
		private var cameraLight:PointLight;
		private function initPointLight():void
		{
			cameraLight = new PointLight();
			cameraLight.color = 0xEEEEEE;//
			//			cameraLight.ambient = .2;
			cameraLight.diffuse = 1.5;
			cameraLight.specular = 0.1;
			AwayEngine.addLight(cameraLight);
			//			AwayEngine.followCamera(onLightMove);
			if(freeCamera != null){
				freeCamera.setUpadeFuction(onLightMove);
			}
		}
		
		private function onLightMove(e:Event = null):void
		{
			cameraLight.position = AwayEngine.camera.position;
			var _view3D:View3D = AwayEngine.view3D;
			for each (var mesh:Mesh in tagMeshDic) 
			{
				mesh.lookAt(AwayEngine.camera.position/*.add(new Vector3D(0,_view3D.y,0))*/);
				//				if(mesh != selectTag){
				////					mesh.pitch(90);
				//					mesh.rotationX = -75;
				//				}else{
				//				}
				//				mesh.rotationX = 0;
				mesh.yaw(180);
				//				mesh.scenePosition
			}
		}
		
		private function clear():void{
			GameModel.clearDic(meshIndexDic);
			GameModel.clearDic(tagMeshDic);
			GameModel.clearDic(doorDic);
			
			clearMap();
			while(meshContainer.numChildren > 0){
				meshContainer.removeChildAt(meshContainer.numChildren - 1);
			}
			while(activeLayer.numChildren > 0){
				activeLayer.removeChildAt(activeLayer.numChildren - 1);
			}
		}
		
		public function loadModel(mesh:ObjectContainer3D,floor:int = 1):void
		{
			clear();
			nowFloor = floor;
			//			var floorContainer:ObjectContainer3D = new ObjectContainer3D();
			//			floorDic[floor] = floorContainer;
			//			floorContainer.addChild(mesh);
			meshContainer.addChild(mesh);
			//			meshContainer.addChild(floorContainer);
			//			floorContainer.mouseEnabled = false;
			var maxId:int = 0;
			for (i = 0; i < mesh.numChildren; i++) 
			{
				child = mesh.getChildAt(i) as Mesh;
				id = child.name.split("_")[1];
				if(id > maxId){
					maxId = id;
				}
			}
			for (var i:int = 0; i < mesh.numChildren; i++) 
			{
				var child:Mesh = mesh.getChildAt(i) as Mesh;
				var id:int = child.name.split("_")[1];
				var meshTag:String = child.name.split("_")[0];
				if(/*id == 1 || */id == maxId){
					var cm:ColorMaterial = new ColorMaterial(0xaaaaaa);
					//地面和楼梯无交互
				}else{
					cm = new ColorMaterial(0xe1dfe0);
					meshIndexDic[child] = child.name;//对应深度值
					child.mouseEnabled = true;
					child.pickingCollider = PickingColliderType.AUTO_FIRST_ENCOUNTERED;
					child.addEventListener(MouseEvent3D.MOUSE_DOWN,onMeshDown);
				}
				measure(child);
				//				trace(child.name);
				cm.lightPicker = AwayEngine.lightPicker;//应用光源
				child.material = cm;
				//				if(meshTag != "Floor")
				//					createTxtPlane(floorContainer,child,id,floor);
				var ivo:MeshInfoVo = GameModel.getMeshInfo(child.name);
				if(ivo != null){
					updateMesh(ivo,InfoScreen.getSelectColor(ivo.attribute));
				}
			}
			GameModel.minX = minX;
			GameModel.minZ = minZ;
			createClickPlane();
			//			onLightMove();
		}
		
		public function showMap():void{
			isEditMap = true;
			showNodePlane();
			clearNode();
			meshContainer.scaleY = .1;
			showRoad();
			var ep:PointVo = GameModel.earthNode;
			if(ep != null){
				doMapEarth(ep.x,ep.z,ep.area);
			}
			showDoor();
		}
		
		private var doorDic:Dictionary = new Dictionary(true);
		//key:nameID value:doorMesh
		/**
		 * 显示所有门的坐标
		 */		
		private function showDoor():void
		{
			var meshInfoList:Vector.<MeshInfoVo> = GameModel.meshInfoList;
			for each (var ivo:MeshInfoVo in meshInfoList) 
			{
				if(ivo.doorPos != null){
					doMapDoor(ivo.nameId,ivo.doorPos.x,ivo.doorPos.z,ivo.doorPos.area);
				}
			}
		}
		
		private var _mapType:int = GameModel.MAP_TYPE_EARTH;//设置地标
		public function setMapType(value:int):void{
			_mapType = value;
		}
		
		private function showRoad():void
		{
			clearMap();
			for (var area:int = 0; area < GameModel.areaCount; area++) 
			{
				var mapList:Vector.<Vector.<int>> = GameModel.getMapList(area);
				if(mapList == null){
					trace(area + "::区域地图数据还未创建");
					continue;
				}
				for (var i:int = 0; i < GameModel.mapRows; i++) 
				{
					for (var j:int = 0; j < GameModel.mapCols; j++) 
					{
						if(mapList[i][j] == 0){
							addRoadMesh(i,j,area);
						}
					}
				}
			}
		}
		
		public function hideMap():void{
			isEditMap = false;
			hideNodePlane();
			clearMap();
			meshContainer.scaleY = 1;
		}
		
		public function showNodePlane():void{
			activeLayer.visible = true;
		}
		
		public function hideNodePlane():void{
			if(activeLayer != null)
				activeLayer.visible = false;
		}
		public var nodeId:int;//设备节点id
		/**
		 * 显示设备的节点坐标
		 * @param nodeId
		 */		
		public function showEquipNode(nodeId:int):void{
			this.nodeId = nodeId;
			var nodeList:Vector.<PointVo> = GameModel.getNodeList(nodeId);
			clearNode();
			if(nodeList != null){
				createNodeList(nodeList);
			}
		}
		
		private function createNodeList(nodeList:Vector.<PointVo>):void
		{
			for (var i:int = 0; i < nodeList.length; i++) 
			{
				var pvo:PointVo = nodeList[i];
				var mesh:Mesh = createNodePlane(pvo.x,pvo.z,pvo);
				activeLayer.addChild(mesh);
			}
		}
		/**
		 * 清除寻路的视图
		 */		
		private function clearSearch():void{
			for (var i:int = 0; i < GameModel.areaCount; i++) 
			{
				if(i < mapLayer.numChildren){
					var areaLayer:ObjectContainer3D = mapLayer.getChildAt(i);
					var searchLayer:ObjectContainer3D = getKeyLayer(i,searchKey);
					clearChildren(searchLayer);
				}
			}
		}
		/**
		 * 清除地图视图
		 */
		private function clearMap():void
		{
			clearSearch();
			for (var i:int = 0; i < GameModel.areaCount; i++) 
			{
				var roadLayer:ObjectContainer3D = getKeyLayer(i,roadKey);
				clearChildren(roadLayer);
				var floorLayer:ObjectContainer3D = getKeyLayer(i,floorKey);
				clearChildren(floorLayer);
			}
		}
		
		private function clearNode():void
		{
			if(activeLayer == null)return;
			for (var i:int = activeLayer.numChildren - 1; i >= 0; i--) 
			{
				var child:ObjectContainer3D = activeLayer.getChildAt(i) as ObjectContainer3D;
				if(child is PointMesh){
					activeLayer.removeChild(child);
				}
				//				if(child.name != ACTIVE_NAME){
				//					activeLayer.removeChild(child);
				//				}
			}
		}
		private static const ACTIVE_NAME:String = "activeFloor";
		private static var size:Number = 2;//.5;//每个plane的尺寸
		private var activeMesh:Mesh;//交互层模型
		//		private var sceneRotationY:Number = 6.8;//45;//整体旋转
		//		private function changeRotation():void{
		//			activeLayer.rotationY = mapLayer.rotationY = searchLayer.rotationY = 
		//				floorLayer.rotationY = sceneRotationY;
		//		}
		public function changeRotationY(rotationY:Number):void
		{
			var areaLayer:ObjectContainer3D = mapLayer.getChildAt(selectArea);
			activeLayer.rotationY = areaLayer.rotationY =/*mapLayer.rotationY =*/ /*searchLayer.rotationY = 
				floorLayer.rotationY =*/ rotationY;
		}
		
		private var selectArea:int;//当前选中的区域值
		/**
		 * 改变显示区域
		 * @param area 区域值
		 */		
		public function changeArea(area:int):void{
			selectArea = area;
			if(_mapType == GameModel.MAP_TYPE_LINK){
				showLinkInfo();
			}
		}
		
		private function createClickPlane():void
		{
			var dirtX:Number = maxX - minX;
			var dirtZ:Number = maxZ - minZ;
			
			var xCount:int = Math.ceil(dirtX / size);
			var zCount:int = Math.ceil(dirtZ / size);
			
			for (var i:int = 0; i < GameModel.areaCount; i++){
				GameModel.createMap(xCount,zCount,i);//预先添加好所有的地图数据
				var areaLayer:ObjectContainer3D = mapLayer.getChildAt(i);
				areaLayer.rotationY = GameModel.getRotationY(i);
			}
			var plane:PlaneGeometry = new PlaneGeometry(xCount * size,zCount * size);
			activeMesh = new Mesh(plane,new ColorMaterial(0xFF0000,.3));
			activeMesh.name = ACTIVE_NAME;
			activeMesh.x = minX + plane.width / 2;
			activeMesh.z = minZ + plane.height / 2;
			activeMesh.y = 20;
			activeLayer.addChild(activeMesh);
			activeMesh.mouseEnabled = true;
			activeMesh.addEventListener(MouseEvent3D.MOUSE_DOWN,onPlaneDown);
			activeMesh.addEventListener(MouseEvent3D.MOUSE_MOVE,onPlaneRoll);
		}
		
		private var offSetX:Number = -11;//-10;//万寿亭偏移数据
		private var offSetZ:Number = 11;//14;
		private var rollMesh:Mesh;
		private function onPlaneRoll(e:MouseEvent3D):void
		{
			if(!_enabled)return;//不能交互
			var x:Number = e.localPosition.x + offSetX;
			var z:Number = e.localPosition.z + offSetZ;
			var indexX:int = (x - minX) / size;
			var indexZ:int = (z - minZ) / size;
			//			createRoadMesh(indexX,indexZ);
			if(rollMesh == null){
				rollMesh = new Mesh(roadPlane,AwayEngine.getColorMaterial(0xFFFF00));
			}
			rollMesh.x = indexX * size + minX;//+ size / 2;
			rollMesh.z = indexZ * size + minZ;// - size;
			rollMesh.y = 3;
			var roadLayer:ObjectContainer3D = getKeyLayer(selectArea,roadKey);
			roadLayer.addChild(rollMesh);
			//			var p:Vector3D = rollMesh.scenePosition;
			////			freeCamera.cameraPoint = new Vector3D(rollMesh.x,freeCamera.cameraPoint.y,rollMesh.z);
			//			freeCamera.cameraPoint = new Vector3D(p.x,freeCamera.cameraPoint.y,p.z);
		}		
		
		private function onPlaneMove(e:MouseEvent3D):void
		{
			if(!_enabled)return;//不能交互
			var x:Number = e.localPosition.x + offSetX;
			var z:Number = e.localPosition.z + offSetZ;
			var indexX:int = (x - minX) / size;
			var indexZ:int = (z - minZ) / size;
			createRoadMesh(indexX,indexZ,selectArea);
		}
		private static var roadPlane:PlaneGeometry = new PlaneGeometry(size,size);//路点模型
		private static var roadDic:Dictionary = new Dictionary(true);
		private function createRoadMesh(indexX:Number,indexZ:Number,area:int):void{
			//			trace("indexX:" + indexX,"indexZ:" + indexZ);
			if(editType != GameModel.getRoadValue(indexX,indexZ,area)){
				GameModel.setRoadValue(indexX,indexZ,editType,area);//设置数据
				if(editType == 0){//添加
					addRoadMesh(indexX,indexZ,area);
				}else{//删除
					var m:Mesh = roadDic[indexX + "_" + indexZ + "_" + area];
					if(m != null && m.parent != null){
						m.parent.removeChild(m);
						delete roadDic[indexX + "_" + indexZ + "_" + area];
					}
				}
			}
		}
		
		private function addRoadMesh(indexX:int,indexZ:int,area:int):void{
			var m:Mesh = new Mesh(roadPlane,AwayEngine.getColorMaterial(0xFFCC00));
			//					m.pivotPoint = new Vector3D(size / 2,0,size / 2);
			var roadLayer:ObjectContainer3D = getKeyLayer(area,roadKey);
			roadLayer.addChild(m);
			m.x = indexX * size + minX;//+ size / 2;
			m.z = indexZ * size + minZ;// - size;
			m.y = 2;
			//			trace("添加 indexX:" + indexX,"indexZ:" + indexZ);
			roadDic[indexX + "_" + indexZ + "_" + area] = m;
		}
		
		private var isEditMap:Boolean = false;//编辑地图
		private var editType:int;//编辑类型 0表示设置路点 1表示删除路点
		private function onPlaneDown(e:MouseEvent3D):void
		{
			if(!_enabled)return;//不能交互
			var x:Number = e.localPosition.x + offSetX;
			var z:Number = e.localPosition.z + offSetZ;
			if(isEditMap){
				AwayEngine.stopCamera();
				var indexX:int = (x - minX) / size;
				var indexZ:int = (z - minZ) / size;
				if(_mapType == GameModel.MAP_TYPE_EARTH){
					doMapEarth(indexX,indexZ,selectArea);
				}else if(_mapType == GameModel.MAP_TYPE_MESH){
					doMapMesh(indexX,indexZ,selectArea);
				}else if(_mapType == GameModel.MAP_TYPE_TEST){
					doMapSearch(indexX,indexZ,selectArea);
				}else if(_mapType == GameModel.MAP_TYPE_DOOR){
					if(selectMesh != null){
						doMapDoor(selectMesh.name,indexX,indexZ,selectArea,true);
					}
				}else if(_mapType == GameModel.MAP_TYPE_FLOOR){
					if(editFloorNode != null){
						moveFloorNode(indexX,indexZ,selectArea);
					}else{
						doMapFloor(null,indexX,indexZ,selectArea);
					}
				}else if(_mapType == GameModel.MAP_TYPE_LINK){
					if(editFloorNode != null){
						moveFloorNode(indexX,indexZ,selectArea);
					}else{
						doMapLink(null,indexX,indexZ,selectArea);
					}
				}
			}else{//添加设施
				var pvo:PointVo = GameModel.addNode(nodeId,x,z);
				var mesh:Mesh = createNodePlane(x,z,pvo);
				//			mesh.x = ;//minX + plane.width / 2;
				//			mesh.z = ;//minZ + plane.height / 2;
				activeLayer.addChild(mesh);
			}
		}
		
		private var _floorPoint:PointVo;//门的坐标
		public function get floorPoint():PointVo
		{
			return _floorPoint;
		}
		
		private function moveFloorNode(indexX:int, indexZ:int, area:int):void
		{
			if(_floorPoint == null)_floorPoint = new PointVo(0,0,-1);
			_floorPoint.x = indexX;
			_floorPoint.z = indexZ;
			_floorPoint.area = area;
			editFloorNode.x = indexX * size + minX;
			editFloorNode.z = indexZ * size + minZ;
//			editFloorNode.addPoint(indexX,indexZ,area);
			var floorLayer:ObjectContainer3D = getKeyLayer(area,floorKey);
			floorLayer.addChild(editFloorNode);
		}
		
		//创建楼梯通道数据
		private function doMapFloor(floorId:String,indexX:int, indexZ:int,area:int):void
		{
			var fvo:FloorInfoVo = GameModel.updateFloorInfo(floorId,indexX,indexZ,area);
			var floorMesh:Mesh = createFloorNode(fvo.id,indexX,indexZ,area);
			var floorLayer:ObjectContainer3D = getKeyLayer(area,floorKey);
			floorLayer.addChild(floorMesh);
			if(floorClick != null && floorId == null)floorClick(fvo.id);
			//floorId 为 null 表示添加
		}
		
		public function showFloorInfo():void{
			var fList:Vector.<FloorInfoVo> = GameModel.floorList;
			for each (var fvo:FloorInfoVo in fList) 
			{
				doMapFloor(fvo.id,fvo.postion.x,fvo.postion.z,fvo.postion.area);
			}
		}
		
		public function hideFloorInfo():void{
			for (var i:int = 0; i < GameModel.areaCount; i++) 
			{
				var floorLayer:ObjectContainer3D = getKeyLayer(i,floorKey);
				clearChildren(floorLayer);
			}
		}
		
		public function editLinkInfo(linkId:String,area:int):void{
			editFloorNode = getLinkMeshByName(linkId,area);
		}
		/**
		 * 恢复到原来位置
		 */		
		public function resetLink():void{
			if(editFloorNode != null){
				var lvo:LinkInfoVo = GameModel.getLinkInfo(editFloorNode.name,editFloorNode.point.area);
				if(lvo != null){
					editFloorNode.x = lvo.postion.x * size + minX;
					editFloorNode.z = lvo.postion.z * size + minZ;
					var floorLayer:ObjectContainer3D = getKeyLayer(lvo.postion.area,floorKey);
					floorLayer.addChild(editFloorNode);//添加到目标容器中
				}
			}
			editFloorNode = null;
			_floorPoint = null;
		}
		
		public function showLinkInfo():void{
			hideFloorInfo();
			var lList:Vector.<LinkInfoVo> = GameModel.linkList;
			for each (var lvo:LinkInfoVo in lList) 
			{
				if(lvo.postion.area == selectArea){
					doMapLink(lvo.id,lvo.postion.x,lvo.postion.z,lvo.postion.area);
				}
			}
		}
		
		private function doMapLink(linkId:String, indexX:int, indexZ:int, area:int):void
		{
			var lvo:LinkInfoVo = GameModel.updateLinkInfo(linkId,indexX,indexZ,area);
			var linkMesh:PointMesh = createLinkNode(lvo.id,indexX,indexZ,area);
			var floorLayer:ObjectContainer3D = getKeyLayer(area,floorKey);
			floorLayer.addChild(linkMesh);
			if(floorClick != null && linkId == null)floorClick(lvo.id,area);
			//floorId 为 null 表示添加
		}
		
		private var editFloorNode:PointMesh;
		public function editFloorInfo(floorId:String):void{
			editFloorNode = getFloorMeshByName(floorId);
		}
		/**
		 * 恢复到原来位置
		 */		
		public function resetFloor():void{
			if(editFloorNode != null){
				var fvo:FloorInfoVo = GameModel.getFloorInfo(editFloorNode.name);
				if(fvo != null){
					editFloorNode.x = fvo.postion.x * size + minX;
					editFloorNode.z = fvo.postion.z * size + minZ;
					var floorLayer:ObjectContainer3D = getKeyLayer(fvo.postion.area,floorKey);
					floorLayer.addChild(editFloorNode);//添加到目标容器中
				}
			}
			editFloorNode = null;
			_floorPoint = null;
		}
		
		public function removeFloor(floorId:String):void{
			var floorMesh:Mesh = getFloorMeshByName(floorId);
			if(floorMesh != null && floorMesh.parent != null)
				floorMesh.parent.removeChild(floorMesh);
		}
		
		public function removeLink(linkId:String, area:int):void
		{
			var linkMesh:Mesh = getLinkMeshByName(linkId,area);
			if(linkMesh != null && linkMesh.parent != null)
				linkMesh.parent.removeChild(linkMesh);
		}
		/**
		 * @param floorId 楼层数据必须唯一
		 * @return 
		 */		
		private function getFloorMeshByName(floorId:String):PointMesh{
			for (var area:int = 0; area < GameModel.areaCount; area++) 
			{
				var floorLayer:ObjectContainer3D = getKeyLayer(area,floorKey);
				for (var i:int = floorLayer.numChildren - 1; i >= 0; i--) 
				{
					var floorMesh:PointMesh = floorLayer.getChildAt(i) as PointMesh;
					if(floorMesh.name == floorId){
						return floorMesh;//删除掉
					}
				}
			}
			return null;
		}
		
		private function getLinkMeshByName(floorId:String,area:int):PointMesh{
			var floorLayer:ObjectContainer3D = getKeyLayer(area,floorKey);
			for (var i:int = floorLayer.numChildren - 1; i >= 0; i--) 
			{
				var floorMesh:PointMesh = floorLayer.getChildAt(i) as PointMesh;
				if(floorMesh.name == floorId){
					if(floorMesh.point != null && floorMesh.point.area == area){
						return floorMesh;//删除掉
					}
				}
			}
			return null;
		}
		
		private function createFloorNode(floorId:String,indexX:int, indexZ:int, area:int):PointMesh
		{
			var bd:BitmapData = createCircle(COLOR_LIST[COLOR_LIST.length - 1],1,size * 2);
			var m:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(bd));
			//			m.alphaBlending = true;
			var floorMesh:PointMesh = new PointMesh(nodePlane,m);
			floorMesh.name = floorId;
			floorMesh.y = 25;
			floorMesh.x = indexX * size + minX;
			floorMesh.z = indexZ * size + minZ;
			floorMesh.point = new PointVo(indexX,indexZ,area);
			//			mesh.name = index + '';
			floorMesh.mouseEnabled = true;
			floorMesh.addEventListener(MouseEvent3D.MOUSE_DOWN,onFloorMeshDown);
			return floorMesh;
		}
		
		private function createLinkNode(linkId:String,indexX:int, indexZ:int, area:int):PointMesh
		{
			var bd:BitmapData = createCircle(COLOR_LIST[0],1,size);
			var m:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(bd));
			//			m.alphaBlending = true;
			var linkMesh:PointMesh = new PointMesh(nodePlane,m);
			linkMesh.name = linkId;
			linkMesh.y = 25;
			linkMesh.x = indexX * size + minX;
			linkMesh.z = indexZ * size + minZ;
			linkMesh.point = new PointVo(indexX,indexZ,area);
			//			mesh.name = index + '';
			linkMesh.mouseEnabled = true;
			linkMesh.addEventListener(MouseEvent3D.MOUSE_DOWN,onFloorMeshDown);
			return linkMesh;
		}
		
		private function onFloorMeshDown(e:MouseEvent3D):void
		{
			if(isEditMap){
				if(_mapType == GameModel.MAP_TYPE_FLOOR){
					//编辑楼道
					var floorId:String = e.currentTarget.name;
					if(floorClick != null && floorId != null)floorClick(floorId);
				}else if(_mapType == GameModel.MAP_TYPE_LINK){
					//编辑关节点
					var linkMesh:PointMesh = e.currentTarget as PointMesh;
					var linkId:String = linkMesh.name;
					var linkArea:int = linkMesh.point.area;
					if(floorClick != null && linkId != null)floorClick(linkId,linkArea);
				}
			}
		}		
		
		//		private var doorNode:Mesh;//显示门的Mesh
		private var _doorPoint:PointVo;//门的坐标
		public function get doorPoint():PointVo
		{
			return _doorPoint;
		}
		/**
		 * 清除门的相关设置
		 */		
		//		public function clearDoor():void{
		////			if(doorNode != null && doorNode.parent == mapLayer){
		////				mapLayer.removeChild(doorNode);
		////			}
		//		}
		/**
		 * 恢复门的坐标
		 */		
		public function resetDoor():void{
			if(selectMesh != null){
				var ivo:MeshInfoVo = GameModel.getMeshInfo(selectMesh.name);
				if(ivo != null && ivo.doorPos != null){
					doMapDoor(selectMesh.name,ivo.doorPos.x,ivo.doorPos.z,ivo.doorPos.area);
				}
			}
			_doorPoint = null;
		}
		/**
		 * 显示商户门口位置的坐标
		 */		
		private function doMapDoor(nameId:String,indexX:int, indexZ:int,area:int, isSelect:Boolean = false):void
		{
			var roadLayer:ObjectContainer3D = getKeyLayer(area,roadKey);
			if(roadLayer == null)return;
			if(doorDic[nameId] != null){
				var doorNode:Mesh = doorDic[nameId];
			}else{
				doorNode = new Mesh(roadPlane,AwayEngine.getColorMaterial(0x22FFFF));
				doorNode.y = 7;
				doorDic[nameId] = doorNode;//记录数据
			}
			if(isSelect){
				doorNode.material = AwayEngine.getColorMaterial(0xFFFFEE);
			}else{
				doorNode.material = AwayEngine.getColorMaterial(0x22FFFF);
			}
			roadLayer.addChild(doorNode);
			doorNode.x = indexX * size + minX;
			doorNode.z = indexZ * size + minZ;
			if(_doorPoint == null)_doorPoint = new PointVo(0,0,area);
			_doorPoint.x = indexX;
			_doorPoint.z = indexZ;
			_doorPoint.area = area;
		}
		
		private var earthNode:Mesh;
		/**
		 * 设置地标
		 * @param indexX
		 * @param indexZ
		 */		
		private function doMapEarth(indexX:int, indexZ:int, area:int):void
		{
			if(earthNode == null){
				var p:PlaneGeometry = new PlaneGeometry(size * 2,size * 2);
				earthNode = new Mesh(p,AwayEngine.getColorMaterial(0x0000FF));
				earthNode.y = 5;
			}
			var roadLayer:ObjectContainer3D = getKeyLayer(area,roadKey);
			roadLayer.addChild(earthNode);
			earthNode.x = indexX * size + minX;
			earthNode.z = indexZ * size + minZ;
			GameModel.setEarthNode(indexX,indexZ,area);
		}
		/**
		 * 开始寻路
		 * @param indexX
		 * @param indexZ
		 */		
		public function doMapSearch(indexX:int, indexZ:int,area:int):void
		{
			var ep:PointVo = GameModel.earthNode;
			if(ep == null){
				trace("对不起，请先设置地标才可以寻路");
				return;
			}
			var v:Vector.<PointVo> = GameUtil.searchRoad(indexX,indexZ,area,ep);
//				GameUtil.search(ep.x,ep.z,indexX,indexZ,area);
			//
			clearSearch();
//			var area:int = selectArea;//-111;
			for each (var pvo:PointVo in v) 
			{
				var searchLayer:ObjectContainer3D = getKeyLayer(pvo.area,searchKey);
				var mesh:Mesh = new Mesh(roadPlane,AwayEngine.getColorMaterial(0xFF0000));
				searchLayer.addChild(mesh);
				mesh.x = pvo.x * size + minX;
				mesh.z = pvo.z * size + minZ;
				mesh.y = 6;
				TweenLite.from(mesh,.2,{delay:.05 * v.indexOf(pvo),scaleX:0,scaleZ:0});
			}
		}
		/**
		 * 地图路点设置
		 * @param indexX
		 * @param indexZ
		 * @param area
		 */		
		private function doMapMesh(indexX:int, indexZ:int, area:int):void
		{
			editType = GameModel.getRoadValue(indexX,indexZ,area) == 0 ? 1 : 0;
			createRoadMesh(indexX,indexZ,area);
			activeMesh.addEventListener(MouseEvent3D.MOUSE_MOVE,onPlaneMove);
			Vision.stage.addEventListener(MouseEvent.MOUSE_UP,onStageUp);
		}
		
		private function onStageUp(e:MouseEvent):void
		{
			activeMesh.removeEventListener(MouseEvent3D.MOUSE_MOVE,onPlaneMove);
			Vision.stage.removeEventListener(MouseEvent.MOUSE_UP,onStageUp);
		}
		
		private static var nodePlane:PlaneGeometry = new PlaneGeometry(size * 4,size * 4);
		private static const COLOR_LIST:Array = [0xe15757,0x50b5e1,0x019e97,0x39b44a,0xd17302,0x8ed3f0,0xd2bd0a];
		private function createNodePlane(x:Number,z:Number,pvo:PointVo):PointMesh{
			var bd:BitmapData = createCircle(COLOR_LIST[nodeId],1,size * 2);
			var m:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(bd));
			//			m.alphaBlending = true;
			var mesh:PointMesh = new PointMesh(nodePlane,m);
			mesh.point = pvo;
			mesh.y = 25;
			mesh.x = x;
			mesh.z = z;
			//			mesh.name = index + '';
			mesh.mouseEnabled = true;
			mesh.addEventListener(MouseEvent3D.MOUSE_DOWN,onPlaneDispose);
			return mesh;
		}
		
		private function onPlaneDispose(e:MouseEvent3D):void
		{
			var mesh:PointMesh = e.currentTarget as PointMesh;
			if(mesh.parent != null){
				mesh.parent.removeChild(mesh);
			}
			GameModel.removeNode(nodeId,mesh.point);
		}
		
		private var minX:Number = 1000;
		private var maxX:Number = -1000;
		private var minZ:Number = 1000;
		private var maxZ:Number = -1000;
		private function measure(p:Mesh):void{
			if(minX > p.x + p.minX){
				minX = p.x + p.minX;
			}
			if(minZ > p.z + p.minZ){
				minZ = p.z + p.minZ;
			}
			if(maxX < p.x + p.maxX){
				maxX = p.x + p.maxX;
			}
			if(maxZ < p.z + p.maxZ){
				maxZ = p.z + p.maxZ;
			}
		}
		private function updateTxtPlane(p:Mesh,number:String):void
		{
			var bd:BitmapData = createText(number);
			var m:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(bd));
			m.alphaBlending = true;
			m.smooth = true;
			if(tagMeshDic[p] == null){
				var pe:PlaneGeometry = new PlaneGeometry(10,10,1,1,false);
				var tag:Mesh = new Mesh(pe,m);//创建网格容器
				var b:AxisAlignedBoundingBox = p.bounds as AxisAlignedBoundingBox;
				//				mesh.scaleX = mesh.scaleZ = .5;
				//			mesh.scaleY = 2;
				tag.x = p.x + b.centerX;
				tag.z = p.z + b.centerZ;
				tag.y = p.y + b.centerY + 12;
				meshContainer.addChild(tag);
				tagMeshDic[p] = tag;
				showTag(tag,b);
			}else{
				tag = tagMeshDic[p];
				tag.material = m;//替换皮肤
			}
		}
		
		private var meshClick:Function;//点中商铺mesh后回调
		//回调的时候输出自己的深度索引值
		public function addMeshClick(func:Function):void{
			meshClick = func;
		}
		
		private var floorClick:Function;//点中楼层数据后回调
		public function addFloorClick(func:Function):void{
			floorClick = func;
		}
		
		private function getMeshFromIndex(nameId:String):Mesh{
			for (var key:* in meshIndexDic) 
			{
				if(meshIndexDic[key] == nameId){
					return key;
				}
			}
			return null;
		}
		//让店铺模型的深度值和vo索引值关联在一块
		public function updateMesh(ivo:MeshInfoVo,color:uint):void{
			var p:Mesh = getMeshFromIndex(ivo.nameId);
			if(p != null){
				var cm:ColorMaterial = p.material as ColorMaterial;
				if(cm != null){
					cm.color = color;
				}
				updateTxtPlane(p,ivo.number);
				onLightMove();
			}
		}
		
		public function resetMesh(nameId:String):void{
			var p:Mesh = getMeshFromIndex(nameId);
			if(p != null){
				var cm:ColorMaterial = p.material as ColorMaterial;
				if(cm != null){
					cm.color = 0xe1dfe0;
				}
				var tag:Mesh = tagMeshDic[p];
				if(tag != null && tag.parent == meshContainer){
					meshContainer.removeChild(tag);
				}
			}
		}
		
		private var _enabled:Boolean = true;//是否能交互
		public function get enabled():Boolean
		{
			return _enabled;
		}
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			if(value){
				freeCameraControl.open();
			}else{
				freeCameraControl.close();
			}
		}
		
		private var selectMesh:Mesh;
		private function onMeshDown(e:MouseEvent3D):void
		{
			if(!_enabled)return;//不能交互
			var newMesh:Mesh = e.currentTarget as Mesh;
			if(meshIndexDic[newMesh] !== undefined && meshClick != null){
				meshClick(meshIndexDic[newMesh]);
				lookMesh(newMesh);
			}
		}
		
		private function lookMesh(newMesh:Mesh):void{
			if(selectMesh != newMesh){
				if(selectMesh != null){
					TweenLite.to(selectMesh,.3,{scaleY:1});
				}
				TweenLite.to(newMesh,.3,{scaleY:3});
				selectMesh = newMesh;
				var tag:Mesh = tagMeshDic != null ? tagMeshDic[newMesh] : null;
				if(tag != null){
					var b:AxisAlignedBoundingBox = newMesh.bounds as AxisAlignedBoundingBox;
					showTag(tag,b);
				}
			}
		}
		private var preY:Number;
		private var selectTag:Mesh;
		
		private function showTag(tag:Mesh,b:AxisAlignedBoundingBox):void{
			if(tag != selectTag){
				if(selectTag != null){
					TweenLite.killTweensOf(selectTag);
					//					(selectTag.material as TextureMaterial).ambientColor = 0xFF0000;
					selectTag.scaleX = selectTag.scaleZ = 1;
					selectTag.scaleY = .5;
					selectTag.y = preY;
					//					selectTag.y = b.centerY + 15;
				}
				//				(tag.material as TextureMaterial).ambientColor = 0xFF0000;
				selectTag = tag;
				selectTag.scaleX = selectTag.scaleZ = 2;
				selectTag.scaleY = 1;
				preY = tag.y;
				selectTag.y = b.centerY + 12;
				tweenTagUp(tag);
			}
		}
		
		private function tweenTagUp(tag:Mesh):void
		{
			TweenLite.to(tag,.5,{y:tag.y + 2,onComplete:tweenTagDown,onCompleteParams:[tag]});
		}	
		
		private function tweenTagDown(tag:Mesh):void
		{
			TweenLite.to(tag,.5,{y:tag.y - 2,onComplete:tweenTagUp,onCompleteParams:[tag]});
		}
	}
}
import com.vo.PointVo;

import away3d.core.base.Geometry;
import away3d.entities.Mesh;
import away3d.materials.MaterialBase;

class PointMesh extends Mesh{
	
	public function PointMesh(geometry : Geometry, material : MaterialBase = null)
	{
		super(geometry,material);
	}
	public var point:PointVo;
	public function addPoint(indexX:int,indexZ:int,area:int):void{
		if(point == null){
			point = new PointVo(0,0,-1);
		}
		point.x = indexX;
		point.z = indexZ;
		point.area = area;
	}
	
}
