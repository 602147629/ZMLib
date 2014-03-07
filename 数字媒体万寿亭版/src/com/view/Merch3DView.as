package com.view
{
	import com.control.FreeCamera3D;
	import com.control.FreeCameraControl;
	import com.engine.AwayEngine;
	import com.engine.PowerEngine;
	import com.greensock.TweenLite;
	import com.manager.Vision;
	import com.model.FarmDataBase;
	import com.model.MerchModel;
	import com.utils.GameUtil;
	import com.utils.PowerLoader;
	import com.vo.FloorInfoVo;
	import com.vo.MerchVo;
	import com.vo.MeshInfoVo;
	import com.vo.PointVo;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
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
	
	import starling.utils.AssetManager;
	
	public class Merch3DView
	{
		private static var merch3DView:Merch3DView;
		public static function getInstance():Merch3DView{
			if(merch3DView == null)merch3DView = new Merch3DView();
			return merch3DView;
		}
		//		private var zoom:ZoomGesture;
		public function show(isReset:Boolean = false):void{
			initFace();
			tweenShow();
			var floorContainer:FloorContainer = floorDic[nowFloor];
			if(floorContainer != null){
				floorContainer.moveFade();
			}
			MerchStateUI.getInstance().show();
			//			if(zoom == null){
			//				zoom = new ZoomGesture(Vision.staringStage);
			//			}
			//			zoom.addEventListener(GestureEvent.GESTURE_CHANGED, onGesture);
			Vision.addTouchEvent(onGesture);
			if(isReset && freeCameraControl != null){
				freeCameraControl.reset();
			}
			//			Vision.stage.addEventListener(TransformGestureEvent.GESTURE_ZOOM, onGesture);
		}
		//		private static var tempText:TextField;
		private function onGesture(scale:int):void
		{
			//			if(tempText == null){
			//				tempText = new TextField();
			//				tempText.width = Vision.senceWidth;
			//				tempText.height = Vision.senceHeight;
			//				tempText.wordWrap = true;
			//				tempText.multiline = true;
			//				tempText.textColor = 0xFFFF00;
			//				tempText.mouseEnabled = false;
			//				tempText.border = true;
			//				Vision.stage.addChild(tempText);
			//			}
			//			tempText.appendText("zoom变换 scaleX:" + zoom.scaleX + "   scaleY:" + zoom.scaleY + "\n");
			//			tempText.scrollV = tempText.maxScrollV;
			//			AwayEngine.stopCamera();//临时停止旋转
			if(scale > 0){
				//				AwayEngine.zoomCamera(true);
				freeCameraControl.zoomCamera(true);
			}else if(scale < 0){
				//				AwayEngine.zoomCamera(false);
				freeCameraControl.zoomCamera(false);
			}
			
			//注:最后一定scaleX:1
		}
		
		public function hide():void{
			if(floorOne != null){
				tweenHide();
				Vision.unShield();
				MerchStateUI.getInstance().hide();
				//				zoom.removeEventListener(GestureEvent.GESTURE_CHANGED, onGesture);
				Vision.addTouchEvent(null);
				clearPrevFloor();
			}
		}
		private var preFloor:int;//前一层的索引值
		private var nowFloor:int;
		/**
		 * 显示楼层
		 */		
		public function showFloor(floor:int,isStack:Boolean = false,onComplete:Function = null,
								  args:Array = null):void{
			if(!isStack){
				clearStack();//不是堆栈间接调用 清除堆栈
			}
			clearSearch(floor);
			if(floor == nowFloor){
				if(onComplete != null)args != null ? onComplete.apply(null,args) : onComplete();
				return;//已经是当前层
			}
			clearPrevFloor();//清除前面的状态
			preFloor = nowFloor;
			nowFloor = floor;//现在的楼层
			MerchStateUI.getInstance().checkSelectFloor(floor);//同步显示图标
			if(floorDic[floor] == null){
				createFloor(floor,tabFloor,[floor,onComplete,args]);
			}else{
				tabFloor(floor,onComplete,args);
				var nodeList:Vector.<PointVo> = MerchModel.getNodeList(floor,nodeId);
				createNodeList(floor,nodeId,nodeList);
			}
		}
		
		private function clearStack():void{
			statckList.length = 0;//停止堆栈连续调用
		}
		
		private function clearPrevFloor():void
		{
			var floorContainer:FloorContainer = floorDic[nowFloor];
			if(floorContainer != null){
				floorContainer.stopFade();
				clearSelectMesh(nowFloor);
//				clearSelectTag();
				//				clearSearch();
			}
		}
		
		private function tabFloor(floor:int,
								  onComplete:Function = null,args:Array = null):void
		{
			var floorContainer:ObjectContainer3D = floorDic[floor];
			if(floorContainer == null || floorOne == null){
				trace("该层还未初始化");
				return;
			}
			if(floorOne.numChildren > 0){
				var preContainer:ObjectContainer3D = floorOne.getChildAt(0);
				floorTwo.addChild(preContainer);
				//				tweenDispear();
			}
			floorOne.addChild(floorContainer);
			onLightMove();
			transition(onComplete,args);
		}
		private static var baseY:Number = 0;//2;
		private function transition(onComplete:Function = null,args:Array = null):void{
			if(preFloor == nowFloor)return;//无需转换
			var para:Number = 4 * Vision.heightScale;
			if(preFloor < nowFloor){
				floorTwo.y = 0;
				floorOne.y = Vision.senceHeight / para;
				TweenLite.to(floorOne,1,{y:baseY});
				TweenLite.to(floorTwo,1,{y:baseY - Vision.senceHeight / para,
					onComplete:disposeObj,onCompleteParams:[floorTwo,onComplete,args]});
			}else{
				floorTwo.y = 0;
				floorOne.y = -Vision.senceHeight / para;
				TweenLite.to(floorOne,1,{y:baseY});
				TweenLite.to(floorTwo,1,{y:baseY + Vision.senceHeight / para,
					onComplete:disposeObj,onCompleteParams:[floorTwo,onComplete,args]});
			}
		}
		
		private function disposeObj(contain:ObjectContainer3D,
									onComplete:Function = null,args:Array = null):void{
			while(contain.numChildren > 0){
				contain.removeChildAt(0);
			}
			if(onComplete != null)args != null ? onComplete.apply(null,args) : onComplete();
		}
		
		private static const nameKey:String = "wanshouting";
		private function createXmlData(floor:int):void
		{
			PowerLoader.loadUrl(new URLRequest("assets/meshs/" + nameKey + "F" + floor + ".xml"),
				URLLoaderDataFormat.TEXT,loadXml,floor);
		}
		
		private function createFloor(floor:int,onComplete:Function = null,
									 args:Array = null):void{
			initFloorContainer(floor);
			PowerLoader.loadFile("assets/meshs/" + nameKey + "F" + floor + ".3ds",
				loadModel,floor,onComplete,args);
			PowerLoader.loadFile("assets/meshs/merchF" + floor + ".3ds",loadMerch,floor);
		}
		
		private var loadComplete:Function;
		public function loadFloorData(onComplete:Function):void{
			loadComplete = onComplete;
			for each (var fdata:Object in MerchModel.FLOOR_DATA) 
			{
				createXmlData(fdata.floor);
			}
			PowerLoader.addCompleteEvent(floorDataComplete);
		}
		
		private function floorDataComplete(e:Event):void
		{
			PowerLoader.removeCompleteEvent(floorDataComplete);
			if(loadComplete != null)loadComplete();
		}
		
		private function initFloorContainer(floor:int):void{
			if(floorDic[floor] == null){
				floorDic[floor] = new FloorContainer();
			}
		}
		
		private function loadXml(data:String,floor:int):void
		{
			MerchModel.addXml(floor,XML(data));
		}
		public var nodeId:int;//设备节点id
		/**
		 * 显示设备的节点坐标
		 * @param nodeId
		 */		
		public function showEquipNode(nodeId:int):void{
			this.nodeId = nodeId;
			var nodeList:Vector.<PointVo> = MerchModel.getNodeList(nowFloor,nodeId);
			createNodeList(nowFloor,nodeId,nodeList);
		}
		
		private static var equipMaterial:TextureMaterial;
		private static var nodeMeshDic:Dictionary = new Dictionary(true);
		private static var nodeGeometry:PlaneGeometry;
		//		private static var earthMaterial:TextureMaterial;
		//		private static var earthGeometry:PlaneGeometry;
		//key:pvo value:Node(Mesh)
		private function createNodeList(floor:int,nodeId:int,nodeList:Vector.<PointVo>):void
		{
			var floorContainer:FloorContainer = floorDic[floor];
			if(floorContainer == null)return;
			floorContainer.clearEquip();
			if(nodeList == null)return;
			if(equipMaterial == null){
				equipMaterial = new TextureMaterial();
				//				equipMaterial.mipmap = false;
				//				equipMaterial.alphaBlending = true;
			}
			PowerLoader.loadFile(MerchModel.getEquipIcon(nodeId),loadImage,equipMaterial);
			if(nodeGeometry == null){
				//				nodeGeometry = new PlaneGeometry(12,12,1,1,false);
				nodeGeometry = new PlaneGeometry(8,8);
			}
			for (var i:int = 0; i < nodeList.length; i++) 
			{
				var pvo:PointVo = nodeList[i];
				if(nodeMeshDic[pvo] == null){
					var mesh:Mesh = new Mesh(nodeGeometry,equipMaterial);//创建网格容器
					mesh.x = pvo.x;
					mesh.z = pvo.z;
					mesh.y = 12;
					nodeMeshDic[pvo] = mesh;
				}else{
					mesh = nodeMeshDic[pvo];
				}
				//				floorContainer.addChild(mesh);
				floorContainer.addEquipTag(mesh);
			}
			onLightMove();
		}
		
		private function createEarth(floor:int):void
		{
			var ep:PointVo = MerchModel.getEarthNode(floor);
			if(ep != null){
				PowerLoader.loadFile("assets/meshs/earth.awd",loadEarth,floor);
//				PowerLoader.loadFile("assets/meshs/earth.3ds",loadEarth,floor);
				//				if(earthMaterial == null){
				//					earthMaterial = new TextureMaterial();
				//					earthMaterial.alphaBlending = true;
				//				}
				//				if(earthGeometry == null){
				//					earthGeometry = new PlaneGeometry(10,12);
				//				}
				//				PowerLoader.loadFile("assets/merch/icon/iconEarth.png",loadImage,earthMaterial,true);
				//				var earth:Mesh = new Mesh(earthGeometry,earthMaterial);
				//				var minX:Number = MerchModel.getMinX(nowFloor);
				//				var minZ:Number = MerchModel.getMinZ(nowFloor);
				//				earth.x = ep.x * GameUtil.size + minX;
				//				earth.z = ep.z * GameUtil.size + minZ;
				//				earth.y = 12;
				//				earth.rotationY = -90;
				//				floorContainer.addEarthTag(earth);
			}
		}
		
		private function loadEarth(earth:ObjectContainer3D,floor:int):void
		{
			var ep:PointVo = MerchModel.getEarthNode(floor);
			var floorContainer:FloorContainer = floorDic[floor];
			if(ep != null && floorContainer != null){
				var minX:Number = MerchModel.getMinX(floor);
				var minZ:Number = MerchModel.getMinZ(floor);
				
				var tempChild:ObjectContainer3D = new ObjectContainer3D(); 
//				floorContainer.addChild(tempChild);
				tempChild.rotationY = MerchModel.getRotationY(floor,ep.area);
				
				earth.x = ep.x * GameUtil.size + minX;
				earth.z = ep.z * GameUtil.size + minZ;
				earth.y = 5;
				earth.scaleX = earth.scaleZ = earth.scaleY = .35;
				tempChild.addChild(earth);
				var meshPostion:Vector3D = earth.scenePosition;
				earth.x = meshPostion.x;
				earth.z = meshPostion.z;
//				floorContainer.removeChild(tempChild);
				//				earth.rotationY = -90;
				if(earth.numChildren > 0){
					var e:Mesh = earth.getChildAt(0) as Mesh;
					e.material = AwayEngine.getColorMaterial(0x019E97);
					//					(e.material as ColorMaterial).color = 0x019E97;
				}
				//				(earth.material as TextureMaterial).alphaBlending = true;
				//				earth.material = 
				floorContainer.addEarthTag(earth);
			}
			onLightMove();
		}
		
		private static var sp:Sprite = new Sprite();
		private function loadImage(bmp:Bitmap,m:TextureMaterial,isAlpha:Boolean = false):void
		{
			//			var bmpData:BitmapData = bmp.bitmapData;
			m.texture = Cast.bitmapTexture(bmp);
			m.alphaBlending = true;
			m.bothSides = true;
			return;
			
			var w:Number = getNearValue(bmp.width);
			var h:Number = getNearValue(bmp.height);
			sp.removeChildren();
			sp.graphics.clear();
			if(!isAlpha){
				sp.graphics.beginFill(0x019e97);
				sp.graphics.drawRect(0,0,w,h);
				//			sp.graphics.drawRoundRectComplex(0,0,w,h,5,5,5,5);
				sp.graphics.endFill();
			}
			sp.addChild(bmp);
			bmp.x = (w - bmp.width) / 2;
			bmp.y = (h - bmp.height) / 2;
			var bd:BitmapData = AssetManager.getSourceBd(w,h);
			//			bd.draw(bmp);
			bd.draw(sp);
			m.texture = Cast.bitmapTexture(bd);
			//			m.alphaBlending;
		}
		
		private var baseContainer:ObjectContainer3D;
		private var floorOne:ObjectContainer3D;//显示1容器
		private var floorTwo:ObjectContainer3D;//显示2容器
		//		private var searchLayer:ObjectContainer3D;//地图搜索层
		private var floorDic:Dictionary = new Dictionary(true);//楼层的容器
		private function initFace():void
		{
			if(floorOne == null){
				baseContainer = new ObjectContainer3D();
				AwayEngine.addMesh(baseContainer);
				showHoverCamera();
				//				AwayEngine.setHoverCamera(50 * Vision.normalScale,220 * Vision.normalScale,0,90,NaN,NaN,130);
				//				AwayEngine.setHoverCamera(180 * Vision.normalScale,260 * Vision.normalScale,40,40,15,165,130);
				//				AwayEngine.perDistance = 20;
				PowerEngine.fieldOfView = 70;
				floorOne = new ObjectContainer3D();
				baseContainer.addChild(floorOne);
				floorTwo = new ObjectContainer3D();
				baseContainer.addChild(floorTwo);
				
				//				searchLayer = new ObjectContainer3D();
				//				baseContainer.addChild(searchLayer);
				//				searchLayer.y = baseY;
				
				var _view3D:View3D = AwayEngine.view3D;
				//				_view3D.width = Vision.senceWidth;
				//				_view3D.height = Vision.MERCH3D_HEIGHT * 2 * Vision.heightScale;
				//				_view3D.x = 100 * Vision.widthScale;
				_view3D.y = (Vision.admanageHeight + Vision.farmMenuHeight - Vision.MERCH3D_HEIGHT) * Vision.heightScale;
				
				initPointLight();
				
				baseContainer.scaleX = baseContainer.scaleY = baseContainer.scaleZ = 0;
			}
			PowerEngine.awayRenderEnabled = AwayEngine.cameraEnabled = true;
			Vision.shield();
		}
		
		private function initAreaLayer(floor:int,parent:ObjectContainer3D):void
		{
			var areaCount:int = MerchModel.getAreaCount(floor);
			for (var i:int = GameUtil.SCENE_AREA; i < areaCount; i++) 
			{
				var areaLayer:ObjectContainer3D = new ObjectContainer3D();
				parent.addChild(areaLayer);
				createArea(floor,areaLayer,i);//添加区域容器
				if(i != GameUtil.SCENE_AREA)areaLayer.rotationY = MerchModel.getRotationY(floor,i);
			}
//			areaLayer = new ObjectContainer3D();
//			parent.addChild(areaLayer);
//			createArea(floor,areaLayer,);//添加区域容器
		}
		private var searchKey:String = "searchLayer";
		//		private var floorKey:String = "floorLayer";
		//		private var roadKey:String = "roadLayer";
		private var areaLayerDic:Dictionary = new Dictionary(true);
		private function createArea(floor:int,parent:ObjectContainer3D,area:int):void{
			var searchLayer:ObjectContainer3D = new ObjectContainer3D();
			parent.addChild(searchLayer);
			areaLayerDic[floor + "_" + area + "_" + searchKey] = searchLayer;
		}
		/**
		 * 获取关键字相关的容器
		 * @return 
		 */		
		private function getKeyLayer(floor:int,area:int,key:String):ObjectContainer3D{
			return areaLayerDic[floor + "_" + area + "_" + key];
		}
		
		private var freeCamera:FreeCamera3D;
		private var freeCameraControl:FreeCameraControl;
		public function showHoverCamera():void{
			//			AwayEngine.setCameraAngle(100 * Vision.normalScale,250 * Vision.normalScale,90,90,NaN,NaN,90,0);
			//			AwayEngine.setHoverCamera(950 * Vision.normalScale,1550 * Vision.normalScale,90,90,NaN,NaN,90,0);
			if(freeCameraControl == null){
				freeCamera = new FreeCamera3D(AwayEngine.camera);
				freeCamera.defaultDistance = 180 * Vision.normalScale;
				freeCamera.defaultPanAngle = -15 - 90;
				freeCamera.defaultTiltAngle = 20;
				freeCamera.maxRadiusX = 60;
				freeCamera.maxRadiusZ = 50;
				freeCamera.minDistance = 50 * Vision.normalScale;
				freeCamera.maxDistance = 300 * Vision.normalScale;
				freeCamera.centerPoint3D = new Vector3D(-10,50,0);
				freeCamera.reset();
				
				freeCameraControl = FreeCameraControl.getInstance();
				freeCameraControl.stage = Vision.stage;
				freeCameraControl.freeCamera = freeCamera;
				freeCameraControl.perDistance = 20;
				//				freeCameraControl.keyBoardTurn = false;//
			}
			//			addPadEvent();
		}
		
		private function tweenShow():void
		{
			TweenLite.to(baseContainer,.3,{scaleX:Vision.normalScale,scaleY:Vision.normalScale,scaleZ:Vision.normalScale});
		}
		private function tweenHide():void
		{
			TweenLite.to(baseContainer,.3,{scaleX:0,scaleY:0,scaleZ:0,onComplete:tweenHideOver});
		}
		private function tweenHideOver():void{
			PowerEngine.awayRenderEnabled = AwayEngine.cameraEnabled = false;
			//			if(floorOne.numChildren > 0){
			//				floorOne.removeChildAt(0);
			//			}
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
				txt.textColor = 0x3b393a;
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
		private static function createCircle(radius:Number,color:uint = 0):BitmapData{
			if(shape == null){
				shape = new Shape();
			}
			shape.graphics.clear();
			shape.graphics.beginFill(color);
			shape.graphics.drawCircle(radius,radius,radius);
			shape.graphics.endFill();
			var bd:BitmapData = new BitmapData(getNearValue(shape.width),
				getNearValue(shape.height),true,0xFFFFFFFF);
			bd.draw(shape);
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
			//			light = new DirectionalLight(0.5, -1, -1);
			//			light.color = 0xEEEEEE; //0xFFFFFF
			//			light.ambient = 0.4;
			//			AwayEngine.addLight(light);
			//			var light:DirectionalLight = new DirectionalLight(-0.5, -1, -1);
			//			light.color = 0xEEEEEE; //0xFFFFFF
			//			light.ambient = 0.4;
			//			AwayEngine.addLight(light);
			cameraLight = new PointLight();
			cameraLight.color = 0xEEEEEE;//
			//			cameraLight.ambient = .2;
			cameraLight.diffuse = 1.5;
			cameraLight.specular = 0.1;
			//			cameraLight.ambient = 0.1;
			AwayEngine.addLight(cameraLight);
			//			AwayEngine.followCamera(onLightMove);
			if(freeCamera != null){
				freeCamera.setUpadeFuction(onLightMove);
			}
		}
		
		private function onLightMove(e:Event = null):void
		{
			if(cameraLight == null)return;
			cameraLight.position = AwayEngine.camera.position;
			//			var tagMeshDic:Dictionary = planeDic[nowFloor];
			//			for each (var mesh:Mesh in tagMeshDic) 
			//			{
			//				mesh.lookAt(AwayEngine.camera.position/*.add(new Vector3D(0,_view3D.y,0))*/);
			//				//				if(mesh != selectTag){
			//				////					mesh.pitch(90);
			//				//					mesh.rotationX = -75;
			//				//				}else{
			//				//				}
			//				mesh.rotationX = 0;
			//				mesh.yaw(180);
			//			}
			//			var hc:HoverController = AwayEngine.hoverController;
			var f:FloorContainer = floorDic[nowFloor];
			if(f != null){
				var equipContainer:ObjectContainer3D = f.equipContainer;
				if(equipContainer != null){
					for (var i:int = equipContainer.numChildren - 1; i >= 0 ; i--) 
					{
						var mesh:ObjectContainer3D = equipContainer.getChildAt(i);
						mesh.rotationY = 90 - freeCamera.panAngle;//180;
						mesh.rotationX = freeCamera.tiltAngle + 180;// + 180;// + 180;
//						mesh.rotationY = freeCamera.panAngle - 180;
//						mesh.rotationX = freeCamera.tiltAngle - 90;
						//						mesh.rotationZ = 180;
						//						mesh.lookAt(AwayEngine.camera.position/*.add(new Vector3D(0,_view3D.y,0))*/);
						//						mesh.rotationX = -20;
						//						mesh.yaw(180);
					}
				}
			}
		}
		
		private static var floorId:int = -1;//1;//地板id
		private function loadModel(mesh:ObjectContainer3D,floor:int,onComplete:Function = null,
								   args:Array = null):void
		{
			var floorContainer:FloorContainer = floorDic[floor];
			if(floorContainer.hasMeshContainer()){//已经存在
				//				tabFloor(floorContainer,onComplete,args);
				if(onComplete != null)args != null ? onComplete.apply(null,args) : onComplete();
				return;
			}
			floorContainer.meshContainer = mesh;
			//			var blueList:Array = [14,27,26,32];
			var maxId:int = 0;
			for (i = 0; i < mesh.numChildren; i++) 
			{
				child = mesh.getChildAt(i) as Mesh;
				id = child.name.split("_")[1];
				if(id > maxId){
					maxId = id;
				}
			}
			initAreaLayer(floor,mesh);
			for (var i:int = 0; i < mesh.numChildren; i++) 
			{
				var child:Mesh = mesh.getChildAt(i) as Mesh;
				if(child == null)continue;
				var id:int = child.name.split("_")[1];
				var meshTag:String = child.name.split("_")[0];
				if(id == floorId){
					var cm:ColorMaterial = AwayEngine.getColorMaterial(0xffffff);
				}else if(id == maxId){
					cm = AwayEngine.getColorMaterial(0xeaeaea);
					cm.alpha = .8;
					//					cm.alphaBlending = true;
				}else{
					var ivo:MeshInfoVo = MerchModel.getMeshInfoByNameId(floor,child.name);
					if(ivo != null){
						createTxtPlane(floorContainer,child,id,ivo.number,floor);
						cm = AwayEngine.getColorMaterial(MerchModel.getKindColor(ivo.attribute));
					}else{
						//						cm = AwayEngine.getColorMaterial(0xe1dfe0);
						cm = AwayEngine.getColorMaterial(0xe5e5e5);
					}
				}
				//				trace(child.name);
				cm.lightPicker = AwayEngine.lightPicker;//应用光源
				child.material = cm;
			}
			//			tabFloor(floorContainer,onComplete,args);
			
			var nodeList:Vector.<PointVo> = MerchModel.getNodeList(floor,nodeId);
			if(nodeList != null){
				createNodeList(floor,nodeId,nodeList);
			}
			createEarth(floor);
			//			onLightMove();
			
			if(onComplete != null)args != null ? onComplete.apply(null,args) : onComplete();
		}
		
		private function loadMerch(mesh:ObjectContainer3D,floor:int):void
		{
			var floorContainer:FloorContainer = floorDic[floor];
			if(floorContainer.hasMerchContainer()){
				return;//不需要添加了
			}
			floorContainer.merchContainer = mesh;
			//			mesh.y = 3;
			//			var minId:int = MerchModel.getInfoMinNumber(floor);
			for (var i:int = 0; i < mesh.numChildren; i++) 
			{
				var child:Mesh = mesh.getChildAt(i) as Mesh;
				var ivo:MeshInfoVo = MerchModel.getMeshInfoByNameId(floor,child.name);
				//					MerchModel.getMeshInfoByNumber(floor,num < 10 ? ("0" + num) : ('' + num));
				if(ivo != null){
					if(child.material is ColorMaterial){
						(child.material as ColorMaterial).color = 0xFFFFFF;
					}else{
						child.material = new ColorMaterial(0xFFFFFF);
					}
				}else{
					if(child.material is ColorMaterial){
						(child.material as ColorMaterial).color = 0x666666;
					}else{
						child.material = new ColorMaterial(0x666666);
					}
				}
				//				var meshTag:String = child.name.split("_")[0];
				TweenLite.from(child.material,.5,{alpha:0});
			}
		}
		
		private function loadTexture(bmp:Bitmap,child:Mesh):void
		{
			var m:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(bmp));
			m.alphaBlending = true;
			m.lightPicker = AwayEngine.lightPicker;
			//						m.smooth = false
			//						m.mipmap = false;
			child.material = m;
		}
		/**
		 * 显示商铺模型数据
		 * @param number 商铺编号
		 */		
		public function showMesh(mList:Vector.<MeshInfoVo>):void{
			var floor:int = mList[0].floor;//选择第一个的
			var floorContainer:FloorContainer = floorDic[floor];
			if(floorContainer != null){
				freeCamera.reset(focusMerch,floor,mList);
			}else{
				createFloor(floor,showMesh,[mList]);
			}
		}
		
		private function getMeshByNameId(floor:int,nameId:String):Mesh{
			var floorContainer:FloorContainer = floorDic[floor];
			if(floorContainer != null){
				var meshContainer:ObjectContainer3D = floorContainer.meshContainer;
				if(meshContainer != null){
					//					var ivo:MeshInfoVo = MerchModel.getMeshInfoByNumber(floor,number);
					for (var i:int = 0; i < meshContainer.numChildren; i++) 
					{
						var child:Mesh = meshContainer.getChildAt(i) as Mesh;
						if(child.name == nameId){
							//							focusMerch(ivo.floor,ivo,child);//目标选中
							return child;
						}
					}
				}
			}
			return null;
		}
		
		private var planeDic:Dictionary = new Dictionary(true);
		//		private var tagMeshDic:Dictionary = new Dictionary(true);
		private function createTxtPlane(floorContainer:FloorContainer,
										p:Mesh,id:int,number:String,floor:int):void
		{
			if(planeDic[floor] == null){
				tagMeshDic = planeDic[floor] = new Dictionary(true);
			}else{
				var tagMeshDic:Dictionary = planeDic[floor];
			}
			//			PowerLoader.loadFile("assets/meshs/texture/" + 3 + ".png",loadTemp,p);
			p.mouseEnabled = true;
			p.pickingCollider = PickingColliderType.AUTO_FIRST_ENCOUNTERED;
			p.addEventListener(MouseEvent3D.MOUSE_DOWN,onMeshDown);
			return;
			
			var pe:PlaneGeometry = new PlaneGeometry(10,10,1,1,false);
			//			pe.scaleUV(-1,1);
			var bd:BitmapData = createText(number);
			var m:TextureMaterial = new TextureMaterial(Cast.bitmapTexture(bd));
			m.alphaBlending = true;
			//						m.smooth = true;
			//						m.bothSides = true;
			var mesh:Mesh = new Mesh(pe,m);//创建网格容器
			//			AwayEngine.addMesh(mesh);//添加到3D世界中
			var b:AxisAlignedBoundingBox = p.bounds as AxisAlignedBoundingBox;
			mesh.scaleX = mesh.scaleZ = .5;
			//			mesh.scaleY = 2;
			mesh.x = p.x + b.centerX;
			mesh.z = p.z + b.centerZ;
			mesh.y = p.y + b.centerY + 6;
			//			mesh.pivotPoint = new Vector3D(-5,0,-5);
			//						mesh.pitch(90);
			//			AwayEngine.camera.lookAt(mesh.position);
			floorContainer.addMeshTag(mesh);
			//			floorContainer.addChild(mesh);
			//			mesh.y = 10;
			tagMeshDic[id] = mesh;
			//			trace();
		}
		
		private var _enabled:Boolean = true;//是否能交互
		public function get enabled():Boolean
		{
			return _enabled;
		}
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
		}
		
		private function onMeshDown(e:MouseEvent3D):void
		{
			if(!_enabled)return;//不能交互
			var newMesh:Mesh = e.currentTarget as Mesh;
			var ivo:MeshInfoVo = MerchModel.getMeshInfoByNameId(nowFloor,newMesh.name);
			if(ivo != null){
				var mvo:MerchVo = FarmDataBase.getMerchByNumber(ivo.number);
				if(mvo != null){
					FarmMenu.getInstance().checkItemId(mvo.classid,mvo);
				}
				//				focusMerch(ivo.floor,ivo,newMesh);
				freeCamera.reset(focusMerch,ivo.floor,ivo);
			}
		}
		
		//对目标mesh设置
		private function focusMerch(floor:int,iObjcet:Object):void{
			//			if(selectMesh == newMesh){
			//				trace("当前模型已经选中");
			//				return;//当前模型已经选中
			//			}
			if(iObjcet is MeshInfoVo){
				var ivo:MeshInfoVo = iObjcet as MeshInfoVo;
			}else if(iObjcet is Vector.<MeshInfoVo>){
				ivo = (iObjcet as Vector.<MeshInfoVo>).shift();//从头部拿出
			}
			if(ivo != null && ivo.doorPos != null){
				clearSelectMesh(floor);
				clearStack();
				var newMesh:Mesh = getMeshByNameId(floor,ivo.nameId);
				if(floor != MerchModel.FIRST_FLOOR){//不是一楼 从前一楼开始计算
					doFloorMapSearch(floor,newMesh,ivo);
				}else{//如果是一楼
					if(floor != nowFloor){//层数不对 自动跳到一楼
						showFloor(floor,false,normalMesh,[floor,ivo,newMesh]);
					}else normalMesh(floor,ivo,newMesh);//开始走路
				}
				if(iObjcet is Vector.<MeshInfoVo> && iObjcet.length > 0){
					for each (ivo in iObjcet) 
					{
						if(ivo.floor == floor){//属于同一层
							var mesh:Mesh = getMeshByNameId(floor,ivo.nameId);
							if(mesh != null){
								lookMesh(mesh);//一块显示 但不寻路
							}
						}
					}
				}
			}
		}
		
		private function normalMesh(floor:int,ivo:MeshInfoVo,newMesh:Mesh):void{
			doNormalMapSearch(floor,ivo.doorPos.x,ivo.doorPos.z,ivo.doorPos.area);
			lookMesh(newMesh);
		}
		
		private function doFloorMapSearch(floor:int, newMesh:Mesh, ivo:MeshInfoVo):void
		{
			var pFloor:int = floor - 1;
			//前一层数据
			var fpList:Vector.<FloorInfoVo> = MerchModel.getFloorInfoList(pFloor);
			var fnList:Vector.<FloorInfoVo> = MerchModel.getFloorInfoList(floor);
			//两层楼数据
			var bothList:Array = [];
			for each (var pfvo:FloorInfoVo in fpList) 
			{
				for each (var nfvo:FloorInfoVo in fnList) 
				{
					if(pfvo.id == nfvo.id){
						bothList.push([pfvo,nfvo]);
					}
				}
			}
			if(bothList.length > 0){//捉对个数
				var preEarth:PointVo = MerchModel.getEarthNode(pFloor);
				var maxLength:int = 1000000;
				var minLength:int = maxLength;//最小步数
				var minPV:Vector.<PointVo>;//前一层最小数据
				var minNv:Vector.<PointVo>;//当前层最小数据
				for each (var tempList:Array in bothList) 
				{//tempList 0:前一个 1:当前
					pfvo = tempList[0];
					nfvo = tempList[1];
					var pv:Vector.<PointVo> = GameUtil.searchRoad(pFloor,pfvo.postion.x,
						pfvo.postion.z,pfvo.postion.area,preEarth);
					//						search(pFloor,preEarth.x,preEarth.z,
					//						pfvo.postion.x,pfvo.postion.z);
					var nv:Vector.<PointVo> = GameUtil.searchRoad(floor,ivo.doorPos.x,
						ivo.doorPos.z,ivo.doorPos.area,nfvo.postion);
					//						GameUtil.search(floor,nfvo.postion.x,nfvo.postion.z,
					//						ivo.doorPos.x,ivo.doorPos.z);
					var pLength:Number = pv != null ? pv.length : maxLength;
					var nLength:Number = nv != null ? nv.length : maxLength;
					if(pLength + nLength < minLength){
						minLength = pLength + nLength;
						minPV = pv;
						minNv = nv;
					}
				}
			}
			//实现最小步数
			if(minPV != null && minNv != null){//开始滚动
				statckList.length = 0;
				statckList.push(new StackVo(showFloor,[pFloor,true,nextStack]));
				statckList.push(new StackVo(showSearch,[pFloor,minPV,GameUtil.SEARCH_FLOOR_UP,nextStack]));
				statckList.push(new StackVo(showFloor,[floor,true,nextStack]));
				statckList.push(new StackVo(showSearch,[floor,minNv,GameUtil.SEARCH_FLOOR_DOWN,nextStack]));
				statckList.push(new StackVo(lookMesh,[newMesh]));
				
				//				tabFloor(floorDic[preFloor],showSearch,[prevFloor,minPV,tabFloor,[floorDic[floor],
				//					showSearch,[floor,minNv,lookMesh,[newMesh]]]]);
				nextStack();
			}
		}
		
		private function nextStack():void{
			if(statckList.length > 0){
				var svo:StackVo = statckList.shift();
				svo.run();
			}
		}
		//		private var selectMesh:Mesh;
		private var selectMeshList:Vector.<Mesh> = new Vector.<Mesh>();
		private var statckList:Vector.<StackVo> = new Vector.<StackVo>();
		private function clearSelectMesh(floor:int):void{
			for each (var selectMesh:Mesh in selectMeshList) 
			{
				var tag:Mesh = getMeshTag(floor,selectMesh);
				if(tag != null){
					TweenLite.to(tag,.3,{y:preY});
				}
				TweenLite.to(selectMesh,.3,{scaleY:1});
			}
			selectMeshList.length = 0;
		}
		
		private function lookMesh(newMesh:Mesh):void{
			selectMeshList.push(newMesh);
			TweenLite.to(newMesh,.3,{scaleY:2});
			var tag:Mesh = getMeshTag(nowFloor,newMesh);
			if(tag != null){
				showTag(tag);
			}
		}
		
		private function getMeshTag(floor:int,child:Mesh):Mesh{
			var id:int = child.name.split("_")[1];
			var tagMeshDic:Dictionary = planeDic[floor];
			var tag:Mesh = tagMeshDic != null ? tagMeshDic[id] : null;
			if(tag == null){
				var floorContainer:FloorContainer = floorDic[floor];
				tag = tagMeshDic[id] = floorContainer.getMeshTag(floor,child);
			}
			return tag;
		}
		
//		private function clearSelectTag():void{
//			if(selectTag != null){
//				TweenLite.to(selectTag,.3,{y:preY});
//			}
//			selectTag = null;
//		}
		private var preY:Number = 0;
//		private var selectTag:Mesh;
		private function showTag(tag:Mesh):void{
//			if(tag != selectTag){
//				clearSelectTag();
//				selectTag = tag;
//				preY = tag.y;
//			}
			TweenLite.to(tag,.3,{y:preY + 3});
		}
		//		private static var size:Number = 2;//2;//每个plane的尺寸
		private static var roadPlane:PlaneGeometry = new PlaneGeometry(GameUtil.size / 3,GameUtil.size / 3);//路点模型
		private static var roadMaterial:TextureMaterial;
		/**
		 * 开始寻路
		 * @param indexX
		 * @param indexZ
		 */		
		public function doNormalMapSearch(floor:int,indexX:int, indexZ:int, area:int):void
		{
			var ep:PointVo = MerchModel.getEarthNode(floor);
			if(ep == null){
				trace("对不起，请先设置地标才可以寻路");
				return;
			}
			var v:Vector.<PointVo> = GameUtil.searchRoad(floor,indexX,indexZ,area,ep);
			//				search(floor,ep.x,ep.z,indexX,indexZ);
			//
			clearSearch(floor);
			showSearch(floor,v);
		}
		
		private function showSearch(floor:int,v:Vector.<PointVo>,searchType:String = GameUtil.SEARCH_NONE,
									onComplete:Function = null,args:Array = null):void
		{
			if(roadMaterial == null){
				roadMaterial = new TextureMaterial(Cast.bitmapTexture(createCircle(GameUtil.size,/*0x019E97*/0xef5050)));
				//				roadMaterial.alphaBlending = true;
				//				roadMaterial.alpha = .99;
			}
			//			var eNode:PointVo = MerchModel.getEarthNode(floor);
			//			if(freeCamera != null && eNode != null){
			//				freeCamera.moveTo(new Vector3D(eNode.x,freeCamera.cameraPoint.y,eNode.z)/*,roadSearch,floor,v,searchType,
			//					onComplete,args*/);
			//			}else{
			//			}
			GameUtil.createSearchMesh = createSearchMesh;
			GameUtil.roadStart(floor,v,searchType,onComplete,args);
			//				roadSearch(floor,v,searchType,onComplete,args);
		}
		
		private function createSearchMesh(tempList:Vector.<ObjectContainer3D>,floor:int,
										  area:int,x:Number ,z:Number , index:int, 
										  onComplete:Function = null,args:Array = null):Vector3D
		{
			var mesh:Mesh = createSearchNode();
			//				new Mesh(roadPlane,roadMaterial/*AwayEngine.getColorMaterial(0xFF0000)*/);
			var searchLayer:ObjectContainer3D = getKeyLayer(floor,area,searchKey);
			searchLayer.addChild(mesh);
			mesh.x = x;
			mesh.z = z;
			mesh.y = 1;
			TweenLite.from(mesh,.2,{delay:.017 * index,scaleX:0,scaleZ:0,
				onComplete:autoCamera,onCompleteParams:[mesh,onComplete,args]});
			tempList.push(mesh);//临时存放起来
			return mesh.scenePosition;//获取相对于场景的坐标
		}
		
		private function autoCamera(mesh:Mesh,onComplete:Function = null,args:Array = null):void{
			var meshPostion:Vector3D = mesh.scenePosition;
			//			freeCamera.cameraPoint = new Vector3D(meshPostion.x,freeCamera.cameraPoint.y,meshPostion.z);
			if(onComplete != null)args != null ? onComplete.apply(null,args) : onComplete();
		}
		
		private static var searchList:Vector.<Mesh> = new Vector.<Mesh>();
		private static function createSearchNode():Mesh{
			if(searchList.length > 0){
				var mesh:Mesh = searchList.pop();
				mesh.scaleX = mesh.scaleZ = 1;
				return mesh;
			}
			return new Mesh(roadPlane,roadMaterial);
		}
		
		private static function reacyleSearchNode(child:Mesh):void{
			TweenLite.killTweensOf(child);
			searchList.push(child);
		}
		
		private function clearSearch(floor:int):void{
			var areaCount:int = MerchModel.getAreaCount(floor);
			for (var i:int = GameUtil.SCENE_AREA; i < areaCount; i++) 
			{
				var searchLayer:ObjectContainer3D = getKeyLayer(floor,i,searchKey);
				if(searchLayer == null)continue;
				for (var j:int = searchLayer.numChildren - 1; j >= 0; j--) 
				{
					var child:Mesh = searchLayer.getChildAt(j) as Mesh;
					reacyleSearchNode(child);
					searchLayer.removeChild(child);
				}
			}
		}
	}
}
import com.manager.Vision;
import com.model.MerchModel;
import com.vo.MeshInfoVo;

