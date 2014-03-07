package com.model
{
	import com.vo.FloorInfoVo;
	import com.vo.LinkInfoVo;
	import com.vo.MeshInfoVo;
	import com.vo.PointVo;
	
	import flash.utils.Dictionary;
	
	public class MerchModel
	{
		private static var floorDic:Dictionary = new Dictionary(true);
		//楼层管理floorDic[floor] = FloorVo;
		public static const EQUIP_DATA:Array = [
			{icon:"assets/merch/icon/icon01.png",id:1,image:"assets/merch/icon/image01.png"},
			{icon:"assets/merch/icon/icon02.png",id:2,image:"assets/merch/icon/image02.png"},
			{icon:"assets/merch/icon/icon03.png",id:3,image:"assets/merch/icon/image03.png"},
			{icon:"assets/merch/icon/icon04.png",id:4,image:"assets/merch/icon/image04.png"},
			{icon:"assets/merch/icon/icon05.png",id:5,image:"assets/merch/icon/image05.png"},
			{icon:"assets/merch/icon/icon06.png",id:6,image:"assets/merch/icon/image06.png"}
		];
		
		public static function getFloorEquipList(floor:int):Array{
			var fvo:FloorDataVo = floorDic[floor];
			if(fvo != null){
				var list:Array = [];
				for each (var fObj:Object in EQUIP_DATA) 
				{
					for(var nodeId:* in fvo.facDic) 
					{
						if(nodeId == fObj.id){
							list.push(fObj);
						}
					}
				}
			}
			return list;
		}
		
		public static const FLOOR_DATA:Array = [
//			{normalIcon:"assets/merch/icon/iconNormalF2.png",selectIcon:"assets/merch/icon/iconSelectF2.png",floor:2},
//			{normalIcon:"assets/merch/icon/iconNormalF1.png",selectIcon:"assets/merch/icon/iconSelectF1.png",
//				floor:FIRST_FLOOR},
//			{normalIcon:"assets/merch/icon/iconNormalF1.png",selectIcon:"assets/merch/icon/iconSelectF1.png",
//				floor:FIRST_FLOOR},
			{normalIcon:"assets/merch/icon/iconNormalF1.png",selectIcon:"assets/merch/icon/iconSelectF1.png",
				floor:FIRST_FLOOR}
		];
		
		public static function getFloorData(floor:int):Object{
			for each (var fData:Object in FLOOR_DATA) 
			{
				if(fData.floor == floor){
					return fData;
				}
			}
			return null;
		}
		
		public static const FIRST_FLOOR:int = 1;
		
		public static const AGREE_DATA:Array = [
			{label:"非常满意"},
			{label:"满意"},
			{label:"一般"},
			{label:"不满意"}
		];
		
		public static function getEquipIcon(nodeId:int):String{
			for each (var eObj:Object in EQUIP_DATA) 
			{
				if(eObj.id == nodeId)return eObj.image;
			}
			return null;
		}
		//		public static const KIND_DATA:Array = [
		//			{label:"蔬菜",selectColor:0x0c8f5d,classid:19},
		//			{label:"肉类",selectColor:0xfdd900,classid:20},
		//			{label:"水产",selectColor:0x59bbc4,classid:21},
		//			{label:"粮油",selectColor:0xcae972,classid:22},
		//			{label:"干货",selectColor:0x019e97,classid:23}
		//		];
		public static const KIND_DATA:Array = [
			{label:"肉类",selectColor:0xD197A4,classid:19,attribute:1},
			{label:"蔬菜",selectColor:0x35AB35,classid:20,attribute:2},
			{label:"水产",selectColor:0x0080C7,classid:50,attribute:3},
			{label:"海产",selectColor:0x0165AB,classid:51,attribute:4},
			{label:"家禽",selectColor:0x008F57,classid:52,attribute:5},
			{label:"卤味",selectColor:0xD48868,classid:54,attribute:6},
			{label:"豆制品",selectColor:0xC2AE84,classid:48,attribute:7},
			{label:"净菜",selectColor:0x37AA35,classid:21,attribute:8},
			{label:"粮油制品",selectColor:0xFAD900,classid:22,attribute:9},
			{label:"蛋",selectColor:0xD7BC85,classid:23,attribute:10},
			{label:"腌腊",selectColor:0xB49574,classid:45,attribute:11},
			{label:"酱菜",selectColor:0xC78C77,classid:46,attribute:12},
			{label:"茶叶",selectColor:0x83C025,classid:47,attribute:13},
			{label:"酒",selectColor:0x0091A3,classid:49,attribute:14},
			{label:"奶制品",selectColor:0x0191C9,classid:53,attribute:15},
			{label:"糕点",selectColor:0xC8DE01,classid:55,attribute:16},
			{label:"水果",selectColor:0x01963A,classid:56,attribute:17},
			{label:"蛋糕",selectColor:0xD5B676,classid:57,attribute:18},
			{label:"冷冻类",selectColor:0x00947A,classid:58,attribute:19},
			{label:"休闲食品",selectColor:0x71AF0F,classid:59,attribute:20}
		];
		
		public static const AREA_DATA:Array = [
			{label:"A",selectColor:0x71AF0F},
			{label:"B",selectColor:0xBC2248},
			{label:"C",selectColor:0x35AB35},
			{label:"D",selectColor:0xFAD900},
			{label:"E",selectColor:0x0080C7},
			{label:"F",selectColor:0xD1A52C}
		];
		
//		public static var areaCount:int = 2;//2块区域 最少1
//		private static var _areaList:Array;
//		public static function get areaList():Array{
//			if(_areaList == null){
//				_areaList = [];
//				for (var i:int = 0; i < areaCount; i++) 
//				{
//					_areaList.push(AREA_DATA[i]);
//				}
//			}
//			return _areaList;
//		}
		
		public static function getKindColor(attribute:int):uint{
			for each (var kObj:Object in KIND_DATA) 
			{
				if(kObj.attribute == attribute){
					return kObj.selectColor;
				}
			}
			return 0;
		}
		//保存所有地图数据
		/**
		 * @param id
		 * @param x
		 * @param z
		 * @return 存入节点的索引值
		 */		
		public static function addNode(floor:int,nodeId:int,x:Number,z:Number,area:int):PointVo{
			var fvo:FloorDataVo = floorDic[floor];
			if(fvo == null){
				fvo = floorDic[floor] = new FloorDataVo();
			}
			var facDic:Dictionary = fvo.facDic;
			var meshList:Vector.<PointVo> = facDic[nodeId];
			if(meshList == null){
				meshList = facDic[nodeId] = new Vector.<PointVo>();
			}
			var p:PointVo = new PointVo(x,z,area);
			meshList.push(p);
			return p;
		}
		
		public static function getNodeList(floor:int,nodeId:int):Vector.<PointVo>{
			var fvo:FloorDataVo = floorDic[floor];
			return fvo != null ? fvo.facDic[nodeId] : null;
		}
		
		//		public static function removeNode(nodeId:int,p:PointVo):void{
		//			if(facDic[nodeId] == null){
		//				trace("目标点不存在");
		//				return;
		//			}
		//			var meshList:Vector.<PointVo> = facDic[nodeId];
		//			var index:int = meshList.indexOf(p);
		//			if(index >= 0){
		//				meshList.splice(index,1);//删除该数据
		//			}
		//		}
		/**
		 * 更新商铺数据
		 * @param index 模型深度
		 * @param number 编号
		 * @param classid 所属类型
		 */		
		public static function updateMeshInfo(floor:int,nameId:String,
											  number:String,attribute:int):MeshInfoVo{
			var fvo:FloorDataVo = floorDic[floor];
			if(fvo == null){
				fvo = floorDic[floor] = new FloorDataVo();
			}
			var ivo:MeshInfoVo = getMeshInfoByNameId(floor,nameId);
			if(ivo == null){
				ivo = new MeshInfoVo();
				ivo.nameId = nameId;
				ivo.floor = floor;
				fvo.meshInfoList.push(ivo);
			}
			ivo.number = number;
			ivo.attribute = attribute;
			return ivo;
		}
		
		public static function getMeshInfoByNameId(floor:int,nameId:String):MeshInfoVo{
			var fvo:FloorDataVo = floorDic[floor];
			if(fvo == null)return null;
			for each (var ivo:MeshInfoVo in fvo.meshInfoList) 
			{
				if(ivo.nameId == nameId){
					return ivo;
				}
			}
			return null;
		}
		
		public static function getInfoMinNumber(floor:int):int{
			var min:int = 10000;
			var fvo:FloorDataVo = floorDic[floor];
			for each (var ivo:MeshInfoVo in fvo.meshInfoList) 
			{
				var num:int = int(ivo.number);
				if(num < min){
					min = num;
				}
			}
			return min;
		}
		
		public static function getMeshInfoByNumber(floor:int,number:String):MeshInfoVo{
			var fvo:FloorDataVo = floorDic[floor];
			for each (var ivo:MeshInfoVo in fvo.meshInfoList) 
			{
				if(int(ivo.number) == int(number)){
					return ivo;
				}
			}
			return null;
		}
		
		/**
		 * 根据店家铺位详细数据获取各自位置的数据列表
		 * @param number
		 * @return 
		 */		
		public static function searchMeshInfoByMerchId(merchId:String):Vector.<MeshInfoVo>{
			var mList:Vector.<MeshInfoVo> = new Vector.<MeshInfoVo>();
			for each (var fvo:FloorDataVo in floorDic) 
			{
				for each (var ivo:MeshInfoVo in fvo.meshInfoList) 
				{
//					if(int(ivo.number) == int(merchId)){
//						return ivo;
//					}
					if(merchId.search(ivo.number) >= 0){
						mList.push(ivo);
					}
				}
			}
			return mList.length > 0 ? mList : null;
		}
		
		public static function hasFloorData(floor:int):Boolean{
			return floorDic[floor] !== undefined;
		}
		
		/**
		 * 保存所有数据为XML 导入到File
		 */		
		//		public static function saveAll():void
		//		{
		//			var xml:XML = <root></root>;
		//			var nodeRoot:XML = <nodeRoot></nodeRoot>;
		//			xml.appendChild(nodeRoot);
		//			for(var nodeId:* in facDic) 
		//			{//nodeId设施id
		//				var meshList:Vector.<PointVo> = facDic[nodeId];
		//				var nodes:XML = <nodes nodeId = {nodeId}></nodes>;
		//				nodeRoot.appendChild(nodes);
		//				for each (var pvo:PointVo in meshList) 
		//				{
		//					nodes.appendChild(<node x={pvo.x} z={pvo.z} />);
		//				}
		//			}
		//			var infoRoot:XML = <infoRoot></infoRoot>;
		//			xml.appendChild(infoRoot);
		//			for each (var ivo:InfoVo in meshInfoList) 
		//			{
		//				infoRoot.appendChild(<info nameId={ivo.nameId} number={ivo.number} 
		//					classid={ivo.classid} />);
		//			}
		//			FileManager.saveXml(xml);
		//		}
		
		public static function getMapList(floor:int,area:int):Vector.<Vector.<int>>{
			var fvo:FloorDataVo = floorDic[floor];
			return fvo.mapVector[area];
		}
		
		public static function getMapRows(floor:int):int{
			var fvo:FloorDataVo = floorDic[floor];
			return fvo.mapRows;
		}
		
		public static function getMapCols(floor:int):int{
			var fvo:FloorDataVo = floorDic[floor];
			return fvo.mapCols;
		}
		
		public static function createMap(floor:int,rows:int,cols:int,area:int):void{
			var fvo:FloorDataVo = floorDic[floor];
			if(fvo.mapVector == null){
				fvo.mapVector = new Vector.<Vector.<Vector.<int>>>();
			}
			if(fvo.mapRows == -1){
				fvo.mapRows = rows;
				fvo.mapCols = cols;
			}
			var mapList:Vector.<Vector.<int>> = fvo.mapVector[area] = new Vector.<Vector.<int>>();
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
		
		public static function setRotationY(floor:int,area:int,rotationY):void{
			initMapRotationY(floor);
			var fvo:FloorDataVo = floorDic[floor];
			fvo.mapRotationY[area] = rotationY;
		}
		
		private static function initMapRotationY(floor:int):void
		{
			var fvo:FloorDataVo = floorDic[floor];
			if(fvo.mapRotationY == null){
				fvo.mapRotationY = new Vector.<Number>();
				for (var i:int = 0; i < fvo.areaCount; i++) 
				{
					fvo.mapRotationY[i] = 0;
				}
			}
		}
		/**
		 * 获取该区域的旋转角度
		 * @param area
		 * @return 
		 */		
		public static function getRotationY(floor:int,area:int):Number{
			initMapRotationY(floor);
			var fvo:FloorDataVo = floorDic[floor];
			return fvo.mapRotationY[area];
		}
		/**
		 * 获取区域个数
		 * @param floor
		 * @return 
		 */		
		public static function getAreaCount(floor:int):int{
			var fvo:FloorDataVo = floorDic[floor];
			return fvo.areaCount; 
		}
		/**
		 * 设置目标路点值
		 * @param xIndex
		 * @param zIndex
		 * @param value
		 */		
		public static function setRoadValue(floor:int,indexX:int,indexZ:int,value:int,area:int):void{
			var fvo:FloorDataVo = floorDic[floor];
			if(indexX >= fvo.mapRows){
				trace("xIndex超过最大索引值" + fvo.mapRows);
				return;
			}
			if(indexZ >= fvo.mapCols){
				trace("zIndex超过最大索引值" + fvo.mapCols);
				return;
			}
			fvo.mapVector[area][indexX][indexZ] = value;
		}
		
		public static function updateFloorInfo(floor:int,fid:String,indexX:int,indexZ:int,area:int):FloorDataVo{
			var fvo:FloorDataVo = floorDic[floor];
			var ivo:FloorInfoVo = getFloorInfo(floor,fid);
			if(ivo == null){
				ivo = new FloorInfoVo();
				ivo.id = fid;
				if(fvo.floorList == null)fvo.floorList = new Vector.<FloorInfoVo>();
				fvo.floorList.push(ivo);
			}
			ivo.addFloorPos(indexX,indexZ,area);
			return fvo;
		}
		
		public static function updateLinkInfo(floor:int,lid:String,indexX:int,indexZ:int,area:int):LinkInfoVo{
			var fvo:FloorDataVo = floorDic[floor];
			var lvo:LinkInfoVo = getLinkInfo(floor,lid,area);
			if(lvo == null){
				lvo = new LinkInfoVo();
				lvo.id = lid;
				if(fvo.linkList == null)fvo.linkList = new Vector.<LinkInfoVo>();
				fvo.linkList.push(lvo);
			}
			lvo.addFloorPos(indexX,indexZ,area);
			return lvo;
		}
		
		public static function getLinkInfo(floor:int,lid:String,area:int):LinkInfoVo{
			var fvo:FloorDataVo = floorDic[floor];
			for each (var lvo:LinkInfoVo in fvo.linkList) 
			{
				if(lvo.id == lid && lvo.postion.area == area){
					return lvo;
				}
			}
			return null;
		}
		/**
		 * 获取某一区域内的所有关节点数据
		 * @param area
		 * @return 
		 */		
		public static function getAreaLink(floor:int,area:int):Vector.<LinkInfoVo>{
			var lList:Vector.<LinkInfoVo> = new Vector.<LinkInfoVo>();
			var fvo:FloorDataVo = floorDic[floor];
			for each (var lvo:LinkInfoVo in fvo.linkList) 
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
		public static function getAnotherLink(floor:int,tarVo:LinkInfoVo):LinkInfoVo{
			var fvo:FloorDataVo = floorDic[floor];
			for each (var lvo:LinkInfoVo in fvo.linkList) 
			{
				if(lvo != tarVo && lvo.id == tarVo.id){
					return lvo;
				}
			}
			return null;
		}
		
		public static function getFloorInfo(floor:int,floorId:String):FloorInfoVo{
			var fvo:FloorDataVo = floorDic[floor];
			for each (var ivo:FloorInfoVo in fvo.floorList) 
			{
				if(ivo.id == floorId){
					return ivo;
				}
			}
			return null;
		}
		
		public static function getFloorInfoList(floor:int):Vector.<FloorInfoVo>{
			var fvo:FloorDataVo = floorDic[floor];
			if(fvo != null){
				return fvo.floorList;
			}
			return null;
		}
		
		public static function getEarthNode(floor:int):PointVo
		{
			var fvo:FloorDataVo = floorDic[floor];
			return fvo.earthNode;
		}
		/**
		 * 设置地标坐标
		 */		
		public static function setEarthNode(floor:int,indexX:int,indexZ:int,area:int):void{
			var fvo:FloorDataVo = floorDic[floor];
			if(fvo.earthNode == null){
				fvo.earthNode = new PointVo(0,0,area);
			}
			fvo.earthNode.x = indexX;
			fvo.earthNode.z = indexZ;
			fvo.earthNode.area = area;
		}
		
		private static function setOffSet(floor:int,minX:Number,minZ:Number):void{
			var fvo:FloorDataVo = floorDic[floor];
			fvo.minX = minX;
			fvo.minZ = minZ;
		}
		
		public static function getMinX(floor:int):Number{
			var fvo:FloorDataVo = floorDic[floor];
			return fvo.minX;
		}
		
		public static function getMinZ(floor:int):Number{
			var fvo:FloorDataVo = floorDic[floor];
			return fvo.minZ;
		}
		
		
		
		public static const TAG_ONE:String = "|";
		public static const TAG_TWO:String = "_";
		public static function addXml(floor:int,xml:XML):void
		{
			if(xml != null){
				var roadRoot:XML = xml.roadRoot[0];
				if(roadRoot != null){
					var areaCount:int = roadRoot.@areaCount;
					var fvo:FloorDataVo = floorDic[floor];
					if(fvo == null){
						fvo = floorDic[floor] = new FloorDataVo();
						fvo.areaCount = areaCount;
					}
					var rows:int = roadRoot.@mapRows;
					var cols:int = roadRoot.@mapCols;
					setOffSet(floor,roadRoot.@minX,roadRoot.@minZ);
					if(roadRoot.hasOwnProperty("earth")){
						var earthXml:XML = roadRoot.earth[0];
						setEarthNode(floor,earthXml.@x,earthXml.@z,earthXml.@area);
					}
					var areaRoot:XML = roadRoot.areaRoot[0];
					if(areaRoot != null){
						for (var area:int = 0; area < areaCount; area++) 
						{
							var rotationY:Number = areaRoot.road[area].@rotationY;
							setRotationY(floor,area,rotationY);
							createMap(floor,rows,cols,area);//创建地图
							var roadMark:String = areaRoot.road[area];
							if(roadMark != null && roadMark != ""){
								var tempList:Array = roadMark.split(TAG_ONE);
								for each (var str:String in tempList) 
								{
									var sList:Array = str.split(TAG_TWO);
									setRoadValue(floor,sList[0],sList[1],0,area);
								}
							}
						}
					}
					var floorRoot:XML = roadRoot.floorRoot[0];
					if(floorRoot != null){
						for each (var floorXml:XML in floorRoot.floor) 
						{
							updateFloorInfo(floor,floorXml.@id,floorXml.@x,floorXml.@z,floorXml.@area);
						}
					}
					var linkRoot:XML = roadRoot.linkRoot[0];
					if(linkRoot != null){
						for each (var link:XML in linkRoot.link) 
						{
							updateLinkInfo(floor,link.@id,link.@x,link.@z,link.@area);
						}
					}
				}
				var nodeRoot:XML = xml.nodeRoot[0];
				for each (var nodes:XML in nodeRoot.nodes) 
				{
					var nodeId:int = nodes.@nodeId;
					for each (var node:XML in nodes.node) 
					{
						addNode(floor,nodeId,node.@x,node.@z,node.@area);
					}
				}
				var infoRoot:XML = xml.infoRoot[0];
				for each (var info:XML in infoRoot.info) 
				{
					var ivo:MeshInfoVo = updateMeshInfo(floor,info.@nameId,info.@number,info.@attribute);
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
import com.vo.FloorInfoVo;
import com.vo.LinkInfoVo;
import com.vo.MeshInfoVo;
import com.vo.PointVo;

import flash.utils.Dictionary;

class FloorDataVo{
	public var facDic:Dictionary = new Dictionary(true);
	public var meshInfoList:Vector.<MeshInfoVo> = new Vector.<MeshInfoVo>();
	public var mapVector:Vector.<Vector.<Vector.<int>>>;//默认值为1 0为可走点
	public var mapRows:int = -1;
	public var mapCols:int = -1;
	public var minX:Number;
	public var minZ:Number;
	public var earthNode:PointVo;//地标点
	public var floorList:Vector.<FloorInfoVo>;//楼道点
	public var linkList:Vector.<LinkInfoVo>;//关节点
	public var mapRotationY:Vector.<Number>;
	public var areaCount:int;
}