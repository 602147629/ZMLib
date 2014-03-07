package com.model
{
	import com.manager.FileManager;
	import com.vo.FloorInfoVo;
	import com.vo.LinkInfoVo;
	import com.vo.MeshInfoVo;
	import com.vo.PointVo;
	
	import flash.utils.Dictionary;
	
	public class GameModel
	{
		//class_attribute
		public static const KIND_DATA:Array = [
			{label:"肉类",selectColor:0xBC2248,classid:19,attribute:1},
			{label:"蔬菜",selectColor:0x35AB35,classid:20,attribute:2},
			{label:"水产",selectColor:0x0080C7,classid:50,attribute:3},
			{label:"海产",selectColor:0x0165AB,classid:51,attribute:4},
			{label:"家禽",selectColor:0x008F57,classid:52,attribute:5},
			{label:"卤味",selectColor:0xC30020,classid:54,attribute:6},
			{label:"豆制品",selectColor:0xE6C029,classid:48,attribute:7},
			{label:"净菜",selectColor:0x37AA35,classid:21,attribute:8},
			{label:"粮油制品",selectColor:0xFAD900,classid:22,attribute:9},
			{label:"蛋",selectColor:0xF7B642,classid:23,attribute:10},
			{label:"腌腊",selectColor:0xC30020,classid:45,attribute:11},
			{label:"酱菜",selectColor:0xCC8404,classid:46,attribute:12},
			{label:"茶叶",selectColor:0x83C025,classid:47,attribute:13},
			{label:"酒",selectColor:0x0091A3,classid:49,attribute:14},
			{label:"奶制品",selectColor:0x0191C9,classid:53,attribute:15},
			{label:"糕点",selectColor:0xC8DE01,classid:55,attribute:16},
			{label:"水果",selectColor:0x01963A,classid:56,attribute:17},
			{label:"蛋糕",selectColor:0xD1A52C,classid:57,attribute:18},
			{label:"冷冻类",selectColor:0x00947A,classid:58,attribute:19},
			{label:"休闲食品",selectColor:0x71AF0F,classid:59,attribute:20}
		];
		
		private static function getAttribute(classid:int):int{
			for each (var obj:Object in KIND_DATA) 
			{
				if(obj.classid == classid){
					return obj.attribute;
				}
			}
			return 0;
		}
		
		public static const MAP_TYPE_EARTH:int = 1;//地标
		public static const MAP_TYPE_MESH:int = 2;//网格
		public static const MAP_TYPE_DOOR:int = 3;//门口
		public static const MAP_TYPE_LINK:int = 6;//关节连接点 //每个区域都有设置连接
		public static const MAP_TYPE_FLOOR:int = 4;//楼梯
		public static const MAP_TYPE_TEST:int = 5;//测试
		
		public static const MAP_DATA:Array = [
			{label:"商铺",selectColor:0x71AF0F,typeID:MAP_TYPE_DOOR},
			{label:"地标",selectColor:0xBC2248,typeID:MAP_TYPE_EARTH},
			{label:"网格",selectColor:0x35AB35,typeID:MAP_TYPE_MESH},
			{label:"关节点",selectColor:0xFAD900,typeID:MAP_TYPE_LINK},
			{label:"楼梯",selectColor:0x0080C7,typeID:MAP_TYPE_FLOOR},
			{label:"测试",selectColor:0xD1A52C,typeID:MAP_TYPE_TEST}
		];
		
		public static const EQUIP_DATA:Array = [
			{icon:"assets/merch/icon/icon01.png",id:1,image:"assets/merch/icon/image01.png"},
			{icon:"assets/merch/icon/icon02.png",id:2,image:"assets/merch/icon/image02.png"},
			{icon:"assets/merch/icon/icon03.png",id:3,image:"assets/merch/icon/image03.png"},
			{icon:"assets/merch/icon/icon04.png",id:4,image:"assets/merch/icon/image04.png"},
			{icon:"assets/merch/icon/icon05.png",id:5,image:"assets/merch/icon/image05.png"},
			{icon:"assets/merch/icon/icon06.png",id:6,image:"assets/merch/icon/image06.png"}
		];
		
		public static const AREA_DATA:Array = [
			{label:"A",selectColor:0x71AF0F},
			{label:"B",selectColor:0xBC2248},
			{label:"C",selectColor:0x35AB35},
			{label:"D",selectColor:0xFAD900},
			{label:"E",selectColor:0x0080C7},
			{label:"F",selectColor:0xD1A52C}
		];
		
		public static var areaCount:int = 2;//2块区域 最少1
		private static var _areaList:Array;
		public static function get areaList():Array{
			if(_areaList == null){
				_areaList = [];
				for (var i:int = 0; i < areaCount; i++) 
				{
					_areaList.push(AREA_DATA[i]);
				}
			}
			return _areaList;
		}
		
		private static var _earthNode:PointVo;// = new PointVo(-1,-1);//地标坐标
		public static function get earthNode():PointVo
		{
			return _earthNode;
		}
		/**
		 * 设置地标坐标
		 */		
		public static function setEarthNode(indexX:int,indexZ:int,area:int):void{
			if(_earthNode == null)_earthNode = new PointVo(0,0,area);
			_earthNode.x = indexX;
			_earthNode.z = indexZ;
			_earthNode.area = area;
		}
		//保存所有地图数据
		private static var facDic:Dictionary = new Dictionary(true);
		//facDic[id] = facList:Vector.<PointVo> 记录坐标点mesh数组
		
//		private static var _mapList:Vector.<Vector.<int>>;//默认值为1 0为可走点
		private static var _mapVector:Vector.<Vector.<Vector.<int>>> = new Vector.<Vector.<Vector.<int>>>();
		public static function getMapList(area:int):Vector.<Vector.<int>>
		{
			if(area < _mapVector.length){
				return _mapVector[area];
			}
			return null;
		}
		public static var mapRows:int = -1;
		public static var mapCols:int = -1;
		public static var minX:Number;//偏移坐标
		public static var minZ:Number;
		public static function createMap(rows:int,cols:int,area:int):void{
			var mapList:Vector.<Vector.<int>> = getMapList(area);
			if(mapList != null)return;//已经创建了
			if(mapRows == -1){
				mapRows = rows;
				mapCols = cols;
			}
			_mapVector[area] = mapList = new Vector.<Vector.<int>>();
			for (var i:int = 0; i < rows; i++) 
			{
				var list1D:Vector.<int> = new Vector.<int>();
				mapList.push(list1D);
				for (var j:int = 0; j < cols; j++) 
				{
					list1D.push(1);
				}
			}
		}
		
		private static var _mapRotationY:Vector.<Number>;// = new Vector.<Number>();
		public static function setRotationY(area:int,rotationY):void{
			initMapRotationY();
			_mapRotationY[area] = rotationY;
		}
		
		private static function initMapRotationY():void
		{
			if(_mapRotationY == null){
				_mapRotationY = new Vector.<Number>();
				for (var i:int = 0; i < areaCount; i++) 
				{
					_mapRotationY[i] = 0;
				}
			}
		}
		/**
		 * 获取该区域的旋转角度
		 * @param area
		 * @return 
		 */		
		public static function getRotationY(area:int):Number{
			initMapRotationY();
			return _mapRotationY[area];
		}
		
		public static function getRoadValue(indexX:int,indexZ:int,area:int):int{
			if(indexX >= mapRows){
				trace("xIndex超过最大索引值" + mapRows);
				return 1;
			}
			if(indexZ >= mapCols){
				trace("zIndex超过最大索引值" + mapCols);
				return 1;
			}
			var mapList:Vector.<Vector.<int>> = getMapList(area);
			if(mapList == null)return 1;//已经创建了
			return mapList[indexX][indexZ];
		}
		/**
		 * 设置目标路点值
		 * @param xIndex
		 * @param zIndex
		 * @param value
		 */		
		public static function setRoadValue(indexX:int,indexZ:int,value:int,area:int):void{
			if(indexX >= mapRows){
				trace("xIndex超过最大索引值" + mapRows);
				return;
			}
			if(indexZ >= mapCols){
				trace("zIndex超过最大索引值" + mapCols);
				return;
			}
			var mapList:Vector.<Vector.<int>> = getMapList(area);
			if(mapList == null)return;//已经创建了
			mapList[indexX][indexZ] = value;
		}
		/**
		 * node设施不需要分区域
		 * @param id
		 * @param x
		 * @param z
		 * @return 存入节点的索引值
		 */		
		public static function addNode(nodeId:int,x:Number,z:Number):PointVo{
			if(facDic[nodeId] == null){
				facDic[nodeId] = new Vector.<PointVo>();
			}
			var meshList:Vector.<PointVo> = facDic[nodeId];
			var p:PointVo = new PointVo(x,z,-1);
			meshList.push(p);
			return p;
		}
		
		public static function getNodeList(nodeId:int):Vector.<PointVo>{
			return facDic[nodeId];
		}
		
		//		private static function hasNode(meshList:Vector.<Mesh>,node:Mesh):Boolean{
		//			return meshList.indexOf(node) >= 0;
		//		}
		//		
		public static function removeNode(nodeId:int,p:PointVo):void{
			if(facDic[nodeId] == null){
				trace("目标点不存在");
				return;
			}
			var meshList:Vector.<PointVo> = facDic[nodeId];
			var index:int = meshList.indexOf(p);
			if(index >= 0){
				meshList.splice(index,1);//删除该数据
			}
		}
		
		public static function updateFloorId(fid:String):void{
			var num:int = int(fid);
			if(num > floorId){
				floorId = num;
			}
		}
		
		private static var floorId:int = 0;//从这个id开始++;
		private static var _floorList:Vector.<FloorInfoVo> = new Vector.<FloorInfoVo>();//楼层数据
		public static function get floorList():Vector.<FloorInfoVo>
		{
			return _floorList;
		}

		public static function getFloorInfo(floorId:String):FloorInfoVo{
			for each (var fvo:FloorInfoVo in _floorList) 
			{
				if(fvo.id == floorId){
					return fvo;
				}
			}
			return null;
		}
		public static function updateFloorInfo(fid:String,indexX:int,indexZ:int,area:int):FloorInfoVo{
			var fvo:FloorInfoVo = getFloorInfo(fid);
			if(fvo == null){
				fvo = new FloorInfoVo();
				if(fid != null){//刚开始创建
					fvo.id = fid;
					updateFloorId(fid);
				}else{//自定义创建
					fvo.id = ++floorId + '';
				}
				_floorList.push(fvo);
			}
			fvo.addFloorPos(indexX,indexZ,area);
			return fvo;
		}
		/**
		 * 删除该楼层数据
		 * @param fid
		 */		
		public static function removeFloor(fid:String):void{
			var fvo:FloorInfoVo = getFloorInfo(fid);
			var index:int = _floorList.indexOf(fvo);
			if(index >= 0){
				_floorList.splice(index,1);//删除该数据
			}
		}
		
		private static var _linkList:Vector.<LinkInfoVo> = new Vector.<LinkInfoVo>();//楼层数据
		public static function get linkList():Vector.<LinkInfoVo>
		{
			return _linkList;
		}
		public static function getLinkInfo(linkId:String,area:int):LinkInfoVo{
			for each (var lvo:LinkInfoVo in _linkList) 
			{
				if(lvo.id == linkId && lvo.postion.area == area){
					return lvo;
				}
			}
			return null;
		}
		
		public static function updateLinkId(fid:String):void{
			var num:int = int(fid);
			if(num > linkId){
				linkId = num;
			}
		}
		public static function updateLinkInfo(lid:String,indexX:int,indexZ:int,area:int):LinkInfoVo{
			var lvo:LinkInfoVo = getLinkInfo(lid,area);
			if(lvo == null){
				lvo = new LinkInfoVo();
				if(lid != null){//刚开始创建
					lvo.id = lid;
					updateLinkId(lid);
				}else{//自定义创建
					lvo.id = ++linkId + '';
				}
				_linkList.push(lvo);
			}
			lvo.addFloorPos(indexX,indexZ,area);
			return lvo;
		}
		private static var linkId:int = 0;//从这个id开始++;
		
		/**
		 * 获取某一区域内的所有关节点数据
		 * @param area
		 * @return 
		 */		
		public static function getAreaLink(area:int):Vector.<LinkInfoVo>{
			var lList:Vector.<LinkInfoVo> = new Vector.<LinkInfoVo>();
			for each (var lvo:LinkInfoVo in _linkList) 
			{
				if(lvo.postion.area == area){
					lList.push(lvo);
				}
			}
			return lList;
		}
		/**
		 * 获取该关节的另一区域对应关节
		 * @param lvo
		 * @return 
		 */		
		public static function getAnotherLink(tarVo:LinkInfoVo):LinkInfoVo{
			for each (var lvo:LinkInfoVo in _linkList) 
			{
				if(lvo != tarVo && lvo.id == tarVo.id){
					return lvo;
				}
			}
			return null;
		}
		
		/**
		 * 删除该楼层数据
		 * @param fid
		 */		
		public static function removeLink(lid:String,area:int):void{
			var lvo:LinkInfoVo = getLinkInfo(lid,area);
			var index:int = _linkList.indexOf(lvo);
			if(index >= 0){
				_linkList.splice(index,1);//删除该数据
			}
		}
		/**
		 * 更新商铺数据
		 * @param index 模型深度
		 * @param number 编号
		 * @param classid 所属类型
		 */		
		public static function updateMeshInfo(nameId:String,number:String,attribute:int):MeshInfoVo{
			var ivo:MeshInfoVo = getMeshInfo(nameId);
			if(ivo == null){
				ivo = new MeshInfoVo();
				ivo.nameId = nameId;
				_meshInfoList.push(ivo);
			}
			ivo.number = number;
			ivo.attribute = attribute;
			return ivo;
		}
		/**
		 * 彻底删除该商铺数据
		 */		
		public static function removeMeshInfo(nameId:String):void{
			var ivo:MeshInfoVo = getMeshInfo(nameId);
			if(ivo != null){
				var index:int = _meshInfoList.indexOf(ivo);
				_meshInfoList.splice(index,1);
			}
		}
		private static var _meshInfoList:Vector.<MeshInfoVo> = new Vector.<MeshInfoVo>();
		public static function get meshInfoList():Vector.<MeshInfoVo>
		{
			return _meshInfoList;
		}

		public static function getMeshInfo(nameId:String):MeshInfoVo{
			for each (var ivo:MeshInfoVo in _meshInfoList) 
			{
				if(ivo.nameId == nameId){
					return ivo;
				}
			}
			return null;
		}
		
		public static const TAG_ONE:String = "|";
		public static const TAG_TWO:String = "_";
//		public static const ROTATION_KEY:String = "rotationY";
		/**
		 * 保存所有数据为XML 导入到File
		 */		
		public static function saveAll():void
		{
			var xml:XML = <root></root>;
			
			var roadRoot:XML = <roadRoot mapRows={mapRows} mapCols={mapCols} 
								minX={minX} minZ={minZ} areaCount={areaCount} />;//路点数据
			if(_earthNode != null){
				roadRoot.appendChild(<earth x={_earthNode.x} z={_earthNode.z} area={_earthNode.area} />);
			}
			xml.appendChild(roadRoot);
			
			var floorRoot:XML = <floorRoot />;
			roadRoot.appendChild(floorRoot);
			for each (var fvo:FloorInfoVo in _floorList) 
			{
				floorRoot.appendChild(<floor id={fvo.id} x={fvo.postion.x} z={fvo.postion.z} 
						area={fvo.postion.area} />);
			}
			var linkRoot:XML = <linkRoot />;
			roadRoot.appendChild(linkRoot);
			for each (var lvo:LinkInfoVo in _linkList) 
			{
				linkRoot.appendChild(<link id={lvo.id} x={lvo.postion.x} z={lvo.postion.z} 
						area={lvo.postion.area} />);
			}
			var areaRoot:XML = <areaRoot />;
			roadRoot.appendChild(areaRoot);
			for (var area:int = 0; area < GameModel.areaCount; area++) 
			{
				var _mapList:Vector.<Vector.<int>> = GameModel.getMapList(area);
				var tempList:Array = [];
				for (var i:int = 0; i < mapRows; i++) 
				{
					for (var j:int = 0; j < mapCols; j++) 
					{
						if(_mapList[i][j] == 0){
							tempList.push(i + TAG_TWO + j);
							//						roadRoot.appendChild(<road x={i} z={j} />);//添加路点子数据
						}
					}
				}
				areaRoot.appendChild(<road rotationY={getRotationY(area)} >{tempList.join(TAG_ONE)}</road>);
			}
			var nodeRoot:XML = <nodeRoot />;
			xml.appendChild(nodeRoot);
			for(var nodeId:* in facDic) 
			{//nodeId设施id
				var meshList:Vector.<PointVo> = facDic[nodeId];
				var nodes:XML = <nodes nodeId = {nodeId} />;
				nodeRoot.appendChild(nodes);
				for each (var pvo:PointVo in meshList) 
				{
					nodes.appendChild(<node x={pvo.x} z={pvo.z} area={pvo.area} />);
				}
			}
			var infoRoot:XML = <infoRoot />;
			xml.appendChild(infoRoot);
			for each (var ivo:MeshInfoVo in _meshInfoList) 
			{
//				var attribute:int = getAttribute(ivo.attribute);
				infoRoot.appendChild(<info nameId={ivo.nameId} number={ivo.number} 
					attribute={ivo.attribute} doorX={ivo.doorPos.x} 
					doorZ={ivo.doorPos.z} area={ivo.doorPos.area}/>);
			}
			FileManager.saveXml(xml);
		}
		
		public static function addXml(xml:XML):void
		{
			clearDic(facDic);
			_meshInfoList.length = 0;
			_floorList.length = 0;
//			_mapList = null;
			_mapVector.length = 0;
			_linkList.length = 0;
//			_mapRotationY.length = 0;
			_earthNode = null;
			
			if(xml != null){
				var roadRoot:XML = xml.roadRoot[0];
				if(roadRoot != null){
					var rows:int = roadRoot.@mapRows;
					var cols:int = roadRoot.@mapCols;
					
					if(roadRoot.hasOwnProperty("earth")){
						var earthXml:XML = roadRoot.earth[0];
						setEarthNode(earthXml.@x,earthXml.@z,earthXml.@area);
					}
//					for each (var roads:XML in roadRoot.road) 
//					{
//						setRoadValue(roads.@x,roads.@z,0);
//					}
					var areaRoot:XML = roadRoot.areaRoot[0];
					if(areaRoot != null){
						for (var area:int = 0; area < GameModel.areaCount; area++) 
						{
							var rotationY:Number = areaRoot.road[area].@rotationY;
							setRotationY(area,rotationY);
							createMap(rows,cols,area);//创建地图
							var roadMark:String = areaRoot.road[area];
							if(roadMark != null && roadMark != ""){
								var tempList:Array = roadMark.split(TAG_ONE);
								for each (var str:String in tempList) 
								{
									var sList:Array = str.split(TAG_TWO);
									setRoadValue(sList[0],sList[1],0,area);
								}
							}
						}
					}
					var floorRoot:XML = roadRoot.floorRoot[0];
					if(floorRoot != null){
						for each (var floor:XML in floorRoot.floor) 
						{
							updateFloorInfo(floor.@id,floor.@x,floor.@z,floor.@area);
						}
					}
					var linkRoot:XML = roadRoot.linkRoot[0];
					if(linkRoot != null){
						for each (var link:XML in linkRoot.link) 
						{
							updateLinkInfo(link.@id,link.@x,link.@z,link.@area);
						}
					}
				}
				var nodeRoot:XML = xml.nodeRoot[0];
				for each (var nodes:XML in nodeRoot.nodes) 
				{
					var nodeId:int = nodes.@nodeId;
					for each (var node:XML in nodes.node) 
					{
						addNode(nodeId,node.@x,node.@z);
					}
				}
				var infoRoot:XML = xml.infoRoot[0];
				for each (var info:XML in infoRoot.info) 
				{
					var ivo:MeshInfoVo = updateMeshInfo(info.@nameId,info.@number,info.@attribute);
					ivo.addDoorPos(info.@doorX,info.@doorZ,info.@area);
				}
			}
		}
		
		public static function clearDic(dic:Dictionary):void{
			for(var key:* in dic) 
			{
				delete dic[key];
			}
			//清除dic
		}
		
		
		
	}
}