import away3d.containers.ObjectContainer3D;
import away3d.entities.Mesh;

class FloorContainer extends ObjectContainer3D{
	
	private var _tagContainer:ObjectContainer3D;
	private var _merchContainer:ObjectContainer3D;
	public function set merchContainer(value:ObjectContainer3D):void
	{
		_merchContainer = value;
		addChild(_merchContainer);
	}
	public function hasMerchContainer():Boolean{
		return _merchContainer != null;
	}
	private var _meshContainer:ObjectContainer3D;
	public function get meshContainer():ObjectContainer3D
	{
		return _meshContainer;
	}
	
	public function set meshContainer(value:ObjectContainer3D):void
	{
		_meshContainer = value;
		addChild(_meshContainer);
		if(_tagContainer == null){
			_tagContainer = new ObjectContainer3D();
			addChild(_tagContainer);
		}
		if(_equipContainer == null){
			_equipContainer = new ObjectContainer3D();
			addChild(_equipContainer);
		}
	}
	private var _equipContainer:ObjectContainer3D;
	public function get equipContainer():ObjectContainer3D
	{
		return _equipContainer;
	}
	
	public function getMeshTag(floor:int,child:Mesh):Mesh{
		var ivo:MeshInfoVo = MerchModel.getMeshInfoByNameId(floor,child.name);
		if(ivo != null){
			if(_merchContainer != null){
				//				var minId:int = MerchModel.getInfoMinNumber(floor);
				var minId:int = int(child.name.substr(-4,4));
				for (var i:int = _merchContainer.numChildren - 1; i >= 0; i--) 
				{
					var tag:Mesh = _merchContainer.getChildAt(i) as Mesh;
					if(tag != null){
						var number:int = int(tag.name.substr(-4,4));
						if(minId == number){
							return tag;
						}
						//						if(int(ivo.number) + 1 == int(number) + minId - 1){
						//							return tag;
						//						}
					}
				}
			}
		}
		return null;
	}
	//	public function initFace():void{
	//		if(meshContainer == null){
	//			meshContainer = new ObjectContainer3D();
	//			addChild(meshContainer);
	//		}
	//		
	//	}
	public function hasMeshContainer():Boolean{
		return _meshContainer != null;
	}
	public function addMeshTag(tag:Mesh):void{
		_tagContainer.addChild(tag);
	}
	
