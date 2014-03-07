package com.utils
{
	import com.model.MerchModel;
	import com.vo.LinkInfoVo;
	import com.vo.PointVo;
	
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import away3d.containers.ObjectContainer3D;
	
	/**
	 * 
	 * @author GY
	 */	
	public class GameUtil
	{
		private static var searchStar:SearchStar;
		private static var searchCache:Dictionary = new Dictionary(true);//存放所有已经寻路的寻路点
		/**
		 * 获取对应始末点位置的寻路路径
		 * @param startRow 起始行列
		 * @param startCol
		 * @param endRow 终止行列
		 * @param endCol
		 * @param area 所属区域
		 * @return 
		 */		
		public static function search(floor:int,startRow:int,startCol:int,
									  endRow:int,endCol:int,area:int,mode:int = 1):Vector.<PointVo>{
			if(searchStar == null)searchStar = new SearchStar();
			if(searchCache[floor + "_" + startRow + "_" + startCol + "_" + endRow + "_" + endCol + "_" + area] !== undefined){
				var result:Vector.<PointVo> = searchCache[floor + "_" + startRow + "_" + startCol + "_" + endRow + "_" + endCol + "_" + area];
				return result;
			}
			searchStar.setMapList(MerchModel.getMapList(floor,area),MerchModel.getMapRows(floor),
				MerchModel.getMapCols(floor),area,SearchStar.DIRECT_EIGHT,mode);
			result = searchStar.search(startCol,startRow,endCol,endRow);
			searchCache[floor + "_" + startRow + "_" + startCol + "_" + endRow + "_" + endCol + "_" + area] = result;
			return result;
		}
		/**
		 * 获取两点之间距离
		 */		
		public static function getDistance(x1:Number, y1:Number, 
										   x2:Number, y2:Number):Number
		{
			return Math.sqrt(Math.pow(x1-x2,2) + Math.pow(y1-y2,2));
		}
		/**
		 * 获取两个视图之间坐标形成的夹角
		 * @return 
		 */		
		public static function getAngle(x1:Number, y1:Number, 
										x2:Number, y2:Number):Number{
			var dirtX:Number = x2 - x1;
			var dirtY:Number = y2 - y1;
			var angle:Number = Math.atan2(dirtY,dirtX) * 180 / Math.PI + 90;
			return (360 + angle) % 360;
		}
		/**
		 * 从目标点到地标之间进行递归寻路
		 * @param startRow
		 * @param startCol
		 * @param area
		 * @param ep
		 * @return 
		 */		
		public static function searchRoad(floor:int,startRow:int,startCol:int,area:int,ep:PointVo):Vector.<PointVo>{
			var searchLoad:Array = [];
			tryRoad(floor,startRow,startCol,area,new Dictionary(true),ep,searchLoad,true);
			searchLoad.sortOn("length",Array.NUMERIC);
			return searchLoad[0];
		}
		/**
		 * @param startRow
		 * @param startCol
		 * @param area
		 * @param table
		 * @param ep
		 * @param minV 寻找到的最短路径点数据
		 * @return 
		 * 
		 */		
		private static function tryRoad(floor:int,startRow:int,startCol:int,area:int,table:Dictionary,
										ep:PointVo,searchLoad:Array,isRoot:Boolean = false):Vector.<PointVo>
		{
			if(ep.area == area){
				var r:Vector.<PointVo> = search(floor,startRow,startCol,ep.x,ep.z,area);
				if(r != null){
					r = r.slice();
					if(isRoot)searchLoad.push(r.reverse());
					return r;
				}
			}
			var linkList:Vector.<LinkInfoVo> = MerchModel.getAreaLink(floor,area);
			for each (var lvo:LinkInfoVo in linkList) 
			{//判断当前关节点是否已经回路 没有再判断关节点之间是否能联通
				if(table[lvo.id] === undefined){//该关节还未参与寻路
					var lPoint:PointVo = lvo.postion;
					r = search(floor,startRow,startCol,lPoint.x,lPoint.z,area);
					if(r != null){//表示能连通
						r = r.slice();
						r.pop();
						table[lvo.id] = true;
						//获取对应关节查找下一个入口
						var avo:LinkInfoVo = MerchModel.getAnotherLink(floor,lvo);
						if(avo == null)continue;//还没设置好关节点
						lPoint = avo.postion;
						var result:Vector.<PointVo> = tryRoad(floor,lPoint.x,lPoint.z,lPoint.area,table,ep,searchLoad);
						if(result != null){
							var rList:Vector.<PointVo> = r.concat(result);//已经寻找到出路 最终返回
							if(isRoot){//回到根位置
								searchLoad.push(rList.reverse());
							}else return rList; //不是根位置的继续寻找
							//							if(minV == null || rList.length < minV.length)minV = rList;
						}
						delete table[lvo.id];//没有找到只能舍弃 继续寻找下一个
					}
				}
			}
			return null;
		}		
		
		public static const SEARCH_FLOOR_UP:String = "SEARCH_FLOOR_UP";//上楼
		public static const SEARCH_FLOOR_DOWN:String = "SEARCH_FLOOR_DOWN";//从楼下走上
		//电梯上下...
		public static const SEARCH_NONE:String = "SEARCH_NONE";//地面搜索
		public static const SCENE_AREA:int = -1;
		public static var size:Number = 2;//网格尺寸大小
		public static var gap:Number = 2;//间隙个数
		
		public static var createSearchMesh:Function;
		
		public static function roadStart(floor:int,v:Vector.<PointVo>,searchType:String,
										 onComplete:Function = null,args:Array = null):void
		{
			if(v == null)return;
			var rList:Array = [];
			var index:int;
			var minX:Number = MerchModel.getMinX(floor);
			var minZ:Number = MerchModel.getMinZ(floor);
			var tempList:Vector.<ObjectContainer3D> = new Vector.<ObjectContainer3D>();
			for (var i:int = 0; i < v.length - 1; i++) 
			{
				var prePoint:PointVo = v[i];
				var nowPoint:PointVo = v[i + 1];
				//				createSearchMesh(tempList,floor,prePoint.area,ppx,ppz,index ++);
				//				continue;
				if(prePoint.area != nowPoint.area){//应该是直线连接
					if(rList.length != 0){//弯折点需要铺设再次
						index = createGapMesh(tempList,floor,prePoint.area,rList[0],prePoint,index,minX,minZ);
						rList.length = 0;//再次清空
					}else{
						if(i != 0){//添加中间的间隔
							ppPoint = v[i - 1];//找出前一个点
							index = createGapMesh(tempList,floor,prePoint.area,ppPoint,prePoint,index,minX,minZ);
						}
					}
					var ppx:Number = prePoint.x * size + minX;
					var ppz:Number = prePoint.z * size + minZ;
					var npx:Number = nowPoint.x * size + minX;
					var npz:Number = nowPoint.z * size + minZ;
					var pa1:Vector3D = createSearchMesh(tempList,floor,prePoint.area,ppx,ppz,index ++);
					var pa2:Vector3D = createSearchMesh(tempList,floor,nowPoint.area,npx,npz,index ++);
					createLineMesh(tempList,floor,SCENE_AREA,pa1,pa2,index/*,minX,minZ*/);
					continue;
				}
				var area:int = prePoint.area;
				if(prePoint.x != nowPoint.x && prePoint.z != nowPoint.z){
					//弯折点
					if(rList.length == 0){//存入第一个
						rList.push(prePoint);
						if(i != 0){//添加中间的间隔
							var ppPoint:PointVo = v[i - 1];//找出前一个点
							index = createGapMesh(tempList,floor,area,ppPoint,prePoint,index,minX,minZ);
						}
					}
					index = checkCircleLast(i,tempList,v,floor,area,rList,nowPoint,index,minX,minZ,onComplete,args);
				}else{
					index = checkOther(i,tempList,v,floor,area,rList,prePoint,nowPoint,index,minX,minZ,onComplete,args);
				}
			}//end for
			if(searchType == SEARCH_NONE){
				return;
			}
			var c:int = 10 * (gap + 1);
			var time:int = 1;
			var perZ:Number = size / (gap + 1) * Math.tan(25 * Math.PI / 180);//计算z轴走路步进
			if(searchType == SEARCH_FLOOR_UP){//上楼 最后几个y轴上升
				for (var j:int = tempList.length - c; j < tempList.length; j++) 
				{
					var node:ObjectContainer3D = tempList[j];
					node.y += perZ * time ++;
				}
			}else if(searchType == SEARCH_FLOOR_DOWN){
				for (j = c; j >= 0; j--) 
				{
					if(j < tempList.length){
						node = tempList[j];
						node.y -= perZ * time ++;
					}
				}
			}
		}
		
		private static function checkOther(i:int,tempList:Vector.<ObjectContainer3D>,v:Vector.<PointVo>,floor:int,
										   area:int,rList:Array,prePoint:PointVo,nowPoint:PointVo,
										   index:int, minX:Number, minZ:Number,
										   onComplete:Function = null,args:Array = null):int{
			if(rList.length != 0){//说明是最后一个
				//圆周算法创建并存储数据 首尾点正常布局 中间的点过度
				var pp:PointVo = rList[0];
				var np:PointVo = prePoint;
				var ppx:Number = pp.x * size + minX;
				var ppz:Number = pp.z * size + minZ;
				var npx:Number = np.x * size + minX;
				var npz:Number = np.z * size + minZ;
				var preIndex:int = v.indexOf(pp);
				if(preIndex - 1 >= 0)
					var forPoint:PointVo = v[preIndex - 1];//前面的前面
				var nextIndex:int = v.indexOf(np);
				if(nextIndex + 1 < v.length)//找得到下一个点
					var latPoint:PointVo = v[nextIndex + 1];//后面的后面
				//确定中心坐标
				createSearchMesh(tempList,floor,area,ppx,ppz,index ++);
				if(forPoint != null && pp.z == forPoint.z && np.z == latPoint.z){//前后成一直线
					var towX:Number = (ppx + npx) / 2;
					var towZ:Number = (ppz + npz) / 2;//找出他们之间的中心位置
					cz = towZ;
					cx = ppx;
					index = createCircleRound(tempList,floor,area,ppx,ppz,towX,towZ,cx,cz,index,minX,minZ);
					createSearchMesh(tempList,floor,area,towX,towZ,index ++);
					cz = towZ;
					cx = npx;
					index = createCircleRound(tempList,floor,area,towX,towZ,npx,npz,cx,cz,index,minX,minZ);
				}else if(forPoint != null && pp.x == forPoint.x && np.x == latPoint.x){
					towX = (ppx + npx) / 2;
					towZ = (ppz + npz) / 2;//找出他们之间的中心位置
					cz = ppz;
					cx = towX;
					index = createCircleRound(tempList,floor,area,ppx,ppz,towX,towZ,cx,cz,index,minX,minZ);
					createSearchMesh(tempList,floor,area,towX,towZ,index ++);
					cz = npz;
					cx = towX;
					index = createCircleRound(tempList,floor,area,towX,towZ,npx,npz,cx,cz,index,minX,minZ);
				}else{
					if(prePoint.z == nowPoint.z){
						var cz:Number = ppz;
						var cx:Number = npx;
					}else if(prePoint.x == nowPoint.x){
						cz = npz;
						cx = ppx;
					}
					index = createCircleRound(tempList,floor,area,ppx,ppz,npx,npz,cx,cz,index,minX,minZ);
				}
				if(i == v.length - 2){//最后一个
					createSearchMesh(tempList,floor,area,npx,npz,index ++,onComplete,args);
				}else{
					createSearchMesh(tempList,floor,area,npx,npz,index ++);
				}
				rList.length = 0;
			}else{//正常存入
				var x:Number = prePoint.x * size + minX;
				var z:Number = prePoint.z * size + minZ;
				if(i != 0){//添加中间的间隔
					var ppPoint:PointVo = v[i - 1];//找出前一个点
					if(ppPoint.area == prePoint.area){//在同一区间的连接
						index = createGapMesh(tempList,floor,area,ppPoint,prePoint,index,minX,minZ);
					}
				}
				createSearchMesh(tempList,floor,area,x,z,index ++);
				if(i == v.length - 2){//最后一个
					x = nowPoint.x * size + minX;
					z = nowPoint.z * size + minZ;
					index = createGapMesh(tempList,floor,area,prePoint,nowPoint,index,minX,minZ);
					createSearchMesh(tempList,floor,area,x,z,index ++,onComplete,args);
				}
			}
			return index;
		}
		
		private static function createCircleRound( tempList:Vector.<ObjectContainer3D>,floor:int,
												   area:int,px:Number,pz:Number,nx:Number,nz:Number,cx:Number,cz:Number,
												  index:int, minX:Number, minZ:Number):int{
			var r:Number = Math.abs(px - nx);//半径
			var preA:Number = Math.atan2(px - cx,pz - cz) / Math.PI * 180;
			var nowA:Number = Math.atan2(nx - cx,nz - cz) / Math.PI * 180;
			var count:int = Math.round(r / size) * (gap/* + 1*/);//切角个数
			return createAngleMesh(tempList,floor,area,r,cz,cx,preA,nowA,count,index);
		}
		
		private static function checkCircleLast(i:int,tempList:Vector.<ObjectContainer3D>,v:Vector.<PointVo>,floor:int,
										  area:int,rList:Array,nowPoint:PointVo,
										  index:int, minX:Number, minZ:Number,
										  onComplete:Function = null,args:Array = null):int{
			if(i == v.length - 2){//最后一个
				var pp:PointVo = rList[0];
				var np:PointVo = nowPoint;
				
				var preIndex:int = v.indexOf(pp);
				var forPoint:PointVo = v[preIndex - 1];//前面的前面
				var nextIndex:int = v.indexOf(np);
				if(nextIndex + 1 < v.length)//找得到下一个点
					var latPoint:PointVo = v[nextIndex + 1];//后面的后面
				
				var ppx:Number = pp.x * size + minX;
				var ppz:Number = pp.z * size + minZ;
				var npx:Number = np.x * size + minX;
				var npz:Number = np.z * size + minZ;
				
				createSearchMesh(tempList,floor,area,ppx,ppz,index ++);
				if(latPoint != null && pp.z == forPoint.z && np.z == latPoint.z){//前后成一直线
					var towX:Number = (ppx + npx) / 2;
					var towZ:Number = (ppz + npz) / 2;//找出他们之间的中心位置
					cz = towZ;
					cx = ppx;
					index = createCircleRound(tempList,floor,area,ppx,ppz,towX,towZ,cx,cz,index,minX,minZ);
					createSearchMesh(tempList,floor,area,towX,towZ,index ++);
					cz = towZ;
					cx = npx;
					index = createCircleRound(tempList,floor,area,towX,towZ,npx,npz,cx,cz,index,minX,minZ);
				}else if(latPoint != null && pp.x == forPoint.x && np.x == latPoint.x){
					towX = (ppx + npx) / 2;
					towZ = (ppz + npz) / 2;//找出他们之间的中心位置
					cz = ppz;
					cx = towX;
					index = createCircleRound(tempList,floor,area,ppx,ppz,towX,towZ,cx,cz,index,minX,minZ);
					createSearchMesh(tempList,floor,area,towX,towZ,index ++);
					cz = npz;
					cx = towX;
					index = createCircleRound(tempList,floor,area,towX,towZ,npx,npz,cx,cz,index,minX,minZ);
				}else{
					if(forPoint.z == pp.z){
						var cz:Number = npz;
						var cx:Number = ppx;
					}else if(forPoint.x == pp.x){
						cz = ppz;
						cx = npx;
					}
					index = createCircleRound(tempList,floor,area,ppx,ppz,npx,npz,cx,cz,index,minX,minZ);
				}
				createSearchMesh(tempList,floor,area,npx,npz,index ++,onComplete,args);
			}
			return index;
		}
		
		private static function createLineMesh(tempList:Vector.<ObjectContainer3D>,floor:int,
											  area:int,ap1:Vector3D, ap2:Vector3D, index:int/*, 
											  minX:Number, minZ:Number*/):int
		{
			if(gap == 0)return index;//不需要间隔
			var dis:Number = getDistance3D(ap1.x,ap1.y,ap1.z,ap2.x,ap2.y,ap2.z);
			if(dis <= size / gap)return index;//距离少于最小值也不需要
			var count:int = dis / (size / gap);
			for (var i:int = 1; i < count + 1; i++) 
			{
				var para:Number = 1/2;//i / (count + 1);
				createSearchMesh(tempList,floor,area,
					(ap1.x + ap2.x) * para,(ap1.z + ap2.z) * para,index ++);
			}
			return index;
		}
		
		private static function getDistance3D(x1:Number,y1:Number,z1:Number,x2:Number,y2:Number,z2:Number):Number{
			return Math.sqrt(Math.pow(x1 - x2,2) + Math.pow(y1 - y2,2) + Math.pow(z1 - z2,2));
		}
		
		/**
		 * 直线连接连个路点数据
		 * @return 
		 */		
		private static function createGapMesh(tempList:Vector.<ObjectContainer3D>,floor:int,
											  area:int,pp:PointVo, np:PointVo, index:int, 
											  minX:Number, minZ:Number):int
		{
			if(gap == 0)return index;//不需要间隔
			if(pp.x == np.x){
				var ppx:Number = pp.x * size + minX;
				var ppz:Number = pp.z * size + minZ;
				var npz:Number = np.z * size + minZ;
				var perZ:Number = (npz - ppz) / gap;
				for (var i:int = 1; i <= gap; i++) 
				{
					createSearchMesh(tempList,floor,area,ppx,ppz + perZ * i,index ++);
				}
			}else{
				ppx = pp.x * size + minX;
				var npx:Number = np.x * size + minX;
				ppz = pp.z * size + minZ;
				var perX:Number = (npx - ppx) / gap;
				for (i = 1; i <= gap; i++) 
				{
					createSearchMesh(tempList,floor,area,ppx + perX * i,ppz,index ++);
				}
			}
			return index;
		}
		/**
		 * 圆弧连接
		 * @return 
		 */		
		private static function createAngleMesh(tempList:Vector.<ObjectContainer3D>,floor:int,
												area:int, r:Number,cz:Number, cx:Number, 
												preA:Number, nowA:Number, count:int,index:int):int
		{
			var disA:Number = nowA - preA;
			if(Math.abs(disA) > 180){
				disA = disA < 0 ? (disA + 360) : (disA - 360);
			}
			var perAngle:Number = disA / (count + 1);//切分角
			for (var i:int = 1; i <= count; i++) 
			{
				var radians:Number = (preA + i * perAngle) * Math.PI / 180;
				var z:Number = Math.cos(radians) * r + cz;
				var x:Number = Math.sin(radians) * r + cx;
				createSearchMesh(tempList,floor,area,x,z,index ++);
			}
			return index;
		}
		
		
		
		
		
		
		
		
		
	}
}