	private var earthTag:ObjectContainer3D;
	public function addEarthTag(earth:ObjectContainer3D):void{
		earthTag = earth;
		addEquipTag(earth);
	}
	
	public function addEquipTag(equip:ObjectContainer3D):void{
		if(_equipContainer != null){
			_equipContainer.addChild(equip);
			moveFade();
		}
	}
	
	public function clearEquip():void{
		if(_equipContainer != null){
			for (var i:int = _equipContainer.numChildren - 1; i >= 0; i--) 
			{
				var child:ObjectContainer3D = _equipContainer.getChildAt(i);
				if(child != earthTag){
					_equipContainer.removeChild(child);
				}
			}
			//			while(_equipContainer.numChildren > 0){
			//				_equipContainer.removeChildAt(_equipContainer.numChildren - 1);
			//			}
			//			stopFade();
		}
	}
	
	public function moveFade():void{
		if(_equipContainer != null)
			Vision.fadeInOut(_equipContainer,"y",0,2);
	}
	
	public function stopFade():void{
		if(_equipContainer != null){
			Vision.fadeClear(_equipContainer);
			_equipContainer.y = 0;
		}
	}
}
class StackVo{
	
	public function StackVo(complete:Function,args:Array = null){
		this.onComplete = complete;
		this.onCompleteParams = args;
	}
	//execute
	public function run():void{
		if(onComplete != null)onCompleteParams != null ? 
			onComplete.apply(null,onCompleteParams) : onComplete();
	}
	
	public var onComplete:Function;//完成事件
	public var onCompleteParams:Array;//完成的参数
}